library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_controller is
    generic( max_size : integer);
    port(
        --inputs
        clk             : in std_logic;
        canRead         : in std_logic;
        nn_opcode       : in std_logic_vector(23 downto 0);
        load_finished   : in std_logic;
        mult_finished   : in std_logic;
        unload_finished : in std_logic;

        --outputs
        read_data    : out std_logic;
        start_load   : out std_logic;
        start_mult   : out std_logic;
        start_unload : out std_logic;
        rows1        : out integer range 0 to max_size;
        columns1     : out integer range 0 to max_size;
        rows2        : out integer range 0 to max_size;
        columns2     : out integer range 0 to max_size
    );
end nn_controller;
    
    
architecture rtl of nn_controller is
    type state is (waiting,loading,multiplying,unloading);

    signal controls : std_logic_vector( 0 downto 0);
    signal information : std_logic_vector(23 downto 0) := "00001" & "00001" & "00001" & "00001" & x"0";
    signal op       : std_logic;
    signal current_state : state := waiting;
    signal next_state    : state := waiting;
    signal rows1_i       : integer := 1;
    signal columns1_i    : integer := 1;
    signal rows2_i       : integer := 1;
    signal columns2_i    : integer := 1;


    function to_integer (constant i : in std_logic_vector) return INTEGER is
        -- Funktion: Umwandeln eines Bit-Vektor-Wertes in eine Integer-Zahl
        variable i_tmp : std_logic_vector (0 to i'length-1);
        variable int_tmp : INTEGER := 0;	
    begin
        i_tmp := i;
        for m in 0 to i'length-1 loop
            if i_tmp(m) = '1' then
                int_tmp := int_tmp + 2**(i'length-1 - m); 
            end if;
        end loop;
        return int_tmp;
    end to_integer;


begin

    rows1    <= rows1_i;
    columns1 <= columns1_i;
    rows2    <= rows2_i;  --columns1 and rows1 should be equal
    columns2 <= columns2_i;

    rows1_i    <= to_integer(information(23 downto 19));
    columns1_i <= to_integer(information(18 downto 14));
    rows2_i    <= to_integer(information(13 downto 9));  --columns1 and rows1 should be equal
    columns2_i <= to_integer(information(8 downto 4));
    op         <= information(0);

    process(current_state, canRead, nn_opcode, load_finished, mult_finished, unload_finished)begin
        if current_state = waiting and canRead = '1' then
            information <= nn_opcode;
            next_state <= loading;
        elsif current_state = loading and load_finished = '1' then
            next_state <= multiplying;
        elsif current_state = multiplying and mult_finished = '1' then
            next_state <= unloading;
        elsif current_state = unloading and unload_finished = '1' then
            next_state <= waiting;
        end if;
    end process;

    process(clk)begin
        if rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    start_load   <= '1' when current_state = loading     else '0'; --op = '1' and
    start_mult   <= '1' when current_state = multiplying else '0'; --op = '1' and
    start_unload <= '1' when current_state = unloading   else '0'; --op = '1' and
    read_data    <= '1' when current_state = waiting else '0';

end rtl;
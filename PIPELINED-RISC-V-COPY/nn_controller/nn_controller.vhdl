library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_controller is
    generic(max_entries : integer range 2 to 255 := 3); -- the max number of entries in the matrix.
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
        entries      : out integer range 0 to 255;
        size         : out integer range 0 to 15
    );
end nn_controller;
    
    
architecture rtl of nn_controller is
    type state is (waiting,loading,multiplying,unloading);

    signal controls : std_logic_vector( 0 downto 0);
    signal information : std_logic_vector(23 downto 0);
    signal op       : std_logic_vector(3 downto 0);
    signal current_state : state := waiting;
    signal next_state    : state := waiting;


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

    entries <= to_integer(information(23 downto 16));
    size    <= to_integer(information( 15 downto 12));
    op      <= information(11 downto 8);

    process(op)begin
        case op is
            when "0001" => controls <= "1"; --Matrixmultiplication
            when others => controls <= "-"; --undefined for other cases
        end case;
    end process;

    process(current_state, canRead, nn_opcode)begin
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

    start_load   <= '1' when controls(0) = '1' and current_state = loading     else '0';
    start_mult   <= '1' when controls(0) = '1' and current_state = multiplying else '0';
    start_unload <= '1' when controls(0) = '1' and current_state = unloading   else '0';
    read_data    <= '1' when current_state = waiting else '0';

end rtl;
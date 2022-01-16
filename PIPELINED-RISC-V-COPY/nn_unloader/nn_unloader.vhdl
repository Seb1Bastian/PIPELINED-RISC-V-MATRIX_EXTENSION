library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_unloader is
    generic(max_size : integer range 2 to 255 := 3); -- the max number of rows and colums in the matrix.
    port(
        --inputs
        clk             : in std_logic;
        size            : in integer;
        entries         : in integer;
        canWrite        : in std_logic;
        start_unload    : in std_logic;
        matrix          : in BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);
        reset           : in std_logic;
        --outputs
        unload_finished : out std_logic;
        write_to_CPU    : out std_logic;
        data_out        : out std_logic_vector(31 downto 0)
    );
end nn_unloader;
    
    
architecture rtl of nn_unloader is
    type state is (waiting,init,unloading,finished);
    signal information : std_logic_vector(23 downto 0);
    signal current_state : state := waiting;
    signal next_state    : state := waiting;
    signal matrix_entries : integer range 0 to 255 := 0;
    signal write_en      : std_logic;
begin



    process(clk,start_unload,reset)
    begin
        if reset = '1' then
            next_state <= waiting;
        elsif current_state = waiting and start_unload = '1' then
            next_state <= init;
        elsif current_state = init then
            next_state <= unloading;
        elsif current_state = unloading and matrix_entries = entries then
            next_state <= finished;
        elsif current_state = finished then
            next_state <= waiting;
        end if;
    end process;

    process(clk)
        begin
            if rising_edge(clk) and reset = '1' then
                matrix_entries <= 0;
            elsif rising_edge(clk) and write_en = '1' then                          
                if matrix_entries = entries then
                    matrix_entries <= 0;
                else
                    matrix_entries <= matrix_entries + 1;
                end if;
            end if;
        end process;
    
    process(clk)
    variable pos_x1, pos_x2 : integer range 0 to 255 := 0;
    begin
        if(rising_edge(clk)) then
            if reset = '1' then
                pos_x1 := 0;
                pos_x2 := 0;
                data_out <= x"00000000";
            elsif current_state = unloading and canWrite = '1' then
                data_out <= x"000000" & matrix(pos_x1,pos_x2);
                if pos_x2 = size-1 then
                    pos_x2 := 0;
                    if pos_x1 = size-1 then
                        pos_x1 := 0;
                    else
                        pos_x1 := pos_x1 + 1;
                    end if;
                else
                    pos_x2 := pos_x2 + 1;
                end if;   
            end if;
        end if;
    end process;

    write_en         <= '1' when current_state = unloading and canWrite = '1' else '0';
    unload_finished  <= '1' when current_state = finished  else '0';
    write_to_CPU     <= '1' when current_state = unloading else '0';
end rtl;
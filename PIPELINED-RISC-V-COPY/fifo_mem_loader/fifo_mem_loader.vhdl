library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem_loader is
    generic(max_entries : integer range 2 to 255 := 3); -- the max number of entries in the matrix.
    port(
        --inputs
        clk             : in std_logic;
        start           : in std_logic;
        reset           : in std_logic;  -- synchron Reset
        can_read        : in std_logic;
        entries         : in integer range 0 to 255;   -- size of Matrix

        --outputs
        finished_load   : out std_logic;
        read_data       : out std_logic;
        init_grid       : out std_logic;
        write_en1       : buffer std_logic;
        write_en2       : buffer std_logic
    );
end fifo_mem_loader;


architecture rtl of fifo_mem_loader is

    type state is (waiting,init,matrix_1,matrix_2,finished);

    signal current_state : state;
    signal next_state    : state;
    signal matrix_entries_1   : integer range 0 to 255 :=0;
    signal matrix_entries_2   : integer range 0 to 255 :=0;

    begin

        process(clk,start,reset)
        begin
            if current_state = waiting and start = '1' then
                next_state <= init;
            elsif current_state = init then
                next_state <= matrix_1;
            elsif current_state = matrix_1 and matrix_entries_1 = entries then
                next_state <= matrix_2;
            elsif current_state = matrix_2 and matrix_entries_2 = entries then
                next_state <= finished;
            elsif current_state = finished then
                next_state <= waiting;
            end if;
        end process;

        process(clk)
        begin
            if(rising_edge(clk)) then
                if reset = '1' then 
                    current_state <= waiting;
                else
                    current_state <= next_state;
                end if;
            end if;
        end process;

        process(clk)
        begin
            if rising_edge(clk) and reset = '1' then
                matrix_entries_1 <= 0;
            elsif rising_edge(clk) and write_en1 = '1' then                          
                if matrix_entries_1 = entries then
                    matrix_entries_1 <= 0;
                else
                matrix_entries_1 <= matrix_entries_1 + 1;
                end if;
            end if;
        end process;

        process(clk)
        begin
            if rising_edge(clk) and reset = '1' then
                matrix_entries_2 <= 0;
            elsif rising_edge(clk) and write_en2 = '1' then                          
                if matrix_entries_2 = entries then
                    matrix_entries_2 <= 0;
                else
                matrix_entries_2 <= matrix_entries_2 + 1;
                end if;
            end if;
        end process;


        write_en1 <= '1' when can_read = '1' and current_state = matrix_1 else '0';
        write_en2 <= '1' when can_read = '1' and current_state = matrix_2 else '0';
        read_data <= '1' when current_state = matrix_1 or current_state = matrix_2 else '0';
        finished_load <= '1' when current_state = finished else '0';
        init_grid <= '1' when current_state = init else '0';

end rtl;
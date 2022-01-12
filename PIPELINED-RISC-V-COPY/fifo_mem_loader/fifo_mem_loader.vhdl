library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem_loader is
    generic(max_entries : integer range 2 to 255 := 3); -- the max number of entries in the matrix.
    port(
        --inputs
        clk         : in std_logic;
        start       : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        next_input  : in std_logic;
        entries     : in integer range 0 to 255;   -- size of Matrix

        --outputs
        finished_load : out std_logic;

        init_gird   : out std_logic;
        write_en1   : out std_logic;
        write_en2   : out std_logic
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
                matrix_entries_1 = 0;
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
                matrix_entries_2 = 0;
            elsif rising_edge(clk) and write_en2 = '1' then                          
                if matrix_entries_2 = entries then
                    matrix_entmatrix_entries_2ries <= 0;
                else
                matrix_entries_2 <= matrix_entries_2 + 1;
                end if;
            end if;
        end process;

        process(can_read, current_state)
        begin
            write_en1 <= can_read and to_std_logic(current_state = matrix_1);
            write_en2 <= can_read and to_std_logic(current_state = matrix_2);
            read_data <= to_std_logic(current_state = matrix_1 or current_state = matrix_2);
            finished_load <= to_std_logic(current_state = finished);
            init_gird <= to_std_logic(current_state = init);
        end process;

end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem_loader is
    generic(max_size : integer); -- the max number of rows and colums in the matrix.
    port(
        --inputs
        clk             : in std_logic;
        start           : in std_logic;
        reset           : in std_logic;                     -- synchron Reset
        can_read        : in std_logic;
        rows1           : in integer range 0 to max_size;   --says how big the matrix are
        columns1        : in integer range 0 to max_size;   --should be from 1 to max_size but ghdl doesn't want it to happen.
        rows2           : in integer range 0 to max_size;
        columns2        : in integer range 0 to max_size;

        --outputs
        finished_load   : out std_logic;
        read_data       : out std_logic;                        --
        init_grid       : out std_logic;
        pos_x11         : out integer range 0 to max_size-1;    --index for the next value
        pos_x12         : out integer range 0 to max_size-1;
        pos_x21         : out integer range 0 to max_size-1;
        pos_x22         : out integer range 0 to max_size-1;
        write_en1       : buffer std_logic;                     --says whether the conditions are met to write a value into the matrix 1 memory with the next positive clock edge.
        write_en2       : buffer std_logic                      --says whether the conditions are met to write a value into the matrix 2 memory with the next positive clock edge.
    );
end fifo_mem_loader;


architecture rtl of fifo_mem_loader is

    type state is (waiting,init,matrix_1,matrix_2,finished,finished2);

    signal current_state : state := waiting;
    signal next_state    : state;
    signal pos_x11_i, pos_x12_i ,pos_x21_i, pos_x22_i : integer  range 0 to max_size := 0;
    signal column1dif, row2dif : integer  range 0 to max_size := 0;

    begin

        aa :process(current_state,clk,start,reset,rows1,columns1,rows2,columns2,pos_x11_i,pos_x12_i,pos_x21_i,pos_x22_i,can_read)
        begin
            if current_state = waiting and start = '1' then                                                                 --initilaize loading if controllsignal says start
                next_state <= init;
            elsif current_state = init then
                next_state <= matrix_1;
            elsif current_state = matrix_1 and pos_x11_i = rows1-1 and pos_x12_i = max_size-1 and can_read = '1' then       --start loading matrix 2 if matrix 1 is ready
                next_state <= matrix_2;
            elsif current_state = matrix_2 and pos_x21_i = max_size-1 and pos_x22_i = columns2-1 and can_read = '1' then
                next_state <= finished;
            elsif current_state = finished then
                next_state <= finished2;
            elsif current_state = finished2 then
                next_state <= waiting;
            else
                next_state <= current_state;
            end if;
        end process;

        bb : process(clk)
        begin
            if(rising_edge(clk)) then
                if reset = '1' then 
                    current_state <= waiting;
                else
                    current_state <= next_state;
                end if;
            end if;
        end process;

        

        cc : process(clk)                               --Computes the index for the next value (for the first matrix).
        begin
            if(rising_edge(clk)) then
                if(reset = '1') then
                    pos_x11_i <= 0;
                    pos_x12_i <= 0;
                elsif current_state = init then
                        pos_x11_i <= 0;
                        pos_x12_i <= column1dif; 
                elsif write_en1 = '1' then
                    if pos_x12_i = max_size-1 then
                        pos_x12_i <= column1dif;
                        if pos_x11_i = rows1-1 then
                            pos_x11_i <= 0;
                        else
                            pos_x11_i <= pos_x11_i + 1;
                        end if;
                    else
                        pos_x12_i <= pos_x12_i + 1;
                    end if;
                end if;
            end if;
        end process;


        dd : process(clk)                               --Computes the index for the next value (for the second matrix).
        begin
            if(rising_edge(clk)) then
                if(reset = '1') then
                    pos_x21_i <= 0;
                    pos_x22_i <= 0;
                elsif current_state = init then
                    pos_x21_i <= row2dif;
                    pos_x22_i <= 0;                    
                elsif write_en2 = '1' then
                    if pos_x22_i = columns2-1 then
                        pos_x22_i <= 0;
                        if pos_x21_i = max_size-1 then
                            pos_x21_i <= row2dif;
                        else
                            pos_x21_i <= pos_x21_i + 1;
                        end if;
                    else
                        pos_x22_i <= pos_x22_i + 1;
                    end if;
                end if;
            end if;                    
        end process;


        write_en1 <= '1' when can_read = '1' and current_state = matrix_1 else '0';
        write_en2 <= '1' when can_read = '1' and current_state = matrix_2 else '0';
        read_data <= '1' when (current_state = matrix_1 or current_state = matrix_2)  and can_read = '1' else '0';
        finished_load <= '1' when current_state = finished else '0';
        init_grid <= '1' when current_state = init else '0';
        column1dif <= max_size - columns1;
        row2dif <= max_size - rows2;
        pos_x11 <= pos_x11_i;
        pos_x12 <= pos_x12_i;
        pos_x21 <= pos_x21_i;
        pos_x22 <= pos_x22_i;

end rtl;
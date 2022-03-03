library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_unloader is
    generic(max_size : integer); -- the max number of rows and colums in the matrix.
    port(
        --inputs
        clk             : in std_logic;
        rows            : in integer range 0 to max_size;
        columns         : in integer range 0 to max_size;
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
    type state is (waiting,init,unloading,finished,finished2);
    signal current_state : state := waiting;
    signal next_state    : state := waiting;
    signal write_en      : std_logic;
    signal pos_x1, pos_x2 : integer  range 0 to max_size-1 := 0;
begin



    process(current_state,reset,start_unload,reset, pos_x1, pos_x2,rows,columns,write_en)
    begin
        if reset = '1' then
            next_state <= waiting;
        elsif current_state = waiting and start_unload = '1' then
            next_state <= init;
        elsif current_state = init then
            next_state <= unloading;
        elsif current_state = unloading and pos_x1 = rows-1 and pos_x2 = columns-1 and write_en = '1' then
            next_state <= finished;
        elsif current_state = finished then
            next_state <= finished2;
        elsif current_state = finished2 then
            next_state <= waiting;
        else
            next_state <= current_state;
        end if;
    end process;

    process(clk,reset)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                current_state <= waiting;
            else
                current_state <= next_state;
            end if;
        end if;
    end process;

    process(clk) begin
        if(rising_edge(clk)) then
            if reset = '1' then
                pos_x1 <= 0;
                pos_x2 <= 0;
            elsif write_en = '1' then                          
                if pos_x2 = columns-1 then
                    pos_x2 <= 0;
                    if pos_x1 = rows-1 then
                        pos_x1 <= 0;
                    else
                        pos_x1 <= pos_x1 + 1;
                    end if;
                else
                    pos_x2 <= pos_x2 + 1;
                end if;
            end if;
        end if;
    end process;
    
    data_out <= x"000000" & matrix(pos_x1,pos_x2);

    write_en         <= '1' when current_state = unloading and canWrite = '1' else '0';
    unload_finished  <= '1' when current_state = finished or current_state = finished2  else '0';
    write_to_CPU     <= '1' when current_state = unloading and canWrite = '1' else '0';
end rtl;
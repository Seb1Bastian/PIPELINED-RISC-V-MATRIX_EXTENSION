library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_grid is
    generic(max_size : integer); -- the max
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        shift       : in std_logic;
        write_en    : in std_logic;
        pos_x1      : in integer range 0 to max_size-1;
        pos_x2      : in integer range 0 to max_size-1;

        data_in        : in std_logic_vector(7 downto 0);

        --outputs
        data_out    : out BYTE_GRID(max_size-1 downto 0,max_size-1 downto 0) 
    );
end fifo_grid;


architecture rtl of fifo_grid is

    Signal grid : BYTE_GRID( max_size-1 downto 0, max_size-1 downto 0); -- (0,0) is the upper left corner. (size-1, size-1) is the lower right corner.
    
    begin
        process(clk)
        begin
            if(rising_edge(clk)) then
                if(reset = '1') then
                    for i in 0 to max_size-1 loop                   --everthing to zero
                        for j in 0 to max_size-1 loop
                            grid(i,j) <= x"00";
                        end loop ;     
                    end loop ;
                elsif write_en = '1' then
                    grid(pos_x1,pos_x2) <= data_in;
                elsif shift = '1' then
                    for i in max_size-1 downto 0 loop
                        for j in max_size-1 downto 1 loop
                            grid(i,j) <= grid(i,j-1);
                        end loop ;     
                    end loop ;
                    for i in max_size-1 downto 0 loop
                        grid(i,0) <= x"00";
                    end loop ;
                end if;
            end if;
        end process;

        data_out <= grid;
end rtl;
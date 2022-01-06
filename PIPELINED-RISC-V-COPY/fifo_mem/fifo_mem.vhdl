library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem is
    generic(size : integer range 2 to 255 := 3); -- the specificed number of rising edges of the ended signal turns to one
    port(
        --inputs
        clk         : in std_logic;
        initialize  : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        pos_x       : in integer;
        pos_y       : in integer;
        write_en    : in std_logic;

        data_in        : in std_logic_vector(7 downto 0);

        --outputs
        data_out    : out BYTE_VECTOR(size-1 downto 0)  -- is 1 when it is finished counting else 0
    );
end fifo_mem;


architecture rtl of fifo_mem is

    signal vector : BYTE_VECTOR(size-1 downto 0);
    Signal grid : BYTE_GRID( size-1 downto 0, size-1 downto 0); -- (0,0) is the upper left corner. (size-1, size-1) is the lower right corner.
    
    begin

        process(clk)
        begin
            if(rising_edge(clk)) then
                if(reset = '1') then
                    for i in 0 to size-1 loop                   --everthing to zero
                        for j in 0 to size-1 loop
                            grid(i,j) <= x"00";
                        end loop ;     
                    end loop ;
                elsif initialize = '1' then                     --maybe not important (can this whole else if away?)
                    for i in 1 to size-1 loop
                        for j in size-1 downto size-1-i loop
                            grid(i,j) <= x"00";
                        end loop ;     
                    end loop ;
                elsif write_en = '1' then
                    grid(pos_x,pos_y) <= data_in;
                else
                    for i in size-1 downto 0 loop               --shift
                        vector(i)<= grid(i,size-1);
                    end loop ;
                    for i in size-1 downto 0 loop
                        for j in size-1 downto 1 loop
                            grid(i,j) <= grid(i,j-1);
                        end loop ;     
                    end loop ;
                end if;
                    


            end if;
        end process;



end rtl;
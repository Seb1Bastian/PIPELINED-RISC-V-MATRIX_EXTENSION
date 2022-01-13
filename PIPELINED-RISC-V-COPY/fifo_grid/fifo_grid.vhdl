library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_grid is
    generic(max_size : integer range 2 to 255 := 3); -- the max
    port(
        --inputs
        clk         : in std_logic;
        initialize  : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        write_en    : in std_logic;
        size        : in integer;
        shift       : in std_logic;

        data_in        : in std_logic_vector(7 downto 0);

        --outputs
        data_out    : out BYTE_VECTOR(max_size-1 downto 0)  -- is 1 when it is finished counting else 0
    );
end fifo_grid;


architecture rtl of fifo_grid is

    signal vector : BYTE_VECTOR(max_size-1 downto 0);
    Signal grid : BYTE_GRID( max_size-1 downto 0, max_size-1 downto 0); -- (0,0) is the upper left corner. (size-1, size-1) is the lower right corner.
    signal differenz : integer;
    
    begin
        differenz <= max_size - size;

        process(clk)
        variable pos_x1, pos_x2 : integer range 0 to 255 := 0;
        begin
            if(rising_edge(clk)) then
                if(reset = '1') then
                    for i in 0 to max_size-1 loop                   --everthing to zero
                        for j in 0 to max_size-1 loop
                            grid(i,j) <= x"00";
                        end loop ;     
                    end loop ;
                    pos_x1 := 0;
                    pos_x2 := differenz;
                elsif initialize = '1' then
                        pos_x1 := 0;
                        pos_x2 := differenz; 
                elsif write_en = '1' then                       --writes the input to the next free position
                    grid(pos_x1,pos_x2) <= data_in;
                    if pos_x2 = max_size-1 then
                        pos_x2 := differenz;
                        if pos_x1 = size-1 then
                            pos_x1 := 0;
                        else
                            pos_x1 := pos_x1 + 1;
                        end if;
                    else
                        pos_x2 := pos_x2 + 1;
                    end if;                    
                else
                    for i in max_size-1 downto 0 loop               --shift
                        vector(i)<= grid(i,size-1);
                    end loop ;
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
end rtl;
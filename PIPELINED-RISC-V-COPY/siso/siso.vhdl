library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity siso is
    generic(size : integer range 1 to 255 := 3); -- the max
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        write_en    : in std_logic;

        data_in        : in std_logic_vector(7 downto 0);

        --outputs
        data_out    : out std_logic_vector(7 downto 0) 
    );
end siso;


architecture rtl of siso is

    signal vector : type BYTE_VECTOR (size-1 downto 0);
    Signal grid : BYTE_GRID( max_size-1 downto 0, max_size-1 downto 0); -- (0,0) is the upper left corner. (size-1, size-1) is the lower right corner.
    signal differenz : integer;
    
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    for i in 0 to size-1 loop
                        vector(i) <= x"00";
                    end loop;
                elsif write_en = '1' then
                    for i in size-1 downto 1 loop
                        vector(i-1) <= vector(i);
                    end loop;
                    vector(size-1) <= data_in;
                end if;
            end if;

            data_out <= vector(0);
    end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_triangle is
    generic(size : integer range 1 to 255 := 3); -- the max
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        write_en    : in std_logic;
        data_in     : in BYTE_VECTOR(size-1 downto 0);

        --outputs
        data_out    : out BYTE_VECTOR(size-1 downto 0)  
    );
end fifo_triangle;


architecture rtl of fifo_triangle is

    signal vector : BYTE_VECTOR(max_size-1 downto 0);
    Signal grid : BYTE_GRID( max_size-1 downto 0, max_size-1 downto 0);
    signal differenz : integer;
    
    begin

        GEN_REG: for i in 1 to size-1 generate
            siso : entity work.counter(rtl)
                generic map(i)
                (clk => clk, reset => reset, write_en => write_en, data_in => data_in(i) , data_out => data_out(i) );
        end generate GEN_REG;

        data_out(0) <= data_in(0);
end rtl;
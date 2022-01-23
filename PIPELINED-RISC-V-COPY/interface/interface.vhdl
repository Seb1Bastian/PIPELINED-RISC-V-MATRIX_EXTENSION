library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interface is
    generic(size    : integer range 1 to 255 := 15); 
    port(
        --inputs
        clk_1        : in std_logic;
        clk_2        : in std_logic;
        reset        : in std_logic;
        data_in1     : in std_logic_vector(31 downto 0);
        data_in2     : in std_logic_vector(31 downto 0);
        write_data_1 : in std_logic;
        write_data_2 : in std_logic;
        read_data_1  : in std_logic;
        read_data_2  : in std_logic;

        --outputs
        data_out1     : out std_logic_vector(31 downto 0);
        data_out2     : out std_logic_vector(31 downto 0);
        can_write1    : out std_logic;
        can_write2    : out std_logic;
        can_read1     : out std_logic;
        can_read2     : out std_logic

    );
end interface;
    
    
architecture rtl of interface is


begin


   fifo_mem_1to2 : entity work.fifo_mem_v2(rtl)
   generic map(size => size)
   port map(
       clk_1       => clk_1,
       clk_2       => clk_2,
       reset       => reset,
       data_in     => data_in1,
       write_data  => write_data_1,
       read_data   => read_data_2,
       --outputs
       data_out    => data_out2,
       can_write   => can_write1,
       can_read    => can_read2
   );

   fifo_mem_2to1 : entity work.fifo_mem_v2(rtl)
   generic map (size => size)
   port map (
       clk_1       => clk_2,
       clk_2       => clk_1,
       reset       => reset,
       data_in     => data_in2,
       write_data  => write_data_2,
       read_data   => read_data_1,
       --outputs
       data_out    => data_out1,
       can_write   => can_write2,
       can_read    => can_read1
   );

end rtl;
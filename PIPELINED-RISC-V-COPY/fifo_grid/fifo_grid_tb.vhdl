library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_grid_tb is
end fifo_grid_tb;


architecture rtl of fifo_grid_tb is

    Signal clk      : std_logic;
    Signal reset      : std_logic;
    Signal write_en1      : std_logic;
    Signal shift_grid1      : std_logic;
    Signal pos_x11      : integer;
    Signal pos_x12      : integer;
    Signal pos_x21      : integer;
    Signal pos_x22      : integer;
    Signal write_en2      : std_logic;
    Signal shift_grid2      : std_logic;
    Signal data_in      : std_logic_vector(31 downto 0);

    begin


    fifo_grid_matrix1 : entity work.fifo_grid_v2(rtl)
    generic map (16)
    port map(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en1,
        shift       => shift_grid1,
        pos_x1      => pos_x11,
        pos_x2      => pos_x12,
        data_in     => data_in(7 downto 0),
        --outputs
        data_out    => open
    );

    fifo_grid_matrix2 : entity work.fifo_grid_v2_vertical(rtl)
    generic map(16)
    port map(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en2,
        shift       => shift_grid2,
        pos_x1      => pos_x21,
        pos_x2      => pos_x22,
        data_in     => data_in(7 downto 0),
        --outputs
        data_out    => open
    );

    process begin
        wait for 30 ns;
        wait;
    end process;

end rtl;

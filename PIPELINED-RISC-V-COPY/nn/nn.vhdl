library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn is
    generic(max_entries : integer range 2 to 255 := 3; -- the max number of entries in the matrix.
            max_size    : integer range 1 to 15 := 15); 
    port(
        --inputs
        clk           : in std_logic;
        reset         : in std_logic;
        data_in       : in std_logic_vector(31 downto 0);
        can_write     : in std_logic;
        can_read      : in std_logic;

        --outputs
        data_out      : out std_logic_vector(31 downto 0)
    );
end nn;
    
    
architecture rtl of nn is

    signal controls     : std_logic_vector( 0 downto 0);
    signal start_load   : std_logic;
    signal reset_load   : std_logic;
    signal next_input   : std_logic;
    signal entries      : integer;
    signal finished_load : std_logic;
    signal init_grid    : std_logic;
    signal write_en1    : std_logic;
    signal write_en2    : std_logic;
    signal size         : integer;
    signal shift_grid1  : std_logic;
    signal data         : std_logic_vector(31 downto 0);
    signal data_out_grid1 : BYTE_VECTOR(max_size-1 downto 0);
    signal shift_grid2  : std_logic;
    signal data_out_grid2 : BYTE_VECTOR(max_size-1 downto 0);
    signal write_en_tri1 : std_logic;
    signal write_en_tri2 : std_logic;
    signal data_out_triangle1 : BYTE_VECTOR(max_size-1 downto 0);
    signal data_out_triangle2 : BYTE_VECTOR(max_size-1 downto 0);


begin

    fifo_mem_loader : entity work.fifo_mem_loader(rtl)
    generic map (max_entries => 225) -- the max number of entries in the matrix.
    port map(
        clk         => clk,
        start       => start_load,
        reset       => reset_load,
        can_read    => can_read,
        entries     => entries,
        --outputs
        finished_load => finished_load,
        init_grid   => init_grid,
        write_en1   => write_en1,
        write_en2   => write_en2
    );

    fifo_grid_matrix1 : entity work.fifo_grid(rtl)
    generic map (max_size => 15)
    port map(
        --inputs
        clk         => clk,
        initialize  => init_grid,
        reset       => reset,
        write_en    => write_en1,
        size        => size,
        shift       => shift_grid1,
        data_in     => data(7 downto 0),
        --outputs
        data_out    => data_out_grid1
    );

    fifo_grid_matrix2 : entity work.fifo_grid_vertical(rtl)
    generic map(max_size => 15)
    port map(
        --inputs
        clk         => clk,
        initialize  => init_grid,
        reset       => reset,
        write_en    => write_en2,
        size        => size,
        shift       => shift_grid2,
        data_in     => data(7 downto 0),
        --outputs
        data_out    => data_out_grid2
    );

    fifo_triangle1 : entity work.fifo_triangle(rtl)
    generic map(size => 15) -- the max
    port map(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en_tri1,
        data_in     => data_out_grid1,
        --outputs
        data_out    => data_out_triangle1 
    );

    fifo_triangle2 : entity work.fifo_triangle(rtl)
    generic map(size => 15) -- the max
    port map(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en_tri2,
        data_in     => data_out_grid2,
        --outputs
        data_out    => data_out_triangle2 
    );


end rtl;
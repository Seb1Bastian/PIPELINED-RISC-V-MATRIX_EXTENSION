library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn is
    generic(max_entries : integer range 2 to 255 := 3); -- the max number of entries in the matrix.
    port(
        --inputs
        clk           : in std_logic;
        clk_cpu       : in std_logic;
        reset         : in std_logic;
        data_in       : in std_logic_vector(31 downto 0);

        --outputs
        data_out      : out std_logic_vector(31 downto 0);
        can_write_in  : out std_logic;
        can_read_out  : out std_logic
    );
end nn;
    
    
architecture rtl of nn is

    signal controls : std_logic_vector( 0 downto 0);
    signal start_load : std_logic;
    signal reset_load : std_logic;
    signal next_input : std_logic;
    signal entries    : std_logic;
        --outputs
    signal finished_load : std_logic;
    signal write_en1   : std_logic;
    signal write_en2   : std_logic;
begin

    fifo_mem_loader : entity work.fifo_mem_loader(rtl)
    generic map (max_entries => 225); -- the max number of entries in the matrix.
    port map(
        clk         => clk,
        start       => start_load,
        reset       => reset_load,
        next_input  => next_input,
        entries     => entries,
        --outputs
        finished_load => finished_load,
        init_grid   => init_grid,
        write_en1   => write_en1,
        write_en2   => write_en2
    );

    fifo_grid_matrix1 : entity work.fifo_grid(rtl)
    generic(max_size => 15);
    port(
        --inputs
        clk         => clk,
        initialize  => init_grid,
        reset       => reset,
        write_en    => write_en1
        size        => size
        shift       => shift_grid1
        data_in     => data
        --outputs
        data_out    => data_out_grid1
    );

    fifo_grid_matrix2 : entity work.fifo_grid_vertical(rtl)
    generic(max_size => 15);
    port(
        --inputs
        clk         => clk,
        initialize  => init_grid,
        reset       => reset,
        write_en    => write_en2
        size        => size
        shift       => shift_grid2
        data_in     => data
        --outputs
        data_out    => data_out_grid2
    );

    fifo_triangle1 : entity work.fifo_triangle(rtl)
    generic(size => 15); -- the max
    port(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en,
        data_in     => data_out_grid1,
        --outputs
        data_out    => data_out_triangle1 
    );

    fifo_triangle2 : entity work.fifo_triangle(rtl)
    generic(size => 15); -- the max
    port(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en,
        data_in     => data_out_grid2,
        --outputs
        data_out    => data_out_triangle2 
    );

    fifo_mem_in : entity work.fifo_mem(rtl)
    generic(size => 20);
    port(
        clk_1       => clk_cpu,
        clk_2       => clk,
        reset       => reset,
        data_in     => data_in_in,
        write_data  => write_data_in,
        read_data   => read_data_in,
        --outputs
        data_out    => data_out_in,
        can_write   => can_write_in,
        can_read    => can_read_in
    );

    fifo_mem_out : entity work.fifo_mem(rtl)
    generic(size => 20);
    port(
        clk_1       => clk,
        clk_2       => clk_cpu,
        reset       => reset,
        data_in     => data_in_out,
        write_data  => write_data_out,
        read_data   => read_data_out,
        --outputs
        data_out    => data_out_out,
        can_write   => can_write_out,
        can_read    => can_read_out
    );


end rtl;
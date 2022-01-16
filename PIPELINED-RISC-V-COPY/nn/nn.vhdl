library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn is
    generic(max_entries : integer range 2 to 255 := 3; -- the max number of entries in the matrix.
            max_size    : integer range 1 to 15 := 15); 
    port(
        --inputs
        clk             : in std_logic;
        reset           : in std_logic;
        data_in         : in std_logic_vector(31 downto 0);
        can_write       : in std_logic;
        can_read        : in std_logic;

        --outputs
        readFromCPU     : out std_logic;
        writeToCPU      : out std_logic;
        data_out        : out std_logic_vector(31 downto 0)
    );
end nn;
    
    
architecture rtl of nn is

    signal controls         : std_logic_vector( 0 downto 0);
    signal start_load       : std_logic;
    signal start_mult       : std_logic;
    signal start_unload     : std_logic;
    signal reset_load       : std_logic;
    signal next_input       : std_logic;
    signal read_data_mc     : std_logic;
    signal read_data_lo     : std_logic;
    signal entries          : integer;
    signal finished_load    : std_logic;
    signal finished_mult    : std_logic;
    signal finished_unload  : std_logic;
    signal init_grid        : std_logic;
    signal write_en1        : std_logic;
    signal write_en2        : std_logic;
    signal size             : integer;
    signal shift_grid1      : std_logic;
    signal data_out_grid1   : BYTE_VECTOR(max_size-1 downto 0);
    signal shift_grid2      : std_logic;
    signal data_out_grid2   : BYTE_VECTOR(max_size-1 downto 0);
    signal write_en_tri1    : std_logic;
    signal write_en_tri2    : std_logic;
    signal data_out_triangle1 : BYTE_VECTOR(max_size-1 downto 0);
    signal data_out_triangle2 : BYTE_VECTOR(max_size-1 downto 0);
    signal  matrix            : BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);


begin

    readFromCPU <= read_data_mc or read_data_lo;

    main_controller : entity work.nn_controller(rtl)
    generic map(max_entries => max_entries) -- the max number of entries in the matrix.
    port map(
        --inputs
        clk             => clk,
        canRead         => can_read,
        nn_opcode       => data_in(31 downto 8),
        load_finished   => finished_load,
        mult_finished   => finished_mult,
        unload_finished => finished_unload,

        --outputs
        read_data       => read_data_mc,
        start_load      => start_load,
        start_mult      => start_mult,
        start_unload    => start_unload,
        entries         => entries,
        size            => size
    );

    fifo_mem_loader : entity work.fifo_mem_loader(rtl)
    generic map (max_entries => max_entries) -- the max number of entries in the matrix.
    port map(
        clk         => clk,
        start       => start_load,
        reset       => reset_load,
        can_read    => can_read,
        entries     => entries,
        --outputs
        finished_load => finished_load,
        read_data   => read_data_lo,
        init_grid   => init_grid,
        write_en1   => write_en1,
        write_en2   => write_en2
    );

    unloader : entity work.nn_unloader(rtl)
    generic map (max_size => max_size) -- the max number of rows and colums in the matrix.
    port map(
        --inputs
        clk             => clk,
        size            => size,
        entries         => entries,
        canWrite        => can_write,
        start_unload    => start_unload,
        matrix          => matrix,
        reset           => reset,
        --outputs
        unload_finished => finished_unload,
        write_to_CPU    => writeToCPU,
        data_out        => data_out
    );

    fifo_grid_matrix1 : entity work.fifo_grid(rtl)
    generic map (max_size => max_size)
    port map(
        --inputs
        clk         => clk,
        initialize  => init_grid,
        reset       => reset,
        write_en    => write_en1,
        size        => size,
        shift       => shift_grid1,
        data_in     => data_in(7 downto 0),
        --outputs
        data_out    => data_out_grid1
    );

    fifo_grid_matrix2 : entity work.fifo_grid_vertical(rtl)
    generic map(max_size => max_size)
    port map(
        --inputs
        clk         => clk,
        initialize  => init_grid,
        reset       => reset,
        write_en    => write_en2,
        size        => size,
        shift       => shift_grid2,
        data_in     => data_in(7 downto 0),
        --outputs
        data_out    => data_out_grid2
    );

    fifo_triangle1 : entity work.fifo_triangle(rtl)
    generic map(size => max_size) -- the max
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
    generic map(size => max_size) -- the max
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
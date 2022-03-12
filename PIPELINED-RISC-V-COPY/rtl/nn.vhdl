library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn is
    generic(max_size    : integer); 
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
    --signal reset_load       : std_logic := '0';
    signal next_input       : std_logic;
    signal read_data_mc     : std_logic;
    signal read_data_lo     : std_logic;
    signal finished_load    : std_logic;
    signal finished_mult    : std_logic;
    signal finished_unload  : std_logic;
    signal init_grid        : std_logic;
    signal write_en1        : std_logic;
    signal write_en2        : std_logic;
    signal shift_grid1      : std_logic := '0';
    signal rows1            : integer range 0 to max_size;
    signal columns1         : integer range 0 to max_size;
    signal rows2            : integer range 0 to max_size;
    signal columns2         : integer range 0 to max_size;
    signal pos_x11          : integer range 0 to max_size-1;
    signal pos_x12          : integer range 0 to max_size-1;
    signal pos_x21          : integer range 0 to max_size-1;
    signal pos_x22          : integer range 0 to max_size-1;
    signal data_out_grid1   : BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);
    signal shift_grid2      : std_logic := '0';
    signal data_out_grid2   : BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);
    signal write_en_tri1    : std_logic;
    signal write_en_tri2    : std_logic;
    signal  matrix          : BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);


begin

    readFromCPU <= read_data_mc or read_data_lo;

    main_controller : entity work.nn_controller(rtl)    --the main controller knows is
    generic map( max_size => max_size)
    port map(
        --inputs
        clk             => clk,
        reset           => reset,
        canRead         => can_read,
        nn_opcode       => data_in(31 downto 0),
        load_finished   => finished_load,
        mult_finished   => finished_mult,
        unload_finished => finished_unload,

        --outputs
        read_data       => read_data_mc,
        start_load      => start_load,
        start_mult      => start_mult,
        start_unload    => start_unload,
        rows1           => rows1,
        columns1        => columns1,
        rows2           => rows2,
        columns2        => columns2
    );

    fifo_mem_loader : entity work.fifo_mem_loader(rtl)      --computes the position where the value form the interface should be stored
    generic map (max_size => max_size)
    port map(
        clk         => clk,
        start       => start_load,
        reset       => '0',
        can_read    => can_read,
        rows1       => rows1,
        columns1    => columns1,
        rows2       => rows2,
        columns2    => columns2,
        --outputs
        finished_load => finished_load,
        read_data   => read_data_lo,
        init_grid   => init_grid,
        write_en1   => write_en1,
        write_en2   => write_en2,
        pos_x11     => pos_x11,
        pos_x12     => pos_x12,
        pos_x21     => pos_x21,
        pos_x22     => pos_x22
    );

    unloader : entity work.nn_unloader(rtl)     --read the result matrix and puts the result in the interface to the cpu
    generic map (max_size => max_size) -- the max number of rows and colums in the matrix.
    port map(
        --inputs
        clk             => clk,
        canWrite        => can_write,
        start_unload    => start_unload,
        matrix          => matrix,
        reset           => reset,
        rows            => rows1,
        columns         => columns2,
        --outputs
        unload_finished => finished_unload,
        write_to_CPU    => writeToCPU,
        data_out        => data_out
    );

    fifo_grid_matrix1 : entity work.fifo_grid(rtl)              -- zwischenspeicher for the frist matrix
    generic map (max_size => max_size)
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
        data_out    => data_out_grid1
    );

    fifo_grid_matrix2 : entity work.fifo_grid_vertical(rtl)     -- zwischenspeicher for the second matrix
    generic map(max_size => max_size)
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
        data_out    => data_out_grid2
    );

    sa : entity work.sa(rtl)                                    -- multiplies the two matrix with eachother
    generic map(max_size)
    port map(
        clk => clk,
        reset => reset,
        start => start_mult,
        a => data_out_grid1,
        b => data_out_grid2,
        d => matrix,
        finished => finished_mult
    );


end rtl;
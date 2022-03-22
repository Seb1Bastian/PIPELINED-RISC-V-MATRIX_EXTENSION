library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem is
    generic(length : integer := 2);
    port(
        clk_1       : in std_logic;
        clk_2       : in std_logic;
        reset       : in std_logic;                     -- synchron Reset
        data_in     : in std_logic_vector(31 downto 0);
        write_data  : in std_logic;
        read_data   : in std_logic;

        --outputs
        data_out    : out std_logic_vector(31 downto 0);
        can_write   : out std_logic;
        can_read    : out std_logic
    );
end fifo_mem;


architecture rtl of fifo_mem is

    signal write_vector, write_vector_com, read_vector : FOUR_BYTE_VECTOR(2**length-1 downto 0);
    signal write_en                     : std_logic;
    signal can_write_i                   : std_logic := '1';
    signal can_read_i                    : std_logic := '0';
    signal read_en                       : std_logic := '0';

    signal adr_read                     : integer range 0 to 2**length-1;
    signal adr_write                    : integer range 0 to 2**length-1;

    signal pointer_write                : std_logic_vector(length-1 downto 0);
    signal pointer_read                 : std_logic_vector(length-1 downto 0);
    signal grey_write                   : std_logic_vector(length-1 downto 0); 
    signal grey_read                    : std_logic_vector(length-1 downto 0);
    signal grey_write_stable            : std_logic_vector(length-1 downto 0); 
    signal grey_read_stable             : std_logic_vector(length-1 downto 0);
    signal write_stable                 : std_logic_vector(length-1 downto 0); 
    signal read_stable                  : std_logic_vector(length-1 downto 0); 

    
    begin

        inst_mux : entity work.fifo_mux(rtl)        --chooses which 32 Bit value is on the output 
        generic map(2**length)
        port map(
            port_in   => read_vector,
            sel => adr_read,
            port_out => data_out);

        inst_pipo : entity work.pipo(rtl)           --the actual memory
        generic map(2**length)
        port map(
            clk => clk_1, 
            reset => reset, 
            write_en => write_en, 
            data_in => write_vector_com, 
            data_out => read_vector);

        inst_comb : entity work.vec_combiner(rtl)   --combines the input with the saved inputs                                           
        generic map(2**length)
        port map(
            a =>data_in, 
            b=> read_vector, 
            sel=> adr_write, 
            c=> write_vector_com);


        write_Pointer : entity work.greyCodeCounter(rtl)
        generic map(length)
        port map(
            --inputs
            clk         => clk_1,
            reset       => reset,
            increment   => write_en,

            --outputs
            bitCode_out     => pointer_write,
            greyCode_out    => grey_write
        );
        
        read_Pointer : entity work.greyCodeCounter(rtl)
        generic map(length)
        port map(
            --inputs
            clk         => clk_2,
            reset       => reset,
            increment   => read_en,

            --outputs
            bitCode_out     => pointer_read,
            greyCode_out    => grey_read
        );

        stabilze_write : entity work.siso(rtl)
        generic map(size => 2, length => length)
        port map(
            --inputs
            clk         => clk_2,
            reset       => reset,
            write_en    => '1',
            data_in     => grey_write,
            --outputs
            data_out    => grey_write_stable
        );

        stabilze_read : entity work.siso(rtl)
        generic map(size => 2, length => length)
        port map(
            --inputs
            clk         => clk_1,
            reset       => reset,
            write_en    => '1',
            data_in     => grey_read,
            --outputs
            data_out    => grey_read_stable
        );

        greyWriteToBitWrite : entity work.greyCode_to_BitCode(rtl)
        generic map(length)
        port map(
          value_in    => grey_write_stable,
          value_out   => write_stable
        );

        greyReadToBitRead : entity work.greyCode_to_BitCode(rtl)
        generic map(length)
        port map(
          value_in    => grey_read_stable,
          value_out   => read_stable
        );
                                                                                                 --condition when it is allowed to write in the memory
        can_write_i <= '1' when (unsigned(pointer_write) < (2**length-1) and pointer_write > read_stable)
                             or (unsigned(pointer_write) = (2**length-1) and unsigned(read_stable) > 0)
                             or (pointer_write = read_stable)
                             or (unsigned(pointer_write) < unsigned(read_stable)-1)
                             else '0';
                                                                                                 --condition when it is allowed to read from the memory
        can_read_i <= '1' when (pointer_read /= write_stable)
                           else '0';

        write_en <= '1' when write_data = '1' and can_write_i = '1' else '0';
        read_en  <= '1' when  read_data = '1' and can_read_i  = '1' else '0';

        can_write   <= can_write_i;
        can_read   <= can_read_i;

        adr_write <= to_integer(unsigned(pointer_write));
        adr_read  <= to_integer(unsigned(pointer_read));


end rtl;
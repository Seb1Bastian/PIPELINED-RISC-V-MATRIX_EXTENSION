library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem is
    generic(size : integer range 1 to 255 := 3); -- the specificed number of rising edges of the ended signal turns to one
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

    signal write_vector, write_vector_com, read_vector : FOUR_BYTE_VECTOR(size-1 downto 0);
    signal written                      : std_logic_vector(size-1 downto 0) := (others => '0');
    signal not_can_write                : std_logic;
    signal write_en                     : std_logic;
    signal adr_write, adr_write_old     : integer range 0 to size :=0;
    signal adr_read                     : integer range 0 to size :=0;
    signal can_write_as                 : std_logic;
    signal can_read_as                  : std_logic;
    signal can_write_sync               : std_logic;
    signal can_read_sync                : std_logic;
    signal can_write_i                  : std_logic;
    signal can_read_i                   : std_logic;
    
    begin

        inst_mux : entity work.fifo_mux(rtl)        --chooses which 32 Bit value is on the output 
        generic map(size)
        port map(
            port_in   => read_vector,
            sel => adr_read,
            port_out => data_out);

        inst_pipo : entity work.pipo(rtl)           --the actual memory
        generic map(size)
        port map(
            clk => clk_1, 
            reset => reset, 
            write_en => write_en, 
            data_in => write_vector_com, 
            data_out => read_vector);

        inst_comb : entity work.vec_combiner(rtl)   --combines the input with the saved inputs                                           
        generic map(size)
        port map(
            a =>data_in, 
            b=> read_vector, 
            sel=> adr_write, 
            c=> write_vector_com);
        

                                                                                                 --condition when it is allowed to write in the memory
        can_write_as <= '1' when (adr_write < (size-1) and adr_write > adr_read)
                            or (adr_write = (size-1) and adr_read > 0)
                            or (adr_write = adr_read)
                            or (adr_write < adr_read-1)
                            else '0';
                                                                                                 --condition when it is allowed to read from the memory
        can_read_as <= '1' when (adr_read /= adr_write_old)
                           else '0';

        write_en <= '1' when write_data = '1' and can_write_i = '1' else '0';

        --upadates pointer for writing
        process(clk_1)  
        begin
            if(rising_edge(clk_1)) then
                if reset = '1' then
                    adr_write <= 0;
                    adr_write_old <= 0;
                elsif(write_data = '1' and can_write_i = '1') then
                    adr_write_old <= adr_write;
                    if adr_write = size-1 then
                        adr_write <= 0;
                    else
                        adr_write <= adr_write + 1;               
                    end if ;
                else
                    adr_write_old <= adr_write;
                end if;
            end if;
        end process;

        process(clk_1)  
        begin
            if(rising_edge(clk_1)) then
                can_write_sync <= can_write_as;
            end if;
        end process;
        can_write_i <= can_write_as and can_write_sync;
        can_write   <= can_write_i;

        --upadates pointer for reading
        process (clk_2) begin
            if(rising_edge(clk_2)) then
                if reset = '1' then
                    adr_read <= 0;
                elsif(read_data = '1' and can_read_i = '1') then
                    if adr_read = size-1 then
                        adr_read <= 0;
                    else
                        adr_read <= adr_read + 1;               
                    end if ;
                end if;
            end if;
        end process;

        process(clk_2)  
        begin
            if(rising_edge(clk_2)) then
                can_read_sync <= can_read_as;
            end if;
        end process;
        can_read_i <= can_read_sync and can_read_as;
        can_read   <= can_read_i;


end rtl;
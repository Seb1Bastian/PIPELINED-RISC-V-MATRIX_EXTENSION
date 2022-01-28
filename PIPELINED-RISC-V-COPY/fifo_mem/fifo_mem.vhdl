library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem is
    generic(size : integer range 1 to 255 := 3); -- the specificed number of rising edges of the ended signal turns to one
    port(
        clk_1       : in std_logic;
        clk_2       : in std_logic;
        reset       : in std_logic;                     -- synchron Reset (not implemented)
        data_in     : in std_logic_vector(31 downto 0);
        write_data  : in std_logic;
        read_data   : in std_logic;

        --outputs
        data_out    : out std_logic_vector(31 downto 0);  -- is 1 when it is finished counting else 0
        can_write   : out std_logic;
        can_read    : out std_logic
    );
end fifo_mem;


architecture rtl of fifo_mem is

    signal write_vector, write_vector_com, read_vector : FOUR_BYTE_VECTOR(size-1 downto 0);
    signal written   : std_logic_vector(size-1 downto 0) := (others => '0');
    signal not_can_write : std_logic;
    signal write_en      : std_logic;
    signal adr_write : integer range 0 to size :=0;
    signal adr_read  : integer range 0 to size :=0;
    signal can_write_inte, can_write_inte1, can_write_inte2, can_write_inte3, can_write_inte4 : std_logic;
    signal can_read_inte, can_read_inte1, can_read_inte2, can_read_inte3  : std_logic;
    
    begin

        inst_mux : entity work.fifo_mux(rtl)
        generic map(size)
        port map(port_in   => read_vector, sel => adr_read, port_out => data_out);

        inst_demux : entity work.fifo_demux(rtl)
        generic map(size)
        port map(port_in   => data_in, sel => adr_write , port_out => write_vector);

        inst_pipo : entity work.pipo(rtl)
        generic map(size)
        port map(clk => clk_1, reset => reset, write_en => write_en, data_in => write_vector_com, data_out => read_vector);

        inst_comb : entity work.vec_combiner(rtl)
        generic map(size)
        port map(a =>write_vector , b=> read_vector, sel=> adr_write, c=> write_vector_com );
        

        can_write <= can_write_inte;
        can_write_inte <= can_write_inte1 or can_write_inte2 or can_write_inte3 or can_write_inte4;
        can_write_inte1 <= '1' when adr_write < (size-1) and adr_write > adr_read else '0';
        can_write_inte2 <= '1' when adr_write = (size-1) and adr_read > 0 else '0';
        can_write_inte3 <= '1' when adr_write = adr_read else '0';
        can_write_inte4 <= '1' when adr_write < adr_read-1 else '0';

        can_read <= can_read_inte;
        can_read_inte <= '1' when (adr_read < (size-1) and adr_write < adr_read)
                          or (adr_read = (size-1) and adr_write >= 0 and (adr_write /= size-1))
                          or (adr_write > adr_read)
                          else '0';

        write_en <= '1' when write_data = '1' and can_write_inte = '1' else '0';

        process(clk_1)  
        begin
            if(rising_edge(clk_1)) then
                if(write_data = '1' and can_write_inte = '1') then
                    if adr_write = size-1 then
                        adr_write <= 0;
                    else
                        adr_write <= adr_write + 1;               
                    end if ;
                end if;
            end if;
        end process;


        process (clk_2) begin
            if(rising_edge(clk_2)) then
                if(read_data = '1' and can_read_inte = '1') then
                    if adr_read = size-1 then
                        adr_read <= 0;
                    else
                        adr_read <= adr_read + 1;               
                    end if ;
                end if;
            end if;
        end process;




end rtl;
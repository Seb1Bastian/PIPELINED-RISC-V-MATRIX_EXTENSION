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
        data_in     : in std_logic_vector(7 downto 0);
        write_data  : in std_logic;
        read_data   : in std_logic;

        --outputs
        data_out    : out std_logic_vector(7 downto 0);  -- is 1 when it is finished counting else 0
        can_write   : out std_logic;
        can_read    : out std_logic
    );
end fifo_mem;


architecture rtl of fifo_mem is

    signal vector : BYTE_VECTOR(size-1 downto 0);
    signal written   : std_logic_vector(size-1 downto 0);
    --signal adr_write : integer range 0 to size :=0;
    --signal adr_read  : integer range 0 to size :=0;
    
    begin

        can_writing : entity work.unary_nand(rtl) port map( inp => written, outp => can_write);
        can_reading : entity work.unary_or(rtl) port map( inp => written, outp => can_read);


        process(clk_1)  
        variable v_adr_write : integer range 0 to size := 0;
        begin
            if(rising_edge(clk_1)) then
                if(write_data = '1' and v_adr_write < size and written(v_adr_write) = '0') then        --Do you have enough time to read out the cell by looking ahead only one cell ahead (worst case) (maybe looking two cell ahead might be a good idea?)
                    vector(v_adr_write) <= data_in;
                    --adr_write <= adr_write + 1;
                    written(v_adr_write) <= '1';
                    v_adr_write := v_adr_write + 1;
                elsif write_data = '1' and v_adr_write = (size) and written(0) = '0' then
                    vector(0) <= data_in;
                    --adr_write <= 0;
                    written(0) <= '1';
                    v_adr_write := 0;
                end if;
            end if;
        end process;


        process(clk_2)
        variable v_adr_read : integer range 0 to size := 0;
        begin
            if(rising_edge(clk_2)) then
                if(read_data = '1' and v_adr_read < size and written(v_adr_read) = '1') then
                    data_out <= vector(v_adr_read);
                    v_adr_read := v_adr_read + 1;
                    written(v_adr_read) <= '0'
                    --adr_read <= adr_read + 1;
                elsif read_data = '1' and v_adr_read = (size) and  written(0) = '1' then
                    data_out <= vector(0);
                    v_adr_read := 0;
                    written(0) <= '1';
                    --adr_read <= 0;
                end if;
            end if;
        end process;



end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity pipo is
    generic(size : integer range 1 to 255 := 3; start_value : std_logic_vector(31 downto 0) := x"00000000"); -- the max
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        write_en    : in std_logic;
        data_in        : in FOUR_BYTE_VECTOR(size-1 downto 0);

        --outputs
        data_out    : out FOUR_BYTE_VECTOR(size-1 downto 0) 
    );
end pipo;


architecture rtl of pipo is

    signal vector : FOUR_BYTE_VECTOR (size-1 downto 0) := (others => start_value);
    signal test : std_logic_vector(31 downto 0);
    
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    for i in 0 to size-1 loop
                        vector(i) <= start_value;
                    end loop;
                elsif write_en = '1' then
                    vector <= data_in; 
                end if;
            end if;
        end process;

            data_out <= vector;
            test <= vector(0);
    end rtl;
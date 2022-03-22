library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity siso is
    generic(size : integer := 3;
            length : integer := 3); -- the max
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;  -- synchron Reset
        write_en    : in std_logic;

        data_in     : in std_logic_vector(length-1 downto 0);

        --outputs
        data_out    : out std_logic_vector(length-1 downto 0) 
    );
end siso;


architecture rtl of siso is

    type ram_type_One is array(size-1 downto 0) of std_logic_vector(length-1 downto 0);
    signal vector : ram_type_One := (others => (others => '0'));
    
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                        vector <= (others => (others => '0'));
                elsif write_en = '1' then
                    for i in size-1 downto 1 loop
                        vector(i-1) <= vector(i);
                    end loop;
                    vector(size-1) <= data_in;
                end if;
            end if;
        end process;

            data_out <= vector(0);
    end rtl;
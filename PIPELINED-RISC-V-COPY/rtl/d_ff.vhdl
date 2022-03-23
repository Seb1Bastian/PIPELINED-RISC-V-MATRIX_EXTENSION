library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d_ff is                          -- D-Flip-Flop with variable input-vector length
    generic(length : integer := 3); 
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;                             -- synchron Reset
        write_en    : in std_logic;
        value_in    : in std_logic_vector(length-1 downto 0);

        --outputs
        value_out   : out std_logic_vector(length-1 downto 0) 
    );
end d_ff;


architecture rtl of d_ff is

    signal vector : std_logic_vector (length-1 downto 0) := (others => '0');
    
    begin
        process(clk)
        begin
            if rising_edge(clk) then
                if reset = '1' then
                    for i in 0 to length-1 loop
                        vector(i) <= '0';
                    end loop;
                elsif write_en = '1' then
                    vector <= value_in; 
                end if;
            end if;
        end process;

        value_out <= vector;
    end rtl;
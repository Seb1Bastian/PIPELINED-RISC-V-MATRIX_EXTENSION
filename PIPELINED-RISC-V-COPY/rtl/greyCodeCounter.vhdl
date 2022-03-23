library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity greyCodeCounter is
    generic(length : integer := 3);
    port(
        --inputs
        clk         : in std_logic;
        reset       : in std_logic;                             -- synchron Reset
        increment   : in std_logic;

        --outputs
        bitCode_out     : out std_logic_vector(length-1 downto 0);
        greyCode_out    : out std_logic_vector(length-1 downto 0) 
    );
end greyCodeCounter;


architecture rtl of greyCodeCounter is

    signal bnext, gnext, b_i, g_i : std_logic_vector (length-1 downto 0) := (others => '0');
    
    begin
        
        bin_reg : entity work.d_ff(rtl)         --saves the counter
        generic map(length => length)
        port map(
            clk         => clk,
            reset       => reset,
            write_en    => '1',
            value_in    => bnext,
            --outputs
            value_out   => b_i
            );

        grey_reg : entity work.d_ff(rtl)        --saves the grey-code version of the counter
        generic map(length => length)
        port map(
            clk         => clk,
            reset       => reset,
            write_en    => '1',
            value_in    => gnext,
            --outputs
            value_out   => g_i
            );

        convert : entity work.bitCode_to_greyCode(rtl)      --converts the counter into the corresponding grey-code
        generic map(length => length)
        port map(
            value_in    => bnext,
            value_out   => gnext
            );

        process(increment,b_i)begin                         --increments the counter by one if the increment-input is one. 
            if increment = '1' then
                bnext <= std_logic_vector((unsigned(b_i) + 1) mod (2**length));
            else
                bnext <= b_i;
            end if;
        end process;

        bitCode_out  <= b_i;
        greyCode_out <= g_i;
    end rtl;
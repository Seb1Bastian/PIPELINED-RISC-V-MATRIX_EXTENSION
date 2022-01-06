library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end counter_tb;

architecture test of counter_tb is
    
    signal clk,start,reset,waiting,ongoing,finished : std_logic;
   

    begin

        counter_inst : entity work.counter(rtl)
            generic map (5)
            port map(
                clk         => clk,
                start       => start,
                reset       => reset,

                --outputs
                waiting     => waiting,
                ongoing     => ongoing,
                finished       => finished
                );


        process begin
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '1';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '1';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '1';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '1';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '1';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '1';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '0';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            clk <= '1';
            start <= '0';
            reset <= '0';
            wait for 10 ns;
            wait;
        end process;

    end test;
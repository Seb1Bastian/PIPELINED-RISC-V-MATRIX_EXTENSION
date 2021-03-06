library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_risc_v_nn_tb is
end pipe_risc_v_nn_tb;

architecture test of pipe_risc_v_nn_tb is
    signal clk_cpu      : std_logic;
    signal reset        : std_logic;
    signal clk_nn       : std_logic;

    begin
        --instantiation pipelined risc v
        inst_pipelined_risc_v : entity work.pipe_risc_v_nn(rtl)
        generic map(2,3)
            port map (
                clk_cpu             => clk_cpu,
                reset           => reset,
                clk_nn => clk_nn
            );

            process begin
                -- reset
                clk_cpu   <= '0';
                reset <= '1';
                wait for 5 ns;
                clk_cpu   <= '1';
                reset <= '1';
                wait for 5 ns;
                clk_cpu   <= '0';
                reset <= '0';
                wait for 5 ns;
                clk_cpu   <= '0';
                reset <= '0';
                wait for 5 ns;
                for i in 1 to 90 loop
                    clk_cpu <= '1';
                    wait for 10 ns;
                    clk_cpu <= '0';
                    wait for 10 ns;
                    end loop;

                wait;
            end process;


            process begin
                -- reset
                clk_nn   <= '0';
                wait for 5 ns;
                clk_nn   <= '1';
                wait for 5 ns;
                clk_nn   <= '0';
                wait for 5 ns;
                clk_nn   <= '0';
                wait for 5 ns;
                for i in 1 to 100 loop
                    clk_nn <= '1';
                    wait for 8 ns;
                    clk_nn <= '0';
                    wait for 8 ns;
                    end loop;

                wait;
            end process;
end test;
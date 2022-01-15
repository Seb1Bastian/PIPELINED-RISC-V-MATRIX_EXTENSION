library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_risc_v_tb is
end pipe_risc_v_tb;

architecture test of pipe_risc_v_tb is
    signal clk          : std_logic;
    signal reset        : std_logic;
    signal dataFromAccelerator : std_logic_vector(31 downto 0);
    signal canWriteDataToAccelerator : std_logic :='0';
    signal canReadDataFromAccelerator : std_logic :='0';
    signal writeToAccelerator : std_logic;
    signal readFromAccelerator : std_logic;
    signal dataToAccelerator : std_logic_vector(31 downto 0);

    begin
        --instantiation pipelined risc v
        inst_pipelined_risc_v : entity work.pipe_risc_v(rtl)
            port map (
                clk             => clk,
                reset           => reset,
                dataFromAccelerator =>    dataFromAccelerator,
                canReadDataFromAccelerator  => canReadDataFromAccelerator,
                canWriteDataToAccelerator => canWriteDataToAccelerator,
                --outputs
                writeToAccelerator          => writeToAccelerator,
                readFromAccelerator         => readFromAccelerator,
                dataToAccelerator           => dataToAccelerator
            );

            process begin
                -- reset
                clk   <= '0';
                reset <= '1';
                wait for 5 ns;
                clk   <= '0';
                reset <= '0';
                wait for 5 ns;
                clk   <= '0';
                reset <= '0';
                wait for 5 ns;
                clk   <= '0';
                reset <= '0';
                wait for 5 ns;
                for i in 1 to 200 loop
                    clk <= '1';
                    wait for 10 ns;
                    clk <= '0';
                    wait for 10 ns;
                    end loop;

                wait;
            end process;


    end test;

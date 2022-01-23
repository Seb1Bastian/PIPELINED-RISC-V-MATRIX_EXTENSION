library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_risc_v_interface_tb is
end pipe_risc_v_interface_tb;

architecture rtl of pipe_risc_v_interface_tb is
    signal clk_cpu                      : std_logic;
    signal clk_else                     : std_logic;
    signal reset                        : std_logic;
    signal dataFromAccelerator          : std_logic_vector(31 downto 0);
    signal dataToAccelerator            : std_logic_vector(31 downto 0);
    signal canReadDataFromAccelerator   : std_logic;
    signal canWriteDataToAccelerator    : std_logic;
    signal readFromAccelerator          : std_logic;
    signal writeToAccelerator           : std_logic;

    signal data_in2      :  std_logic_vector(31 downto 0) := x"00000000";
    signal write_data_2  :  std_logic := '0';
    signal read_data_2   :  std_logic := '0';
    signal data_out2     :  std_logic_vector(31 downto 0);
    signal can_write2    :  std_logic;
    signal can_read2     :  std_logic;

begin
    inst_cpu : entity work.pipe_risc_v(rtl)
        port map( clk => clk_cpu, reset => reset, dataFromAccelerator => dataFromAccelerator, canReadDataFromAccelerator => canReadDataFromAccelerator,
                  canWriteDataToAccelerator => canWriteDataToAccelerator, writeToAccelerator => writeToAccelerator, readFromAccelerator => readFromAccelerator,
                  dataToAccelerator => dataToAccelerator);

    inst_interface : entity work.interface(rtl)
        generic map(3)
        port map(clk_1 => clk_cpu, clk_2=> clk_else, reset=> reset, data_in1=> dataToAccelerator, data_in2 => data_in2, write_data_1=> writeToAccelerator, write_data_2=> write_data_2,
                read_data_1 => readFromAccelerator, read_data_2=> read_data_2, data_out1=> dataFromAccelerator, data_out2=> data_out2,
                can_write1=> canWriteDataToAccelerator, can_write2=> can_write2, can_read1 => canReadDataFromAccelerator, can_read2 => can_read2 );

    process begin
        clk_cpu   <= '0';
        reset <= '1';
        wait for 5 ns;
        clk_cpu   <= '0';
        reset <= '0';
        wait for 5 ns;
        clk_cpu   <= '0';
        reset <= '0';
        wait for 5 ns;
        for i in 1 to 50 loop
            clk_cpu <= '0';
        wait for 10 ns;
            clk_cpu <= '1';
        wait for 10 ns;
        end loop;
        wait;
    end process;
    
    process begin
        for i in 1 to 50 loop
            clk_else <= '0';
        wait for 9 ns;
            clk_else <= '1';
        wait for 9 ns;
        end loop;
        wait;
    end process;

    process begin
        wait for 590 ns;
        read_data_2 <= '1';
        wait for 35 ns;
        write_data_2 <= '1';
        data_in2 <= x"10101010";
        wait for 30 ns;
        write_data_2 <= '0';
        wait for 30 ns;
        write_data_2 <= '1';
        data_in2 <= x"11111111";
        wait for 30 ns;
        data_in2 <= x"DDDDDDDD";
        wait for 30 ns;
        wait;
    end process;

    end rtl;
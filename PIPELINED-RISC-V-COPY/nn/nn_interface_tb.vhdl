library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_interface_tb is
end nn_interface_tb;
    



architecture rtl of nn_interface_tb is

    signal clk_cpu                      : std_logic;
    signal clk_nn                       : std_logic;
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

inst_interface : entity work.interface(rtl)
        generic map(8)
        port map(clk_1 => clk_cpu, clk_2=> clk_nn, reset=> reset, data_in1=> dataToAccelerator, data_in2 => data_in2, write_data_1=> writeToAccelerator, write_data_2=> write_data_2,
                read_data_1 => readFromAccelerator, read_data_2=> read_data_2, data_out1=> dataFromAccelerator, data_out2=> data_out2,
                can_write1=> canWriteDataToAccelerator, can_write2=> can_write2, can_read1 => canReadDataFromAccelerator, can_read2 => can_read2 );


    nn : entity work.nn(rtl)
        generic map(3)
        port map(clk => clk_nn, reset => reset, data_in => data_out2, can_write => can_write2, can_read => can_read2, 
                 readFromCPU => read_data_2, writeToCPU => write_data_2, data_out => data_in2);

                 
                 
    process begin
        clk_cpu   <= '0';
        clk_nn <= '0';
        reset <= '1';
        wait for 5 ns;
        clk_cpu   <= '1';
        clk_nn <= '1';
        reset <= '1';
        wait for 5 ns;
        clk_cpu   <= '0';
        clk_nn <= '0';
        reset <= '0';
        wait for 5 ns;
        for i in 1 to 50 loop
            clk_cpu <= '0';
            clk_nn <= '0';
        wait for 10 ns;
            clk_cpu <= '1';
            clk_nn <= '1';
        wait for 10 ns;
        end loop;
        wait;
    end process;
            
    process begin
        wait for 15 ns;
        dataToAccelerator <= "00011" & "00011" & "00011" & "00011" & "0001" & x"00";
        writeToAccelerator <= '1';
        readFromAccelerator <= '1';
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"01";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"02";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"03";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"04";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"05";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"06";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"07";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"08";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"09";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"0A";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"0B";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"0C";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"0D";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"0E";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"0F";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"10";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"11";
        wait for 20 ns;
        dataToAccelerator <= x"000000" & x"12";
        wait for 20 ns;
        writeToAccelerator <= '0';
        wait for 200 ns;
        wait;
    end process;














end rtl;
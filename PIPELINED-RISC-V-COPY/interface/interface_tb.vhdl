library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity interface_tb is
end interface_tb;
    
    
architecture rtl of interface_tb is


    signal clk_1        :  std_logic;
    signal clk_2        :  std_logic;
    --reset        : in std_logic;
    signal data_in1     :  std_logic_vector(31 downto 0);
    signal data_in2     :  std_logic_vector(31 downto 0);
    signal write_data_1 :  std_logic;
    signal write_data_2 :  std_logic;
    signal read_data_1  :  std_logic;
    signal read_data_2  :  std_logic;

    --outputs
    signal data_out1     :  std_logic_vector(31 downto 0);
    signal data_out2     :  std_logic_vector(31 downto 0);
    signal can_write1    :  std_logic;
    signal can_write2    :  std_logic;
    signal can_read1     :  std_logic;
    signal can_read2     :  std_logic;

begin
    inst_interface : entity work.interface(rtl)
    generic map(3)
    port map(clk_1 => clk_1, clk_2=> clk_2, data_in1=> data_in1, data_in2 => data_in2, write_data_1=> write_data_1, write_data_2=> write_data_2,
             read_data_1 => read_data_1, read_data_2=> read_data_2, data_out1=> data_out1, data_out2=> data_out2,
             can_write1=> can_write1, can_write2=> can_write2, can_read1 => can_read1, can_read2 => can_read2 );


    process begin
        for i in 1 to 26 loop
            clk_1 <= '0';
        wait for 10 ns;
            clk_1 <= '1';
        wait for 10 ns;
        end loop;
        wait;
    end process;
    
    process begin
        for i in 1 to 26 loop
            clk_2 <= '0';
        wait for 9 ns;
            clk_2 <= '1';
        wait for 9 ns;
        end loop;
        wait;
    end process;

    process begin
        data_in1 <= x"12345678";
        data_in2 <= x"10101010";
        read_data_1 <= '0';
        read_data_2 <= '0';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"01010101";
        data_in2 <= x"38459454";
        read_data_1 <= '0';
        read_data_2 <= '0';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"FFFFFFFF";
        data_in2 <= x"10000000";
        read_data_1 <= '0';
        read_data_2 <= '0';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"AAAAAAAA";
        data_in2 <= x"BBBBBBBB";
        read_data_1 <= '0';
        read_data_2 <= '0';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"56767676";
        data_in2 <= x"44444444";
        read_data_1 <= '0';
        read_data_2 <= '0';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"77777777";
        data_in2 <= x"33333333";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '0';
        write_data_2 <= '0';
        wait for 20 ns;
        data_in1 <= x"11111111";
        data_in2 <= x"22222222";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '0';
        write_data_2 <= '0';
        wait for 20 ns;
        data_in1 <= x"99999999";
        data_in2 <= x"88888888";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"66666666";
        data_in2 <= x"00000000";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '1';
        write_data_2 <= '1';
        wait for 20 ns;
        data_in1 <= x"CCCCCCCC";
        data_in2 <= x"DDDDDDDD";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '0';
        write_data_2 <= '0';
        wait for 20 ns;
        data_in1 <= x"56767676";
        data_in2 <= x"44444444";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '0';
        write_data_2 <= '0';
        wait for 20 ns;
        data_in1 <= x"56767676";
        data_in2 <= x"44444444";
        read_data_1 <= '1';
        read_data_2 <= '1';
        write_data_1 <= '0';
        write_data_2 <= '0';
        wait for 20 ns;
        wait;
    end process;

end rtl;
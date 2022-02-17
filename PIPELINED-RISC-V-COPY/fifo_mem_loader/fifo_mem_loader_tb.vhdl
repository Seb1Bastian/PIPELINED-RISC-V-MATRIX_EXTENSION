library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mem_loader_tb is
end fifo_mem_loader_tb;


architecture rtl of fifo_mem_loader_tb is

    signal clk             :  std_logic;
    signal start           :  std_logic := '1';
    signal reset           :  std_logic;  -- synchron Reset
    signal can_read        :  std_logic;
    signal rows1           :  integer := 0;
    signal columns1        :  integer := 0;
    signal rows2           :  integer := 0;
    signal columns2        :  integer := 0;

    --outputs
    signal finished_load   :  std_logic;
    signal read_data       :  std_logic;
    signal init_grid       :  std_logic;
    signal write_en1       :  std_logic;
    signal write_en2       :  std_logic;
    signal data_in         : std_logic_vector(31 downto 0);

    begin
        loader : entity work.fifo_mem_loader(rtl)
        generic map(16)
        port map(clk, start, reset, can_read, rows1, columns1, rows2, columns2, finished_load, read_data, init_grid, write_en1, write_en2);


        main_controller : entity work.nn_controller(rtl)
        port map(
                       clk             => clk,            canRead         => '1',            nn_opcode       => data_in(31 downto 8),            load_finished   => '0',            mult_finished   => '0',            unload_finished => '0',                       read_data       => open,            start_load      => open,            start_mult      => open,            start_unload    => open,            rows1           => rows1,            columns1        => columns1,            rows2           => rows2,            columns2        => columns2        );

        process begin
            data_in <= "00000" & "00000" & "00000" & "00000" & "0001" & x"00";
            wait for 20 ns;
            wait;
        end process;


    end rtl;
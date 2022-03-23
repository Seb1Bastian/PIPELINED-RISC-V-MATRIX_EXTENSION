library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pipe_risc_v_nn is
    generic(interface_size : integer :=3; matrix_size : integer:=4);
    port(
        clk_cpu         : in std_logic;
        clk_nn          : in std_logic;
        reset           : in std_logic;
        dtest           : out std_logic_vector(31 downto 0)             --output so that vivado does something (otherwise it sees no output no need to compute anything)
    );
end pipe_risc_v_nn;

architecture rtl of pipe_risc_v_nn is

    signal canWriteDataToAccelerator    : std_logic;
    signal canReadDataFromAccelerator   : std_logic;
    signal canWriteToCPU                : std_logic;
    signal canReadFromCPU               : std_logic;
    signal writeToAccelerator           : std_logic;
    signal readFromAccelerator          : std_logic;
    signal writeDataToCPU               : std_logic;
    signal readDataFromCPU              : std_logic;
    signal dataToAccelerator            : std_logic_vector(31 downto 0);
    signal dataFromAccelerator          : std_logic_vector(31 downto 0);
    signal dataToCPU                    : std_logic_vector(31 downto 0);
    signal dataFromCPU                  : std_logic_vector(31 downto 0);

    begin
        --instantiation pipelined risc v
        inst_pipelined_risc_v : entity work.pipe_risc_v(rtl)
            port map (
                clk             => clk_cpu,
                reset           => reset,
                dataFromAccelerator =>    dataFromAccelerator,
                canReadDataFromAccelerator  => canReadDataFromAccelerator,
                canWriteDataToAccelerator => canWriteDataToAccelerator,
                --outputs
                writeToAccelerator          => writeToAccelerator,
                readFromAccelerator         => readFromAccelerator,
                dataToAccelerator           => dataToAccelerator
            );


        inst_interface : entity work.interface(rtl)
        generic map(interface_size)
        port map(clk_1 => clk_cpu, clk_2=> clk_nn, reset=> reset, data_in1=> dataToAccelerator, data_in2 => dataToCPU, write_data_1=> writeToAccelerator, write_data_2=> writeDataToCPU,
                read_data_1 => readFromAccelerator, read_data_2=> readDataFromCPU, data_out1=> dataFromAccelerator, data_out2=> dataFromCPU,
                can_write1=> canWriteDataToAccelerator, can_write2=> canWriteToCPU, can_read1 => canReadDataFromAccelerator, can_read2 => canReadFromCPU 
                );

        inst_nn : entity work.nn(rtl)
        generic map(matrix_size)
        port map(clk => clk_nn, reset => reset, data_in => dataFromCPU, can_write => canWriteToCPU, can_read => canReadFromCPU, 
                    readFromCPU => readDataFromCPU, writeToCPU => writeDataToCPU, data_out => dataToCPU);


        dtest <= dataToAccelerator;
        
        

    end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_em is
    port(
        --inputs
        clk             : in std_logic;
        en_em           : in std_logic;                         --not( stall )
        clr_em          : in std_logic;                         --flush
        regwrite_e      : in std_logic;
        resultsrc_e     : in std_logic_vector(1 downto 0);
        memwrite_e      : in std_logic;
        aluresult       : in std_logic_vector(31 downto 0);
        writedata_e     : in std_logic_vector(31 downto 0);
        rd_e            : in std_logic_vector(11 downto 7);
        pcplus4_e       : in std_logic_vector(31 downto 0);

        --outputs
        regwrite_m      : buffer std_logic;
        resultsrc_m     : out std_logic_vector(1 downto 0);
        memwrite_m      : out std_logic;
        aluresult_m     : buffer std_logic_vector(31 downto 0);
        writedata_m     : out std_logic_vector(31 downto 0);
        rd_m            : buffer std_logic_vector(11 downto 7);
        pcplus4_m       : out std_logic_vector(31 downto 0);

        --NN
        --inputs
        toAccelerator_e : in std_logic;
        onlyByte_e      : in std_logic;
        --outputs
        toAccelerator_m : out std_logic;
        onlyByte_m      : out std_logic
    );
end reg_em;

architecture rtl of reg_em is

    type ram_type_32 is array(2 downto 0) of std_logic_vector(31 downto 0);
    type ram_type_5 is array(0 downto 0 ) of std_logic_vector(4 downto 0);
    type ram_type_2 is array(0 downto 0) of std_logic_vector(1 downto 0);
    type ram_type_1 is array(1 downto 0) of std_logic;
    type ram_nn_signals is array(1 downto 0) of std_logic;

    signal memory_32    : ram_type_32;
    signal memory_5     : ram_type_5;
    signal memory_2     : ram_type_2;
    signal memory_1     : ram_type_1;
    signal nn_signals   : ram_nn_signals;


    begin
        process(clk)begin
            if rising_edge(clk) then
                if clr_em = '1' then
                    memory_32 <= (others => (others => '0'));
                    memory_5(0) <= (others => '0');
                    memory_2(0) <= (others => '0');
                    memory_1 <= (others =>  '0');
                    nn_signals <= (others =>  '0');
                elsif en_em = '1' then
                    memory_32(0)    <= aluresult;
                    memory_32(1)    <= writedata_e;
                    memory_32(2)    <= pcplus4_e;

                    memory_5(0)     <= rd_e;

                    memory_2(0)     <= resultsrc_e;

                    memory_1(0)     <= regwrite_e;
                    memory_1(1)     <= memwrite_e;
                    nn_signals(0)   <= toAccelerator_e;
                    nn_signals(1)   <= onlyByte_e;
                end if;
            end if ;
            
        end process;

        aluresult_m     <= memory_32(0);
        writedata_m     <= memory_32(1);
        pcplus4_m       <= memory_32(2); 
        
        rd_m            <= memory_5(0);

        resultsrc_m     <= memory_2(0);

        regwrite_m      <= memory_1(0);
        memwrite_m      <= memory_1(1);

        toAccelerator_m <= nn_signals(0);
        onlyByte_m <= nn_signals(1);

    end rtl;
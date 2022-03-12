library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_mw is
    port(
        --inputs
        clk             : in std_logic;
        en_mw           : in std_logic;                         --not( stall )
        clr_mw          : in std_logic;                         --flush
        regwrite_m      : in std_logic;
        resultsrc_m     : in std_logic_vector(1 downto 0);
        aluresult_m     : in std_logic_vector(31 downto 0);
        rd              : in std_logic_vector(31 downto 0);
        rd_m            : in std_logic_vector(11 downto 7);
        pcplus4_m       : in std_logic_vector(31 downto 0);
        --outputs
        regwrite_w      : buffer std_logic;
        resultsrc_w     : out std_logic_vector(1 downto 0);
        aluresult_w     : out std_logic_vector(31 downto 0);
        readdata_w      : out std_logic_vector(31 downto 0);
        rd_w            : buffer std_logic_vector(11 downto 7);
        pcplus4_w       : out std_logic_vector(31 downto 0);


        --NN
        --inputs
        toAccelerator_m : in std_logic;
        --outputs
        toAccelerator_w : out std_logic
    );
end reg_mw;

architecture rtl of reg_mw is

    type ram_type_32 is array(2 downto 0) of std_logic_vector(31 downto 0);
    type ram_type_5 is array(0 downto 0) of std_logic_vector(4 downto 0);
    type ram_type_2 is array(0 downto 0) of std_logic_vector(1 downto 0);
    type ram_type_1 is array(0 downto 0) of std_logic;
    type ram_nn_signals is array(0 downto 0) of std_logic;

    signal memory_32    : ram_type_32;
    signal memory_5     : ram_type_5;
    signal memory_2     : ram_type_2;
    signal memory_1     : ram_type_1;
    signal nn_signals   : ram_nn_signals;

    begin
        process(clk)begin
            if rising_edge(clk) then
                if clr_mw = '1' then                            --flush the register
                    memory_32 <= (others => (others => '0'));
                    
                    memory_5(0) <= (others => '0');
                    memory_2(0) <= (others => '0');
                    memory_1 <= (others => '0');
    
                    nn_signals <= (others => '0');
                elsif en_mw = '1' then                          --update the register/not stall the register
                    
                    memory_32(0)    <= aluresult_m;
                    memory_32(1)    <= rd;
                    memory_32(2)    <= pcplus4_m;
                    
                    memory_5(0)     <= rd_m;
    
                    memory_2(0)     <= resultsrc_m;
    
                    memory_1(0)     <= regwrite_m;
    
                    nn_signals(0)   <= toAccelerator_m;
                end if;
            end if ;
        end process;

        regwrite_w      <= memory_1(0);
        resultsrc_w     <= memory_2(0);
        aluresult_w     <= memory_32(0);
        readdata_w      <= memory_32(1);
        rd_w            <= memory_5(0);
        pcplus4_w       <= memory_32(2);

        toAccelerator_w <= nn_signals(0);

    end rtl;

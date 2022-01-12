library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_matrix is
    generic(matrix_size : integer := 3);
    port(
        --inputs
        clk             : in std_logic;
        start_mult      : in std_logic;
        load_mult       : in std_logic;

        --outputs
        start_mult      : out std_logic;
        started_mult    : out std_logic;
        ongoing_mult    : out std_logic;
        finished_mult   : out std_logic
    );
end control_matrix;


architecture rtl of control_matrix is

    type state is (qo,q1,q2);

    signal counter_mult : integer := 0 ;

    begin

    startmult : process(clk)

        begin
            if(start_mult = '1') then
               started_mult <= '1';
               ongoing_mult <= '1';
               counter_mult <= 1; 
            end if;

        end process;


end rtl;
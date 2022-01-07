library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unary_and IS
    generic (N: positive := 8); --array size
    port (
        inp: in std_logic_vector(N-1 downto 0);
        outp: out std_logic
        );
end unary_and;
-------------------------------------------
architecture rtl of unary_and is
    signal temp: std_logic_vector(N-1 downto 0);
begin
    temp(0) <= inp(0);
    gen: for i in 1 to N-1 generate
        temp(i) <= temp(i-1) and inp(i);
    end generate; 
    outp <= temp(N-1); 
end architecture;
-------------------
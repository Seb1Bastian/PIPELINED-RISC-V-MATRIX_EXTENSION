library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bitCode_to_greyCode is
  generic(length : integer := 32);
  port (
    value_in    : in std_logic_vector(length-1 downto 0);
    value_out   : out std_logic_vector(length-1 downto 0)
  );
end bitCode_to_greyCode;

architecture rtl of bitCode_to_greyCode is
  Signal intern  : std_logic_vector(length-1 downto 0);
  begin

    intern(length-1) <= value_in(length-1);
    xor_gates: for i in 0 to length-2 generate
        intern(i) <= value_in(i+1) xor value_in(i);
   end generate xor_gates; 
   
   value_out <= intern;
end rtl;

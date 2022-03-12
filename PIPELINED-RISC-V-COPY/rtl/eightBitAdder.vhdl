library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity eightBitAdder is
	port(
		a : in std_logic_vector(7 downto 0);
		b : in std_logic_vector(7 downto 0);
		res : out std_logic_vector(7 downto 0)
		);
end eightBitAdder;

architecture rtl of eightBitAdder is
	Signal c : std_logic_vector(7 downto 0);
	Signal over, under : std_logic;
begin
	c(7 downto 0) <= std_logic_vector( unsigned(a(7 downto 0)) + unsigned(b(7 downto 0)));
	over <= c(7) and not (a(7)) and not (b(7));
	under <= not c(7) and a(7) and b(7);
	res <= x"80" when under='1' else x"7F" when over='1' else c;	-- if the result has an overflow the result is set to 127
																	-- if the result has an underflow the result is set to -128
end rtl;
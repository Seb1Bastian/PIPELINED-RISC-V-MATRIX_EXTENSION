library ieee;
use ieee.std_logic_1164.all;

package fifo_mem_pack is
	type BYTE_VECTOR is array (NATURAL range <>) of std_logic_vector(7 downto 0);
	type BYTE_GRID is array (NATURAL range <>, NATURAL range <>) of std_logic_vector(7 downto 0);
end fifo_mem_pack;
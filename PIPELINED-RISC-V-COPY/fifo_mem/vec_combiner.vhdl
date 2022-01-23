library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity vec_combiner is
  generic(N : integer := 32);
  port (
    a   : in FOUR_BYTE_VECTOR(N-1 downto 0);
    b   : in FOUR_BYTE_VECTOR(N-1 downto 0);
    c   : out FOUR_BYTE_VECTOR(N-1 downto 0)
  );
end vec_combiner;

architecture rtl of vec_combiner is
  begin
    OR_Gates: 
    for i in 0 to N-1 generate
        c(i) <= a(i) or b(i);
    end generate;

end rtl;


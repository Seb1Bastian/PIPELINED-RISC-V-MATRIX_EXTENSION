library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity vec_combiner is
  generic(N : integer := 32);
  port (
    a   : in std_logic_vector(31 downto 0);
    b   : in FOUR_BYTE_VECTOR(N-1 downto 0);
    sel : in integer;
    c   : out FOUR_BYTE_VECTOR(N-1 downto 0)
  );
end vec_combiner;

architecture rtl of vec_combiner is
  begin
    process(a, b, sel) begin
      for i in 0 to N-1 loop
        if i = sel then
          c(i) <= a;
        else
          c(i) <= b(i);
        end if;
      end loop;
    end process;

end rtl;


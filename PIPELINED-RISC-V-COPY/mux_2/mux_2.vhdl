library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2 is
  generic(N : integer := 32);
  port (
    a   : in std_logic_vector(N-1 downto 0);
    b   : in std_logic_vector(N-1 downto 0);
    sel   : in std_logic;
    y   : out std_logic_vector(N-1 downto 0)
  );
end mux_2;

architecture rtl of mux_2 is
  begin
    process(sel,a,b,c)
      begin
        if(sel = '0')then
          y <= a;
        elsif(sel = '1')then
          y <= b;
        end if;
      end process;
end rtl;

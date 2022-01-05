library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_2 is
  generic(N : integer := 32);
  port (
    port_in1   : in std_logic_vector(N-1 downto 0);
    port_in2   : in std_logic_vector(N-1 downto 0);
    sel   : in std_logic;
    port_out   : out std_logic_vector(N-1 downto 0)
  );
end mux_2;

architecture rtl of mux_2 is
  begin
    process(sel,port_in1,port_in2)
      begin
        if(sel = '0')then
          port_out <= port_in1;
        elsif(sel = '1')then
          port_out <= port_in2;
        end if;
      end process;
end rtl;

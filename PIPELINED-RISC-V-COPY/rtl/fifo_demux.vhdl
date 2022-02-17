library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_demux is
  generic(N : integer := 32);
  port (
    port_in    : in std_logic_vector(31 downto 0);
    sel        : in integer;
    port_out   : out FOUR_BYTE_VECTOR(N-1 downto 0)
  );
end fifo_demux;

architecture rtl of fifo_demux is
  begin
    process(port_in, sel) begin
      for i in 0 to N-1 loop
        if i = sel then
          port_out(i) <= port_in;
        else
          port_out(i) <= x"00000000";
        end if;
      end loop;
    end process;
end rtl;

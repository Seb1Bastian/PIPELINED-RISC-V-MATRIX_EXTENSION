library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_mux is                                --standard multiplexer
  generic(N : integer := 32);
  port (
    port_in   : in FOUR_BYTE_VECTOR(N-1 downto 0);
    sel        : in integer;
    port_out   : out std_logic_vector(31 downto 0)
  );
end fifo_mux;

architecture rtl of fifo_mux is
  begin
     port_out <= port_in(sel);
end rtl;

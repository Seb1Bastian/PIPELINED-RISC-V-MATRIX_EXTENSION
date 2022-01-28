library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 


entity sa is --filler file
	generic (max_size : integer := 8);
	port ( -- c: clock; r: reset
        clk      : in std_logic;
        reset    : in std_logic;
        start    : in std_logic;
		a        : in BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);
		b        : in BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);
		d        : out BYTE_GRID(max_size-1 downto 0, max_size-1 downto 0);
        finished : out std_logic
	);
end sa;


architecture rtl of sa is
	
	-- ?
begin

	process(clk) begin
		if rising_edge(clk) then
			if start = '1' then
				for i in 0 to max_size-1 loop
					for j in 0 to max_size-1 loop
						if i<j then
							d(i,j) <= a(i,j);
						else
							d(i,j) <= b(i,j);
						end if;
					end loop ;     
				end loop ;
				finished <= '1';
			else
				finished <= '0';
			end if;
		end if ;
	end process;
	-- ?
end rtl;
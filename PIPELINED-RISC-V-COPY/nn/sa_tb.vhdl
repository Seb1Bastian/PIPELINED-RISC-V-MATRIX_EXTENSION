library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 


entity sa_tb is -- systolic array
end sa_tb;


architecture behavior of sa_tb is
	
	Signal clk, reset, start, finished : std_logic;
    Signal a,b,d : BYTE_GRID(15 downto 0, 15 downto 0);
begin

    
    sa : entity work.sa(rtl)
    generic map(16)
    port map(
        clk => clk,
        reset => reset,
        start => start,
        a => a,
        b => b,
        d => d,
        finished => finished
    );

	process begin
        wait for 20 ns;
        wait;
	end process;
	-- ?
end behavior;
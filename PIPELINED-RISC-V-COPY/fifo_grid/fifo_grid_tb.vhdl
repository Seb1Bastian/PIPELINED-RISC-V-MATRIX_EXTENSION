library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity fifo_grid_tb is
end fifo_grid_tb;


architecture rtl of fifo_grid_tb is

    Signal clk      : std_logic;
    Signal reset      : std_logic;
    Signal write_en1      : std_logic;
    Signal shift_grid1      : std_logic;
    Signal pos_x11      : integer;
    Signal pos_x12      : integer;
    Signal pos_x21      : integer;
    Signal pos_x22      : integer;
    Signal write_en2      : std_logic;
    Signal shift_grid2      : std_logic;
    Signal data_in      : std_logic_vector(31 downto 0);
    Signal g1           : BYTE_GRID(2 downto 0, 2 downto 0);
    Signal g2           : BYTE_GRID(2 downto 0, 2 downto 0);
    Signal a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r : std_logic_vector(7 downto 0);

    begin
        a <= g1(0,0);
        b <= g1(0,1);
        c <= g1(0,2);
        d <= g1(1,0);
        e <= g1(1,1);
        f <= g1(1,2);
        g <= g1(2,0);
        h <= g1(2,1);
        i <= g1(2,2);
        j <= g2(0,0);
        k <= g2(0,1);
        l <= g2(0,2);
        m <= g2(1,0);
        n <= g2(1,1);
        o <= g2(1,2);
        p <= g2(2,0);
        q <= g2(2,1);
        r <= g2(2,2);

    fifo_grid_matrix1 : entity work.fifo_grid(rtl)
    generic map (3)
    port map(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en1,
        shift       => shift_grid1,
        pos_x1      => pos_x11,
        pos_x2      => pos_x12,
        data_in     => data_in(7 downto 0),
        --outputs
        data_out    => g1
    );

    fifo_grid_matrix2 : entity work.fifo_grid_vertical(rtl)
    generic map(3)
    port map(
        --inputs
        clk         => clk,
        reset       => reset,
        write_en    => write_en1,
        shift       => shift_grid1,
        pos_x1      => pos_x11,
        pos_x2      => pos_x12,
        data_in     => data_in(7 downto 0),
        --outputs
        data_out    => g2
    );

    process begin
        pos_x11 <= 0;
        pos_x12 <= 0;
        write_en1 <= '1';
        data_in(7 downto 0) <= x"00";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 0;
        pos_x12 <= 1;
        data_in(7 downto 0) <= x"01";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 0;
        pos_x12 <= 2;
        data_in(7 downto 0) <= x"02";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 1;
        pos_x12 <= 0;
        data_in(7 downto 0) <= x"03";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 1;
        pos_x12 <= 1;
        data_in(7 downto 0) <= x"04";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 1;
        pos_x12 <= 2;
        data_in(7 downto 0) <= x"05";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 2;
        pos_x12 <= 0;
        data_in(7 downto 0) <= x"06";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 2;
        pos_x12 <= 1;
        data_in(7 downto 0) <= x"07";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        pos_x11 <= 2;
        pos_x12 <= 2;
        data_in(7 downto 0) <= x"08";
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        write_en1 <= '0';
        shift_grid1 <= '1';
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;

        wait;
    end process;

end rtl;

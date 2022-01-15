library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instr_mem is
    port(
        --input
        addr_instr  : in std_logic_vector(31 downto 0);
        --output
        rd_instr    : out std_logic_vector(31 downto 0)
    );
end instr_mem;

architecture rtl of instr_mem is

    type romtype is array (63 downto 0) of std_logic_vector(31 downto 0);
    signal mem: romtype;

    begin
        mem(0) <= "00000000010000000000000010010011"; --addi x1, x0, 4
		mem(1) <= "00000000000100000000000010100011"; --sw x1, x0 + 1
        mem(2) <= "00000000000000000000000000010011"; --addi x0, x0, 0
        mem(3) <= "00000000000000000000000000010011";
        mem(4) <= "00000000000000000000000000010011";
        mem(5) <= "00000000000000000000000000010011";
        mem(6) <= "00000000000000000000000000010011";
		mem(7) <= "00000000000100000000000100000011";  --lw x2, x0 + 1
		mem(8) <= "00000000000000010000001000110011"; --add x4, x0, x2
		mem(9) <= "00000000000000000000000000010011";  --addi x0, x0, 0
		mem(10) <= "00000000000000000000000000010011";
		mem(11) <= "00000000000000000000000000010011";
		mem(12) <= "00000000000000000000000000010011";
		mem(13) <= "00000000000000000000000000010011";
        --mem(0) <= x"000002b3"; --addi x2, x0, 2
        --mem(1) <= x"00100313"; --addi x3, x0, 5
        --mem(2) <= x"00600533"; --add x4, x3, x2
        --mem(3) <= x"006282b3"; --sub x4, x4, x2
        --mem(4) <= x"00500533"; --sw x4, 38(x3)
        --mem(5) <= x"00628333"; --lw x2, 43(x0)
        --mem(6) <= x"00600533"; --and x5, x2, x4
        --mem(7) <= x"fe0008e3"; --or x6, x5, x2
      --  mem(8) <= x"00532333"; --slt x6, x6, x5
      --  mem(9) <= x"0262A823"; --sw x6, 48(x5)

      

        process(addr_instr)begin
            rd_instr <= mem(to_integer(unsigned(addr_instr(31 downto 2))));
        end process;
    end rtl;

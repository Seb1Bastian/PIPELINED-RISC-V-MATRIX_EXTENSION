library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
    port(
        --inputs
        SrcA        : in std_logic_vector(31 downto 0);
        SrcB        : in std_logic_vector(31 downto 0);
        ALUControl  : in std_logic_vector(2 downto 0);
        --outputs
        Zero        : out std_logic;
        ALUResult   : buffer std_logic_vector(31 downto 0)
    );
end ALU;

architecture rtl of ALU is

    signal alu_res : std_logic_vector(31 downto 0);
    signal eight_res : std_logic_vector(7 downto 0);
    
    begin
        process(SrcA, SrcB, ALUControl)begin
            case ALUControl is
                --add
                when "000" => alu_res <= std_logic_vector(unsigned(SrcA) + unsigned(SrcB));
                --sub
                when "001" => alu_res <= std_logic_vector(unsigned(SrcA) - unsigned(SrcB));
                --and
                when "010" => alu_res <= SrcA and SrcB;
                --or
                when "011" => alu_res <= SrcA or SrcB;
                --slt
                when "101" => 
                    if(SrcA < SrcB)then
                        alu_res <= x"00000001";
                    else 
                    alu_res <= x"00000000";
                    end if;
                --shift left
                when "110" => alu_res <= std_logic_vector(shift_left(unsigned(SrcA), to_integer(unsigned(SrcB))));
                --eight Bit Addition
                when "111" => alu_res <= x"000000" & eight_res;
                --Undefined
                when others => alu_res <= (others => 'U');
                end case;
            end process;


            inst_eightBitAdder : entity work.eightBitAdder(rtl)
            port map(
                a => SrcA(7 downto 0),
                b => SrcB(7 downto 0),
                res => eight_res
            );
            
            Zero <= '1' when alu_res = x"00000000" else '0';
            ALUResult <= alu_res;
    end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_controller is
    generic(max_entries : integer range 2 to 255 := 3); -- the max number of entries in the matrix.
    port(
        --inputs
        clk           : in std_logic;
        nn_opcode     : in std_logic_vector(15 downto 0);
        load_finished : in std_logic;

        --outputs
        start_load   : out std_logic;
        entries      : out integer range 0 to 255;
        size         : out integer range 0 to 16
    );
end nn_controller;
    
    
architecture rtl of nn_controller is

    signal controls : std_logic_vector( 0 downto 0);
begin

    entries <= to_Integer(nn_opcode(15 downto 8));
    size    <= to_Integer(nn_opcode( 7 downto 4));

    process(op)begin
        case op is
            when "0001" => controls <= "1"; --Matrixmultiplication
            when others => controls <= "-"; --undefined for other cases
        end case;
    end process;

    start_load  <= controls(0) and not load_finished;
    start_mult  <= controls(0) and load_finished;

end rtl;
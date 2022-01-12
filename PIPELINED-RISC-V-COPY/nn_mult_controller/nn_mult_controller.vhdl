library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.fifo_mem_pack.ALL; 

entity nn_mult_controller is
    generic(Number_of_cyles_mult : integer range 0 to 16 := 8); -- the max number of entries in the matrix.
    port(
        --inputs
        clk           : in std_logic;
        start         : in std_logic;

        --outputs
        finished      : out std_logic;
        shift         : out std_logic
    );
end nn_mult_controller;
    
    
architecture rtl of nn_mult_controller is

begin

end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    generic(size : integer range 2 to 255 := 3); -- the specificed number of rising edges until the finished signal turns to one
    port(
        --inputs
        clk         : in std_logic;
        start       : in std_logic;
        reset       : in std_logic;  -- synchron Reset

        --outputs
        waiting     : out std_logic; -- is 1 when it can start counting else 0
        ongoing     : out std_logic; -- is 1 when it is counting at the moment else 0
        finished    : out std_logic  -- is 1 when it is finished counting else 0
    );
end counter;


architecture rtl of counter is
    signal counter_state: integer range 0 to 255 := 1;
    signal intern_waiting : std_logic := '1';
    signal intern_ongoing, intern_finished : std_logic := '0';

    begin

     process(clk,reset)
        begin
            if reset = '1' and clk = '1' then
                counter_state <= 1;
                intern_ongoing <= '0';
                intern_finished <= '0';
                intern_waiting <= '1';
            elsif counter_state = 1 and start = '1' and clk = '1' then
                intern_waiting <= '0';
                intern_ongoing <= '1';
                counter_state <= 1 + counter_state;
            elsif counter_state > 1 and counter_state < size and clk = '1' then
               counter_state <= 1 + counter_state; 
            elsif counter_state = size and clk = '1' then
                intern_ongoing <= '0';
                intern_finished <= '1';                
            end if;
        end process;

        waiting <= intern_waiting;
        ongoing <= intern_ongoing;
        finished <= intern_finished;

end rtl;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memr is
    port(
        --inputs
        addr_port   : in std_logic_vector(31 downto 0);
        write_data  : in std_logic_vector(31 downto 0);
        clk         : in std_logic;
        write_en    : in std_logic;
        --output
        read_data   : out std_logic_vector(31 downto 0);

        --NN
        --inputs
        byte_en     : in std_logic

    );
end data_memr;

architecture rtl of data_memr is

    type ram_type is array (63 downto 0) of std_logic_vector(31 downto 0);
    
    signal mem : ram_type := ((0) => (x"0000" & x"03" & x"03"),
                              (1) => (x"03020100"),
                              (2) => (x"07060504"),
                              (3) => (x"00000008"),
                              (4) => (x"0000" & x"03" & x"03"),
                              (5) => (x"0D0C0B0A"),
                              (6) => (x"11100F0E"),
                              (7) => (x"00000012"),
                              others =>( others => '0'));
    
    begin
        process(clk, write_en) 
            variable upper_mem : std_logic_vector(31 downto 0);
        begin
                if rising_edge(clk) then
                    if(write_en = '1')then
                        case( byte_en ) is
                            when '0' => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= write_data;
                            when '1' => 
                                case( addr_port(1 downto 0)) is
                                    when "00" => mem(to_integer(unsigned(addr_port(7 downto 2))))(7 downto 0) <= write_data(7 downto 0);
                                    when "01" => mem(to_integer(unsigned(addr_port(7 downto 2))))(15 downto 8) <= write_data(7 downto 0);
                                    when "10" => mem(to_integer(unsigned(addr_port(7 downto 2))))(23 downto 16) <= write_data(7 downto 0);
                                    when "11" => mem(to_integer(unsigned(addr_port(7 downto 2))))(31 downto 24) <= write_data(7 downto 0);
                                    when others => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= "11111111111111111111111111111111";
                                end case;
                            when others => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= "10101010101010101010101010101010";
                        end case;
                    end if;
                end if;
        end process;

        


        process(addr_port,clk,mem,byte_en)begin
             case( byte_en ) is
                when '0' => read_data <= mem(to_integer(unsigned(addr_port(7 downto 2))));
                when '1' => case( addr_port(1 downto 0)) is
                                when "00" => read_data <= x"000000" & mem(to_integer(unsigned(addr_port(7 downto 2))))(7 downto 0);
                                when "01" => read_data <= x"000000" & mem(to_integer(unsigned(addr_port(7 downto 2))))(15 downto 8);
                                when "10" => read_data <= x"000000" & mem(to_integer(unsigned(addr_port(7 downto 2))))(23 downto 16);
                                when "11" => read_data <= x"000000" & mem(to_integer(unsigned(addr_port(7 downto 2))))(31 downto 24);
                                when others => read_data <= "11111111111111111111111111111111";
                            end case;
                when others => read_data <= "11101010101010101010101010101010";
             end case;
        end process;
    end rtl;
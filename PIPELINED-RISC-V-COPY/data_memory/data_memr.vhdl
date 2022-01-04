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
    
    signal mem : ram_type := (others => (others => '0'));
    
    begin
        process(clk, write_en) 
            variable upper_mem : std_logic_vector(31 downto 0);
        begin
                if rising_edge(clk) then
                    if(write_en = '1')then
                        case( byte_en ) is
                            when '0' => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= write_data;
                            when '1' => upper_mem := mem(to_integer(unsigned(addr_port(7 downto 2))));
                                        case( addr_port(1 downto 0)) is
                                            when "00" => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= upper_mem(31 downto 8) & write_data(7 downto 0);
                                            when "01" => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= upper_mem(31 downto 16) & write_data(7 downto 0) & upper_mem(7 downto 0);
                                            when "10" => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= upper_mem(31 downto 24) & write_data(7 downto 0) & upper_mem(15 downto 0);
                                            when "11" => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= write_data(7 downto 0) & upper_mem(23 downto 0);
                                            when others => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= "11111111111111111111111111111111";
                                        end case;
                            when others => mem(to_integer(unsigned(addr_port(7 downto 2)))) <= "10101010101010101010101010101010";
                        end case ;
                    end if;
                end if;
        end process;

        


        process(addr_port)begin
            read_data <= mem(to_integer(unsigned(addr_port(7 downto 2))));
        end process;
    end rtl;
entity sa is -- systolic array
	generic (
		matrix_size : Integer := 8
	);
	port ( -- c: clock; r: reset
        clk      : in std_logic;
        reset    : in std_logic;
        start    : in std_logic;
		a        : in array(matrix_size, matrix_size) of std_logic_vector(7 downto 0);
		b        : in array(matrix_size, matrix_size) of std_logic_vector(7 downto 0);
		d        : out array(matrix_size, matrix_size) of std_logic_vector(7 downto 0);
        finished : out std_logic
	);
end sa;


architecture behavior of sa is
	
	-- ?
begin
	-- ?
end behavior;
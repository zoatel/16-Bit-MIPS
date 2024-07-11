library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity ROM is
	 Port (
			clk : in std_logic;
			Address : in STD_LOGIC_VECTOR (7 downto 0);
			Data	  : out STD_LOGIC_VECTOR (15 downto 0)
		);
end ROM;
architecture Be of ROM is
	type ROM is array (0 to 255) of std_logic_vector(15 downto 0);
	signal IM : ROM := ("0111000000000001",
						"0111001000001111",
						"0001001000001001",
						"1110000000000101",
						"1111000000000010",
						"1111000000000000",
						others => "0000000000000000"
						); 
	begin
		Data <= IM(to_integer(unsigned(Address)));
	 
	
end Be;
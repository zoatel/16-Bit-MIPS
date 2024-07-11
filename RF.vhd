library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity RF is
    port (
		clk,RegWrite : in std_logic;
		RRegister1 : in std_logic_vector(2 downto 0);
		RRegister2 : in std_logic_vector(2 downto 0);
	    WRegister : in std_logic_vector(2 downto 0);
		WData : in std_logic_vector(15 downto 0);
		RData1 : out std_logic_vector(15 downto 0);
		RData2 : out std_logic_vector(15 downto 0)
		);
end RF;

architecture Be of RF is
	type RF is array (0 to 7) of std_logic_vector(15 downto 0);
	signal array_reg : RF := (others => "0000000000000000"); 
	begin
		process(clk) 
			begin
			if rising_edge(clk) then 
				if (RegWrite = '1') then 
					array_reg(to_integer(unsigned(WRegister))) <= WData;
				end if;
				RData1 <= array_reg(to_integer(unsigned(RRegister1)));
				RData2 <= array_reg(to_integer(unsigned(RRegister2)));
			end if;
		end process;
		
		

end Be;
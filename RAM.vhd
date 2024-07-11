library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity RAM is
    port (
		clk, MemWrite : in std_logic;
		Address : in std_logic_vector(7 downto 0);
		WData : in std_logic_vector(15 downto 0);
		RData : out std_logic_vector(15 downto 0));
end RAM;

architecture Be of RAM is
	type RAM is array (0 to 255) of std_logic_vector(15 downto 0);
	signal DM : RAM := (others => "0000000000000000"); 
	begin
		  process (clk)
			begin
			if rising_edge(clk) then 
				if (MemWrite = '1') then 
					DM(to_integer(unsigned(Address))) <= WData;
				end if;
				RData <= DM(to_integer(unsigned(Address)));
			end if;
		end process;
end Be;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
 
entity ALU is
 Port ( E : in std_logic;
		S   : in std_logic_vector (2 downto 0);
		A, B: in std_logic_vector(15 downto 0);
		F : out std_logic_vector(15 downto 0);
		C : out std_logic
		);
end ALU;
 
architecture Be of ALU is
begin
process(A, B, S)
	variable temp : std_logic_vector(16 downto 0);
	begin
		case E is
				when '1' =>
							case S is
								when "000" =>
									temp := std_logic_vector(resize(("0" & signed(A)) + signed(B), temp'length));
									F <= temp(15 downto 0);
									C <= temp(16);

								when "001" =>
									F <= std_logic_vector(unsigned(A) - unsigned(B));
								when "010" =>
									temp := std_logic_vector(resize(("0" & signed(A)) * signed(B), temp'length));
									F <= temp(15 downto 0);
									C <= temp(16);
								when "011" =>
									temp := std_logic_vector(resize(("0" & signed(A)) / signed(B), temp'length));
									F <= temp(15 downto 0);
									C <= temp(16);
								when "100" =>
									F <= A and B;

								when "101" =>
									F <= A or B;
								when "110" =>
									F <= A xor B;
								when "111" =>
									F <= not A;
								when others =>  NULL;
						end case;
				when others =>  
					F <= "ZZZZZZZZZZZZZZZZ";
		end case;
		
end process;
 
end Be;
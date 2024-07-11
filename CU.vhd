library IEEE;
use IEEE.std_logic_1164.ALL;

entity CU is
	port (
		clk														  : in std_logic;
		branch													  : out std_logic;
		PC_next													  : out std_logic_vector(7 downto 0);
		inst													  : in std_logic_vector(15 downto 0);
		alu_S													  : out std_logic_vector(2 downto 0);
		alu_B													  : out std_logic_vector(15 downto 0);
		alu_F													  : in std_logic_vector(15 downto 0);
		alu_C													  : in std_logic;
		alu_ena													  : out std_logic;
		mem_address												  : out std_logic_vector(7 downto 0);
		mem_ena													  : out std_logic;
		mem_r													  : in std_logic_vector(15 downto 0);
		reg_write												  : out std_logic_vector(15 downto 0);
		reg_write_address, reg_read_address_1, reg_read_address_2 : out std_logic_vector(2 downto 0);
		RData1													  : in std_logic_vector(15 downto 0);
		RData2													  : in std_logic_vector(15 downto 0);
		reg_ena													  : out std_logic
	);
end entity CU;

architecture Be of CU is
	signal OP_code: std_logic_vector (3 downto 0);
	signal Rs, Rt, Rd, alu_func: std_logic_vector(2 downto 0);
	signal imm_arth, imm_load: std_logic_vector(15 downto 0);
	signal ucBrach_address, cBrach_address: std_logic_vector(7 downto 0);
	signal Flag_reg: std_logic_vector (4 downto 0);
	begin
		OP_code <= inst(15 downto 12);
		Rs <= inst(11 downto 9);
		Rt <= inst(8 downto 6);
		Rd <= inst(5 downto 3);
		alu_func <= inst(2 downto 0);
		
		ucBrach_address <= inst(7 downto 0);
		cBrach_address <= "00" & inst(5 downto 0);
		
		mem_address <= ucBrach_address;
		
		reg_read_address_1 <= Rs;
		reg_read_address_2 <= Rt;
		with inst(5) select
		  imm_arth <= "1111111111" & inst(5 downto 0) when '1',
					  "0000000000" & inst(5 downto 0) when others;
		with inst(8) select
		  imm_load <= "1111111" & inst(8 downto 0) when '1',
					  "0000000" & inst(8 downto 0) when others;
		with OP_code select
		  alu_ena <= '1' when "0001" | "0010" | "0011" | "0100" | "0101" | "0110",
					 '0'  when others;
		with OP_code select
		  alu_B <= RData2 when "0001" | "1010" | "1011" | "1100",
				   imm_arth  when others;
		with OP_code select
		  alu_S <= alu_func when "0001",
				   "000" when "0010",
				   alu_func(alu_S'range) when "0100" | "0101" | "0110",
				   "001" when others;
		with OP_code select
		  reg_write <= mem_r when "1000",
				   imm_load when "0111",
				   alu_F when others;
		with OP_code select
		  reg_write_address <= Rd when "0001",
					Rs when "0111" | "1000",
					Rt when others;
		with OP_code select
		  PC_next <= ucBrach_address when "1111",
				   cBrach_address when others;
		with OP_code select
		  mem_ena <= '1' when "1001",
				   '0' when others;
		with OP_code select
		  reg_ena <= '1' when "0001" | "0010" | "0011" | "0100" | "0101" | "0110" | "0111" | "1000",
				   '0' when others;
		with OP_code select
		  branch <= Flag_reg(2) when "1010",
					Flag_reg(3) when "1011",
					Flag_reg(4) when "1100",
					Flag_reg(1) when "1101",
					Flag_reg(0) when "1110",
					'1' when "1111",
					'0' when others;
		process (clk)
			begin
			if rising_edge (clk) then
				if (RData1 = RData2) then
					Flag_reg(2) <= '1';
					Flag_reg(3) <= '0';
					Flag_reg(4) <= '0';
				elsif (RData1 > RData1) then 
					Flag_reg(3) <= '1';
					Flag_reg(2) <= '0';
					Flag_reg(4) <= '0';
				else
					Flag_reg(4) <= '1';
					Flag_reg(2) <= '0';
					Flag_reg(3) <= '0';
				end if;
				case OP_code is
					when "0001" | "0010" | "0011" | "0100" | "0101" | "0110" | "1010" | "1011" | "1100" =>
						Flag_reg(1) <= alu_C;
						case alu_F is
							when "0000000000000000" => Flag_reg(0) <= '1';
							when others =>  Flag_reg(0) <= '0';
						end case;
					when others => NULL;
				end case;
			end if;
		end process;
end Be;

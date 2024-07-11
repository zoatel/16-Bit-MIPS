library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.numeric_std.ALL;


entity MIPS is
	port (
		clk, reset: in std_logic;
		pc_out : out std_logic_vector (8-1 downto 0);
		alu_out : out std_logic_vector(16-1 downto 0)
	);
end entity MIPS;
architecture Be of MIPS is
	component ROM is
		Port (
			clk     : in std_logic;
			Address : in STD_LOGIC_VECTOR (7 downto 0);
			Data	: out STD_LOGIC_VECTOR (15 downto 0)
		);
	end component;
	component ALU is
		Port ( 
			E   : in std_logic;
			S   : in std_logic_vector (2 downto 0);
			A, B: in std_logic_vector(15 downto 0);
			F   : out std_logic_vector(15 downto 0);
			C   : out std_logic
		);
	end component;
	component RAM is
		port (
			clk, MemWrite : in std_logic;
			Address       : in std_logic_vector(7 downto 0);
			WData 		  : in std_logic_vector(15 downto 0);
			RData         : out std_logic_vector(15 downto 0)
		);
	end component;
	component RF is
		port (
			clk,RegWrite : in std_logic;
			RRegister1   : in std_logic_vector(2 downto 0);
			RRegister2   : in std_logic_vector(2 downto 0);
			WRegister    : in std_logic_vector(2 downto 0);
			WData 		 : in std_logic_vector(15 downto 0);
			RData1 		 : out std_logic_vector(15 downto 0);
			RData2 		 : out std_logic_vector(15 downto 0)
		);
	end component;
	component CU is
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
	end component;
	signal alu_C, mem_ena, reg_ena, alu_ena : std_logic;
	signal alu_S, reg_write_address, reg_read_address_1, reg_read_address_2 : std_logic_vector (2 downto 0);
	signal alu_B, alu_F, RData1, RData2, WData, mem_R, inst: std_logic_vector (15 downto 0);
	signal mem_address, PC, cu_PC_next: std_logic_vector (7 downto 0);
	signal waitting_exc, branch: std_logic;
	begin
	regx: RF port map(clk, reg_ena, reg_read_address_1, reg_read_address_2, reg_write_address, WData, RData1, RData2);
	memx: RAM port map(clk, mem_ena, mem_address, RData1, mem_R);
	romx: ROM port map(clk, PC, inst);
	alux: ALU port map(alu_ena,alu_S, RData1, alu_B, alu_F, alu_C);
	cux: CU port map(clk, branch, cu_PC_next, inst, alu_S, alu_B, alu_F, alu_C, alu_ena, mem_address, mem_ena, mem_R, WData, reg_write_address, reg_read_address_1, reg_read_address_2, RData1, RData2, reg_ena);
	process (clk)
		begin
		if rising_edge(clk) then
			if reset = '1' then
				PC <= "00000000";
				waitting_exc <= '0';
			elsif waitting_exc = '1' then
				PC <= PC + 1;
				waitting_exc <= '0';
				pc_out <= PC;
				alu_out <= alu_F;
			else
				waitting_exc <= '1';
			end if;
			if branch = '1' then
				PC <= cu_PC_next;
				waitting_exc <= '0';
			end if;
		end if;
	end process;
  
end Be;

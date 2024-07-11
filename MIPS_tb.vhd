library IEEE;
use IEEE.std_logic_1164.ALL;
use IEEE.numeric_std.ALL;

entity MIPS_tb is
end entity MIPS_tb;


architecture tb of MIPS_tb is
  component MIPS is
  port (
    clk, reset: in std_logic;
	pc_out : out std_logic_vector (8-1 downto 0);
	alu_out : out std_logic_vector(16-1 downto 0)
  );
  end component;
  signal clk, reset : std_logic := '0';
  signal pc_out : std_logic_vector (8-1 downto 0) := "00000000";
  signal alu_out : std_logic_vector(16-1 downto 0):= "0000000000000000";
begin
  cpu1: MIPS port map(clk, reset,pc_out,alu_out);
  clk<=not clk after 0.25 ns;
  process
  begin
   reset <= '1';
   wait for 1 ns;
   reset <= '0';
   wait;
  end process;
end tb;

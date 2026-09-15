library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;


entity TB_freq_div is
end TB_freq_div;

architecture Behavioral of TB_freq_div is

signal clk_100: std_logic := '0';
signal clk_n: std_logic;

CONSTANT N_DIV: integer := 4;

component freq_div is
   generic (
    div: integer range 2 to 32:= 4
   );
   Port (
     clk: in std_logic;
     clk_out: out std_logic
    );
 end component;

constant clk_100_period: time := 10 ns;

begin

Simulation_clk_100: process
begin
clk_100<= '0';
wait for clk_100_period/2;
clk_100<= '1';
wait for clk_100_period/2;
end process;

TEST_component:  freq_div generic map (div => N_DIV)
port map(
clk => clk_100,
clk_out => clk_n
);

end Behavioral;

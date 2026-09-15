library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TB_LFSR8_in_top_module_game is
end TB_LFSR8_in_top_module_game;

architecture Behavioral of TB_LFSR8_in_top_module_game is

component LFSR8 is
 generic (
    left_board: integer range 0 to 80 := 0;
    right_board: integer range 190 to 255 := 255
 );
 port (
       clk: in std_logic;
       reset: in std_logic;
       enable: in std_logic;
       output: OUT std_logic_vector (7 DOWNTO 0)
       );
end component;

constant clk_100_period: time := 10 ns;
signal clk_100:  std_logic:= '0';
signal reset  :  std_logic:= '1';         
signal random_num_integer: integer range 0 to 255;
signal random_num_vec: std_logic_vector(7 downto 0);
begin

-- imitation clk_100 MGZ
UT_clk_100: process
begin
clk_100 <= '0';
wait for clk_100_period/2;
clk_100 <= '1';
wait for clk_100_period/2;
end process UT_clk_100;  

LFSR_gen: LFSR8 
generic map (
    left_board => 80,    
    right_board => 190    
)
port map (
    clk => clk_100,      
    reset => reset,
    enable => '1',        
    output => random_num_vec
);
random_num_integer <= to_integer(unsigned(random_num_vec));

process
begin
 
wait for 10 ns;
reset <= '1';
wait for 200 ns;
reset <= '0';
wait;
end process;

end Behavioral;

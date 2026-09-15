library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity flappy_bird is
  Port (
         clk_100 : in  std_logic;        
         reset   : in  std_logic;         
         BTTN_UP : in std_logic;  
         BTTN_START : in std_logic; 
         vga_red   : out std_logic_vector(3 downto 0);  
         vga_green : out std_logic_vector(3 downto 0);  
         vga_blue  : out std_logic_vector(3 downto 0);
         
         vga_hsync : out std_logic;       
         vga_vsync : out std_logic  
   );
end flappy_bird;

architecture Behavioral of flappy_bird is



component freq_div is
   generic (
    div: integer range 2 to 32:= 4
   );
   Port (
     clk: in std_logic;
     clk_out: out std_logic
    );
 end component;

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
 
 -- constant for game 
 
  -- game logic
 -- BIRD
 constant MAX_FALLING_SPEED: integer := 15;
 constant BIRD_SIZE:    integer   := 32; -- 64 px* 64 px
 constant BIRD_JUMP:    integer   := 20; -- +20 px for height bird  -- then button have been activated
 constant BIRD_SPEED_START_FALLING: integer := 2;  -- -8 px for height bird -- always  
 constant BIRD_ACCELERATION_FALLING: integer := 1;  -- -8 px for height bird -- always  
  constant BIRD_X :     integer := (640-BIRD_SIZE)/2; 
  
 -- SCREEN into VGA

 constant H_MAX_VISIBLE: integer := 640-1;
 constant V_MAX_VISIBLE: integer := 480-1;
-- constant BIRD_SIZE: integer   := 32;
 constant PIPE_SPEED: integer := 5;
 constant GAP_HEIGHT : integer := 150; 
 constant PIPE_WIDTH : integer := 80; 

 
 constant GROUND_HEIGHT : integer := 55; 
 constant GRASS_HEIGHT : integer := 5; 
 

 signal game_clk : std_logic := '0';
 signal random_num : std_logic_vector(7 downto 0);
 signal random_enable : std_logic;
 signal pixel_clk : std_logic;
 
 
 signal bird_y : integer range 0 to 479 := 240;
 signal pipe_x : integer range 0 to 639 := 400;
 signal gap_y : integer range 0 to 479;
signal  is_game: std_logic:= '0';
  
 -- 7 segment for out 00-99 
 signal segment_7: std_logic_vector(6 downto 0):= (others => '0'); 
 signal num_of_digit_display: integer range 0 to 3:= 0; 
  
 signal score: integer range 0 to 99:= 0;

 --BTTN 
 signal btn_up_reg   : std_logic_vector(2 downto 0) := (others => '0');
 signal btn_up_pressed : std_logic := '0';
 
 signal Bird_speed: integer range 2 to MAX_FALLING_SPEED;

  signal btn_start_reg    : std_logic_vector(2 downto 0) := (others => '0');
  signal btn_start_pressed : std_logic := '0';


  signal slow_counter : integer range 0 to 4*2500000 := 0;
  
  type game_state_type is (IDLE, PLAYING, GAME_OVER);
  signal state : game_state_type := IDLE;
  
begin 

-- out score on 7-segment
 process (clk_100)
 begin 
 
 if rising_edge(clk_100) then
    if game_clk = '1' then
    
    end if;
 end if;
 
 end process;
 
 -- Game logic
process (clk_100, reset)
begin 
    if reset = '1' then
            bird_y <= 240;
            pipe_x <= 400;
            gap_y <= 150;
            score <= 0;
            state <= IDLE;
            is_game <= '0';
            bird_speed <= BIRD_SPEED_START_FALLING;   
    elsif rising_edge(clk_100) then
        if game_clk = '1' then 
        case state is
               when IDLE =>                                                                                         
                   if btn_start_pressed = '1' then                                                                  
                       bird_y <= 240;                                                                               
                       pipe_x <= 400;                                                                               
                       gap_y <= 150;                                                                                
                       score <= 0;                                                                                  
                       state <= PLAYING;  
                       is_game <= '1';       
                       bird_speed <= BIRD_SPEED_START_FALLING;                                                                      
                   end if;                                                                                          
                                                                                                                    
               when PLAYING =>                                                                                      
                   if btn_up_pressed = '1' then                                                                     
                       if bird_y > BIRD_JUMP then                                                                   
                           bird_y <= bird_y - BIRD_JUMP; 
                           
                           bird_speed <= BIRD_SPEED_START_FALLING;                                                           
                       else                                                                                         
                           bird_y <= 0;                                                                             
                       end if;                                                                                      
                   else   
                       if bird_speed + BIRD_ACCELERATION_FALLING < MAX_FALLING_SPEED   then
                            bird_speed <= bird_speed + BIRD_ACCELERATION_FALLING; 
                       end if;               
                                                                                            
                       if bird_y + bird_speed + BIRD_SIZE < V_MAX_VISIBLE then                                    
                           bird_y <= bird_y + bird_speed;                                                         
                       else                                                                                         
                           bird_y <= V_MAX_VISIBLE - BIRD_SIZE;                                                     
                       end if;                                                                                      
                   end if;                                                                                          

                   if pipe_x + PIPE_WIDTH > 0  then                                                                 
                       pipe_x <= pipe_x - PIPE_SPEED;                                                               
                   else                                                                                             
                       pipe_x <= H_MAX_VISIBLE-140;                                                                     
                       gap_y <= to_integer(unsigned(random_num(5 downto 0)));                                       
                       score <= score + 1;                                                                          
                   end if;                                                                                          
                                                                                                                    
                   if (pipe_x < BIRD_X + BIRD_SIZE and                                                              
                       pipe_x + PIPE_WIDTH > BIRD_X and                                                             
                       (bird_y < gap_y or bird_y + BIRD_SIZE > gap_y + GAP_HEIGHT)) or                         
                       bird_y <= 0 or bird_y + BIRD_SIZE >= V_MAX_VISIBLE -GROUND_HEIGHT-GRASS_HEIGHT   then                                      
                       state <= GAME_OVER;                                                                          
                   end if;                                                                                          
                                                                                                                    
               when GAME_OVER =>    
                   is_game <= '0';                                                                                
                   if btn_start_pressed = '1' then                                                                  
                       state <= IDLE;                                                                               
                   end if;                                                                                          
           end case;                                                                                                
        end if;
    end if;
end process;
 

 -- get game_clk  for any component of game
 process(clk_100)  
begin
    if rising_edge(clk_100) then
        if slow_counter < 4*2500000 then  
            slow_counter <= slow_counter + 1;
            game_clk <= '0';
        else
            slow_counter <= 0;
            game_clk <= '1'; 
        end if;
    end if;
end process;
 
-- stabilished buttons
-- button up bird
process(clk_100)
begin
    if rising_edge(clk_100) then
        btn_up_reg <= btn_up_reg(1 downto 0) & BTTN_UP;
        if btn_up_reg = "111" then
            btn_up_pressed <= '1';
        else
            btn_up_pressed <= '0';
        end if;
    end if;
end process;

-- button restart
process(clk_100)
    begin
        if rising_edge(clk_100) then
            btn_start_reg <= btn_start_reg(1 downto 0) & BTTN_START;
            if btn_start_reg = "111" then
                btn_start_pressed <= '1';
            else
                btn_start_pressed <= '0';
            end if;
        end if;
    end process;
    

-- get random integer for gap_y
LFSR_gen: LFSR8 
generic map (
    left_board => 80,    
    right_board => 190    
)
port map (
    clk => game_clk,      
    reset => reset,
    enable => '1',        
    output => random_num
);



-- get VGA signals
VGA_UU: entity work.VGA port map(
clk_100  => clk_100, 
reset    => reset, 
              
vga_red  => vga_red, 
vga_green => vga_green,
vga_blue => vga_blue,
              
vga_hsync => vga_hsync,
vga_vsync => vga_vsync,
-- constant draw
BIRD_SIZE  => BIRD_SIZE,
PIPE_SPEED => PIPE_SPEED,
GAP_HEIGHT => GAP_HEIGHT,
PIPE_WIDTH => PIPE_WIDTH,
             
GROUND_HEIGHT => GROUND_HEIGHT,
GRASS_HEIGHT  => GRASS_HEIGHT,
-- drawing data
 bird_y => bird_y,
 pipe_x => pipe_x,
 gap_y  => gap_y,
 is_game => is_game,
--- testing port
dbg_h_counter => open,
dbg_v_counter => open,
pixel_clk_out => open
);
end;
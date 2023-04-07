library ieee;  
use ieee.std_logic_1164.all;  

entity shift_register is 
  port (  
    clk    : in std_logic; 
    reset  : in std_logic;
    enable_count: in std_logic;
	  enable_sm : in std_logic;
    data_in: in std_logic; 
    q: out std_logic_vector (7 downto 0)
  );  
end shift_register;

architecture shift_register_Arch of shift_register is  
  signal s_data: std_logic_vector (7 downto 0);
  signal o_load: std_logic;
  
 -- component clock_counter is
  --  port (
   --   clk   : in  std_logic;
    --  reset : in  std_logic;
   --   clk_out:out std_logic;
   --   enable: out std_logic
   -- );
  --end component;
 
  begin
  --clock_signal: clock_counter port map(clk, reset, s_clk, s_load);
  
  variaton: process(o_load, reset)  
    begin  
      if (reset = '0') then  
        s_data <= (others=>'0');  
      elsif rising_edge(o_load) then  
        s_data(0) <= data_in;  
        s_data(1) <= s_data(0);  
        s_data(2) <= s_data(1);  
        s_data(3) <= s_data(2);
        s_data(4) <= s_data(3);  
        s_data(5) <= s_data(4);  
        s_data(6) <= s_data(5);  
        s_data(7) <= s_data(6);       
      end if;
  end process;

  o_load <= enable_count and enable_sm; -- o reg só carrega bit se o contador 
	q <= s_data;                         -- e a máquina de estados permitirem
end architecture;
library ieee;  
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clock_counter is
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      -- clk_out: out std_logic;
      enable: out std_logic
      --counter: out std_logic_vector(3 downto 0)
    );
 end entity;
  
architecture behavioral of clock_counter is
--	component clock_div is
 --   port (
 --   clk_in : in  std_logic;
 --   clk_out: out std_logic
 --   );
--	end component;
	
  signal count: integer range 0 to 7 := 0;
	-- signal s_clk_out: std_logic;
  begin
	  -- clock_signal: clock_div port map(clk, s_clk_out);
    
    process (clk, reset)
    begin
      if reset = '0' then -- reset ativo em nível baixo
        count  <= 0;
        enable <= '0';
      elsif clk'event and clk = '1' then
        count <= count + 1;
        --counter <= std_logic_vector(to_unsigned(count, 4));
        if count = 7 then
          count <= 0;
        end if;
      end if;
      
      if count = 3 then
          enable <= '1';
        else
          enable <= '0';
        end if;

    end process;
    -- clk_out <= s_clk_out;
end architecture;
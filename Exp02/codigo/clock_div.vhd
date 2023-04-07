library ieee;  
use ieee.std_logic_1164.all;

entity clock_div is
  port (
    clk_in : in std_logic;
    reset  : in std_logic;
    data_in: in std_logic;
    clk_out: out std_logic
  );
end entity;
  
architecture clock_div_Arch of clock_div is
  signal counter : natural range 1 to 50_000_000 := 1;
  signal s_clk_out : std_logic := '1';
  begin
    process (clk_in)
      begin
        if reset = '0' then
          counter <= 1;
        elsif clk_in'event and clk_in = '1' then
          counter <= counter + 1;	 		  
          if counter = 12_500_000 then
            counter <= 1;
            s_clk_out <= not s_clk_out;
          end if;
        end if;
    end process;
	 clk_out <= s_clk_out;
end architecture;


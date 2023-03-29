library ieee;  
use ieee.std_logic_1164.all; 

entity clock_div_32 is
    port (
      clk_in : in  std_logic;
      clk_out: out std_logic
    );
  end entity;
  
architecture clock_div_32_Arch of clock_div_32 is
  signal counter : integer range 0 to 31 := 0;
  signal s_clk_out : std_logic := '1';
  begin
    process (clk_in)
      begin
        if rising_edge(clk_in) then
          counter <= counter + 1;
          if counter = 31 then
            counter <= 0;
            clk_out <= not s_clk_out;
          end if;
        end if;
    end process;
end architecture;
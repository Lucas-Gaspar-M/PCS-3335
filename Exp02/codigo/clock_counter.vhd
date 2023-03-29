entity clock_counter is
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      enable: out std_logic
    );
  end entity;
  
  architecture behavioral of clock_counter is
    signal count: integer range 0 to 15 := 0;
  begin
    process (clk, reset)
    begin
      if reset = '1' then
        count  <= 0;
        enable <= '0';
      elsif rising_edge(clk) then
        count <= count + 1;
        if count = 7 then
          enable <= '1';
        else
          enable <= '0';
        end if;
      
        if count = 15 then
          count <= 0;
        end if;
      end if;
    end process;
  end architecture;
  
  
  
  
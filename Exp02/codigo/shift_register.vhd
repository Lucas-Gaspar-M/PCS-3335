library ieee;  
use ieee.std_logic_1164.all;  

entity shift_register is 
  port (  
    clk      : in std_logic;
    load     : in std_logic;  
    rst      : in std_logic;  
    data_in  : in std_logic;  
    data_out : out std_logic;
    q: out std_logic_vector (11 downto 0)
  );  
end shift_register;

architecture shift_register_Arch of shift_register is  
  signal data : std_logic_vector (11 downto 0);  
  begin  
  q <= data;  
  variaton: process(clk, rst)  
    begin  
    if (rst = '1') then  
        data <= (others=>'1');  
    elsif rising_edge(clk) and load = '1' then  
        data(0) <= data_in;  
        data(1) <= data(0);  
        data(2) <= data(1);  
        data(3) <= data(2);
        data(4) <= data(3);  
        data(5) <= data(4);  
        data(6) <= data(5);  
        data(7) <= data(6);
        data(7) <= data(7);  
        data(9) <= data(8);  
        data(10) <= data(9);  
        data(11) <= data(10);  
    end if;
  end process;
end architecture;
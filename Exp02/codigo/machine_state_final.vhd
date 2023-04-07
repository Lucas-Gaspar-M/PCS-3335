---------------------------------------------------
---------------------------------------------------
--
--
--              ESTÁ FEITO ATÉ A PARTE DE
--            EXIBIR UM CARACTERE NO DISPLAY
--
---------------------------------------------------
---------------------------------------------------
library ieee;  
use ieee.std_logic_1164.all;

entity machine_state_final is
    port (
      clk       : in std_logic;  -- 50 MHz
      reset     : in std_logic;
      data_in   : in std_logic;
      clk_out: out std_logic;
		deu : out std_logic;
		digito_1: out std_logic_vector (6 downto 0);
      data_out: out std_logic_vector(23 downto 0);
      state : out std_logic_vector(3 downto 0)
    );
  end entity;
  
architecture sm_arch of machine_state_final is
  component clock_div is
    port (
        clk_in : in  std_logic;
        reset  : in  std_logic;
        data_in: in std_Logic;
        clk_out: out std_logic
     );
  end component;
  
  component clock_counter is
    port (
      clk   : in  std_logic;
      reset : in  std_logic;
      -- clk_out: out std_logic;
      enable: out std_logic
      --counter: out std_logic_vector(3 downto 0)
    );
  end component;

  component shift_register is
    port (  
        clk    : in std_logic; 
        reset  : in std_logic;
        enable_count: in std_logic;
        enable_sm : in std_logic;
        data_in: in std_logic;
        q: out std_logic_vector (7 downto 0)
    );
  end component;

  component display is
  port (
    input : in  std_logic_vector(7 downto 0); -- ASCII 8 bits
    output: out std_logic_vector(7 downto 0)  -- ponto + gfedcba
  );
  end component;
  
  -- Máquina de Estados:
  -- - Idle: busca encontrar o intervalo de repouso da transmissão
  -- - Caractere: recebe um byte
  -- - OneStopBit: identifica primeiro bit de stop
  -- - Amostragem: identifica caracteres e os amostra nos displays 7 seg

  type estado is (idle, capturabits, stopbit, amostragem); 
  signal at_estado, pr_estado: estado;

  signal s_clk: std_logic;
  signal s_data_register: std_logic_vector(7 downto 0);
  signal s_enable_sm: std_logic;
  signal s_enable_count: std_logic;

  --signal s_caracteres: natural range 0 to 2 := 0;
  signal counter_byte: natural range 0 to 7 := 0;
  signal displaypos: natural range 0 to 3 := 1;

  signal s_data_display_bin: std_logic_vector (23 downto 0):= (others=>'1');
  signal s_digito: std_logic_vector(7 downto 0) := (others=>'0');

  begin
    clk_div: clock_div port map(clk, reset, data_in, s_clk);
    clk_counter: clock_counter port map (s_clk, reset, s_enable_count);
	 shift_r: shift_register port map(s_clk, reset, s_enable_count, s_enable_sm, data_in, s_data_register);
    
	 disp: display port map(s_data_display_bin(7 downto 0),  s_digito); 
	 
    transition_state: process (s_clk, reset) 
        begin 

            if rising_edge(s_clk) then 
                at_estado <= pr_estado; 
            end if; 
    end process;
    
    logic_state: process (s_enable_count)
        begin
		    if reset = '0' then 
                pr_estado <= idle;
          elsif rising_edge(s_enable_count) then
            case at_estado is
                when idle =>
                    state <= "1110";

                    s_enable_sm <= '1';
                    --enable_display <= '0';
                    if s_data_register(3 downto 0) = "1111" and data_in = '0' then
                        pr_estado <= capturabits;
                    else
                        pr_estado <= idle;
                    end if;

                when capturabits =>
                    state <= "1101";
                    if counter_byte < 7 then
                        counter_byte <= counter_byte + 1;
                        pr_estado <= capturabits;
                    else
                        counter_byte <= 0;
                        if not (s_data_register = "00000010" or s_data_register = "00000011"
                                        or s_data_register = "00000010") then
                            if (displaypos = 1) then
                                s_data_display_bin(7 downto 0) <= s_data_register;
                            elsif (displaypos = 2) then
                                s_data_display_bin(15 downto 8) <= s_data_register;
                            elsif (displaypos = 3) then
                                s_data_display_bin(23 downto 16) <= s_data_register;
                                displaypos <= 0;
                            end if;
                            --displaypos <= displaypos + 1;
                        end if;
                        pr_estado <= stopbit;
                    end if;
                
                when stopbit =>
                    state <= "1011";
                    if s_data_register(2 downto 0) = "011" or s_data_register(2 downto 0) = "111" then
                        pr_estado <= amostragem;
                    else
                        pr_estado <= stopbit;
                    end if;

                when amostragem =>
                    state <= "0111";
						  digito_1 <= s_data_display_bin(6 downto 0);
                    pr_estado <= idle;
                when others =>
                    pr_estado <= idle;
            end case;
          end if;
    end process;
	data_out(7 downto 0) <= s_data_register;
	clk_out <= s_enable_count and s_enable_sm;
  end architecture;
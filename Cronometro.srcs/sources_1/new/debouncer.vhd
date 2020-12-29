library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
    port (
       clk	   : in std_logic;
	   btn_in  : in std_logic;
	   btn_out : out std_logic);
end debouncer; 

architecture Behavioral of debouncer is
    constant CNT_SIZE : integer := 19;
    signal btn_prev   : std_logic := '0';
begin
    process(btn_in, clk)
    variable counter : integer range 0 to CNT_SIZE;
    
    begin
    if btn_in = '1' and counter < 5 then
        if clk'event and clk = '1' then
            counter := counter +1;
        end if;
    elsif btn_in = '1' and counter = 5 then
        btn_prev <= '1';
    else
    btn_prev <= '0';
    end if;	
    end process;
    
    btn_out <= btn_prev;
    
end Behavioral;
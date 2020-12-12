library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity boton_state is
    Port ( 
        clk : in std_logic;
        btn_in : in std_logic;
        rst : in std_logic;
        btn_sta : out std_logic
    );
end boton_state;

architecture Behavioral of boton_state is   
signal ant ,aux: std_logic;
begin

process (clk, rst, btn_in)
	begin
	 if rst = '0' then
	       aux <= '0';
	       ant <= '0';
	 
	 elsif clk'event and clk='1' then  
	   
	   if btn_in = '1' and ant = '0' then	       
	       aux <= not aux;	           
	       ant <= btn_in;
	   end if;
	   if btn_in = '0' and ant = '1' then
	       ant <= btn_in;
	   	   
	   end if;
	 end if;
 end process;

    btn_sta <= aux;

end Behavioral;
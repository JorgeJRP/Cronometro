library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity counter is
    generic (tope:integer:=10);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           enable : in  STD_LOGIC;
           up_down: in STD_LOGIC;
           load: in  STD_LOGIC_VECTOR (3 downto 0);
           count : out  STD_LOGIC_VECTOR (3 downto 0);
           count2 : out  STD_LOGIC_VECTOR (3 downto 0);
           salida : out  STD_LOGIC);
end counter;

architecture Behavioral of counter is
signal cnt: unsigned (3 downto 0);
begin

	process (clk, rst, enable, up_down)
	variable salida_aux: std_logic;
	variable ant: STD_LOGIC;
	begin
	  if (rst='0') then
	     cnt<=(others=>'0');
		 salida<='0';
		 ant:='0';
	  elsif clk'event and clk='1' then
	  
	  if up_down='1'and ant= '0'then
	   cnt <= unsigned(load);
	   ant:=not ant;
	  elsif up_down='0' and ant= '1' then
	   ant:=not ant;
	  end if; 
	  
			if enable ='1' and up_down='1' then
			  if cnt<tope then
					cnt<=cnt+1;
					salida<='0';
					if cnt=tope-1 then
						salida<='1';
					end if;
			   else
					cnt<="0000";
					salida<='0';
				end if;
			end if;
	  end if;
	end process;
   count <=std_logic_vector(cnt);
   count2 <= std_logic_vector(cnt);

end Behavioral;
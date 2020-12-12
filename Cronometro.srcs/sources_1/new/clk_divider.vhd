library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity clk_divider is
    Generic (frec: integer:=50000000);  -- default value is for 1hz
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           clk_out : out  STD_LOGIC);
end clk_divider;


architecture Behavioral of clk_divider is
signal clk_sig: std_logic;
begin

  process (clk,reset)
  variable cnt:integer;
  begin
		if (reset='0') then
		  cnt:=0;
		  clk_sig<='0';
		elsif clk'event and clk='1' then
			if (cnt=frec) then
				cnt:=0;
				clk_sig<=not(clk_sig);
			else
				cnt:=cnt+1;
			end if;
		end if;
  end process;
  clk_out<=clk_sig;
end Behavioral;

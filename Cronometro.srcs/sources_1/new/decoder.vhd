library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity decoder is
    Port ( code : in  STD_LOGIC_VECTOR (3 downto 0);
           led : out  STD_LOGIC_VECTOR (6 downto 0));
end decoder;

architecture Behavioral of decoder is

begin
	WITH code SELECT
		led <= "0000001" WHEN "0000",
				"1001111" WHEN "0001",
				"0010010" WHEN "0010",
				"0000110" WHEN "0011",
				"1001100" WHEN "0100",
				"0100100" WHEN "0101",
				"0100000" WHEN "0110",
				"0001111" WHEN "0111",  
				"0000000" WHEN "1000", 
				"0000100" WHEN "1001",  --hasta 9
				"1111110" WHEN others;

end Behavioral;


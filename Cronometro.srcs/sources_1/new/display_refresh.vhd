library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity display_refresh is
    Port ( clk : in  STD_LOGIC;
                segment_unid_seg : IN std_logic_vector(6 downto 0);
				segment_unid_min : IN std_logic_vector(6 downto 0);
				segment_dec_seg : IN std_logic_vector(6 downto 0);
				segment_dec_min : IN std_logic_vector(6 downto 0);
                display_number : out  STD_LOGIC_VECTOR (6 downto 0);
                display_selection : out  STD_LOGIC_VECTOR (3 downto 0));
end display_refresh;

architecture Behavioral of display_refresh is

begin

	muestra_displays:process (clk, segment_unid_seg, segment_unid_min, segment_dec_seg, segment_dec_min )
	variable cnt:integer range 0 to 3;
	begin
		if (clk'event and clk='1') then 
			if cnt=3 then
				cnt:=0;
			else
				cnt:=cnt+1;
			end if;
		end if;
		
		case cnt is
				when 0 => display_selection<="1110";
						    display_number<=segment_unid_seg;
				
				when 1 => display_selection<="1101";
						    display_number<=segment_dec_seg;
				
				when 2 => display_selection<="1011";
						    display_number<=segment_unid_min;
				
				when 3 => display_selection<="0111";
						    display_number<=segment_dec_min;				
			end case;

	end process;

end Behavioral;

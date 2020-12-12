library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexor is
    Port ( code_counter : in STD_LOGIC_VECTOR (3 downto 0);
           code_counter_n : in STD_LOGIC_VECTOR (3 downto 0);
           up_down: in STD_LOGIC;
           code : out STD_LOGIC_VECTOR (3 downto 0));
end multiplexor;

architecture Behavioral of multiplexor is

begin

process(up_down,code_counter,code_counter_n) is
begin
    if(up_down='1') then
    code <=code_counter;
    else
    code<= code_counter_n;
    
    end if;
   end process;

end Behavioral;

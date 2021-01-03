library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk               : in  STD_LOGIC;
           reset             : in  STD_LOGIC;
           startstop         : in  STD_LOGIC;
           up_down           : in STD_LOGIC;
           
           display_number    : out  STD_LOGIC_VECTOR (6 downto 0);
           display_selection : out  STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

-- SEÑALES ENTRE DIFERENTES COMPONENTES




-- COMPONENTES




begin
-- INSTANCIAS DE LOS COMPONENTES




end Behavioral;
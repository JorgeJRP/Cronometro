library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity debouncer is
    port ( clk     : in std_logic;
           btn_in  : in std_logic; 
           reset   : in std_logic;
           btn_out : out std_logic
          );
end debouncer;

architecture Behavioral of debouncer is
signal sreg : std_logic_vector(2 downto 0);
begin
    process (clk)
    begin
    
    if reset = '1' then
        sreg <= "000";
    
    elsif rising_edge(clk) then
            sreg <= sreg(1 downto 0) & btn_in;
        end if;
    end process;
    
    with sreg select
        btn_out <= '1' when "100",
        '0' when others;
end Behavioral;
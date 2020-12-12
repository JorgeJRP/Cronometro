library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity decoder_tb is
end;

architecture bench of decoder_tb is

  component decoder
      Port ( code : in  STD_LOGIC_VECTOR (3 downto 0);
             led : out  STD_LOGIC_VECTOR (6 downto 0));
  end component;

  signal code: STD_LOGIC_VECTOR (3 downto 0);
  signal led: STD_LOGIC_VECTOR (6 downto 0);

begin

  uut: decoder port map ( code => code,
                          led  => led );

  stimulus: process
  begin
  
    code <= "0000";
    wait for 10ns;
    code <= "0001";
    wait for 10ns;
    code <= "0010";
    wait for 10ns;
    code <= "0011";
    wait for 10ns;
    code <= "0100";
    wait for 10ns;
    code <= "0101";
    wait for 10ns;
    code <= "0110";
    wait for 10ns;
    code <= "0111";
    wait for 10ns;
    code <= "1000";
    wait for 10ns;
    code <= "1001";
    wait for 10ns;
    code <= "1100";
    wait for 10ns;
    code <= "1111";

    wait;
  end process;


end;
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity clk_divider_tb is
end;

architecture bench of clk_divider_tb is

  component clk_divider
      Generic (frec: integer:=50000000);
      Port ( clk : in  STD_LOGIC;
             reset : in  STD_LOGIC;
             clk_out : out  STD_LOGIC);
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal clk_out: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  
  uut: clk_divider generic map ( frec    => 5 )
                      port map ( clk     => clk,
                                 reset   => reset,
                                 clk_out => clk_out );

  stimulus: process
  begin
  
    reset <= '0';
    wait for 5ns;
    reset <= '1';
    wait for 795ns;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
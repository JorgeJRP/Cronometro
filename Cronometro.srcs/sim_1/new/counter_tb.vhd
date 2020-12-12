library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity counter_tb is
end;

architecture bench of counter_tb is

  component counter
      generic (tope:integer:=10);
      Port ( clk : in  STD_LOGIC;
             rst : in  STD_LOGIC;
             enable : in  STD_LOGIC;
             up_down: in STD_LOGIC;
             load: in STD_LOGIC_VECTOR (3 downto 0);
             count : out  STD_LOGIC_VECTOR (3 downto 0);
             salida : out  STD_LOGIC);
  end component;

  signal clk: STD_LOGIC;
  signal rst: STD_LOGIC;
  signal enable: STD_LOGIC;
  signal up_down: STD_LOGIC;
  signal load: STD_LOGIC_VECTOR (3 downto 0);
  signal count: STD_LOGIC_VECTOR (3 downto 0);
  signal salida: STD_LOGIC;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

 
  uut: counter generic map ( tope    => 9)
                port map ( clk     => clk,
                           rst     => rst,
                           enable  => enable,
                           up_down => up_down,
                           load => load,
                           count   => count,
                           salida  => salida );

  stimulus: process
  begin
  
  rst <= '0';
  wait for 10ns;
  rst <= '1';
  wait for 10ns;
  load <= "0011";
  wait for 10ns;
  up_down <= '1';
  wait for 10ns;
  up_down <= '0';
  wait for 10ns;
  load <= "0110";
  wait for 10ns;
  up_down <= '1';
  wait for 10ns;
  enable <= '1';
  wait for 80 ns;
  enable <= '0';
  wait for 10ns;
  enable <= '1';
  wait for 300 ns;
   
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
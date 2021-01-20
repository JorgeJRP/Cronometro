library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top
      Port ( 
           clk               : in   STD_LOGIC;
           startstop         : in   STD_LOGIC;
           up_down           : in   STD_LOGIC;
           display_number    : out  STD_LOGIC_VECTOR (6 downto 0);
           display_selection : out  STD_LOGIC_VECTOR (7 downto 0)
           );
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal startstop: STD_LOGIC;
  signal up_down: STD_LOGIC;
  signal display_number: STD_LOGIC_VECTOR (6 downto 0);
  signal display_selection: STD_LOGIC_VECTOR (7 downto 0) ;
  
  signal stop_the_clock: boolean;
  constant clock_period: time := 10 ns;

begin

  uut: top port map ( clk               => clk,
                      reset             => reset,
                      startstop         => startstop,
                      up_down           => up_down,
                      display_number    => display_number,
                      display_selection => display_selection );

  stimulus: process
  begin
  
    reset <= '0';
    startstop <= '0';
    up_down <= '0';
    wait for 15 ns;
    reset <= '1';
    wait for 15 ns;
    
    startstop <= '1';
    wait for 15 ns;
    startstop <= '0';
   
    wait for 10000 ns;
--    startstop <= '1';
--    wait for 15 ns;
--    startstop <= '0';
--    wait for 15 ns;
--    up_down <= '1';
--    wait for 15 ns;
--    up_down <= '0';
--    wait for 15 ns;
--    startstop <= '1';
--    wait for 15 ns;
--    startstop <= '0';
--    wait for 1000 ns;
    
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
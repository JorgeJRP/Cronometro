library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Counter_tb is
end;

architecture bench of Counter_tb is

  component Counter
      Generic (frec: integer:=10);
      port(  
          RESET_N     : in std_logic;
          CLK         : in std_logic;
          IN_P        : in std_logic;
          CAMBIO      : in std_logic;
          code        : out std_logic_vector(3 downto 0);
          digsel      : out std_logic_vector(7 downto 0)
          );
  end component;

  signal RESET_N: std_logic;
  signal CLK: std_logic;
  signal IN_P: std_logic;
  signal CAMBIO: std_logic;
  signal code: std_logic_vector(3 downto 0);
  signal digsel: std_logic_vector(7 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: Counter generic map ( frec    =>  10)
                  port map ( RESET_N => RESET_N,
                             CLK     => CLK,
                             IN_P    => IN_P,
                             CAMBIO  => CAMBIO,
                             code    => code,
                             digsel  => digsel );

  stimulus: process
  begin
  
    -- Put initialisation code here

    RESET_N <= '0';
    wait for 5 ns;
    RESET_N <= '1';
    wait for 5 ns;
    
    -- Put test bench stimulus code here
    CAMBIO <= '0';
    IN_P <= '1';
    wait for 5 ns;
    IN_P <= '0';
    wait for 10000 ns;

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      CLK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity debouncer_tb is
end;

architecture bench of debouncer_tb is

  component debouncer
      port ( clk     : in std_logic;
             btn_in  : in std_logic; 
             reset   : in std_logic;
             btn_out : out std_logic
            );
  end component;

  signal clk: std_logic;
  signal btn_in: std_logic;
  signal reset: std_logic;
  signal btn_out: std_logic ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: debouncer port map ( clk     => clk,
                            btn_in  => btn_in,
                            reset   => reset,
                            btn_out => btn_out );

  stimulus: process
  begin
  
    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    --señales para testeo
    btn_in <= '1';
    wait for 30 ns;
    btn_in <= '0';
    wait for 30 ns;

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
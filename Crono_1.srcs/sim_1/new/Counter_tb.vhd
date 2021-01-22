library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Counter_tb is
end;

architecture bench of Counter_tb is

  component Counter
      Generic (frec: integer:=50000000);
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
  
  constant CLK_PERIOD	 : time		:= 1 sec / 100_000_000;		--Periodo del Reloj 10 ns

begin

 uut: Counter generic map ( frec    =>  10)
                  port map ( RESET_N => RESET_N,
                             CLK     => CLK,
                             IN_P    => IN_P,
                             CAMBIO  => CAMBIO,
                             code    => code,
                             digsel  => digsel );

  clkgen: process
  begin
    	CLK	<= '0';
        wait for 0.5 * CLK_PERIOD;
        CLK	<= '1';
        wait for 0.5 * CLK_PERIOD;
  end process;
	
	  --Pulso de reset inicial
	RESET_N <= '0' after 0.25*CLK_PERIOD,
    		   '1' after 0.75*CLK_PERIOD;

  stimulus: process
  begin

    CAMBIO <= '0';          --INICIALIZAMOS
    IN_P <= '0';
    wait for 200 ns;    
    
    IN_P <= '1';            --CUENTA ARRIBA
    wait for CLK_PERIOD;
    IN_P <= '0';
    wait for 700 ns;

    IN_P <= '1';            --PARAMOS
    wait for CLK_PERIOD;
    IN_P <= '0';
    wait for 300 ns;
    
    IN_P <= '1';           --REANUDAMOS
    wait for CLK_PERIOD;
    IN_P <= '0';
    wait for 300 ns;
    
    IN_P <= '1';           --PARAMOS
    wait for CLK_PERIOD;
    IN_P <= '0';
    wait for CLK_PERIOD;
    
    CAMBIO <= '1';          --CAMBIAMOS Y MANTENEMOS PARADO
    wait for CLK_PERIOD;
    CAMBIO <= '0';
    wait for 200 ns;
    
    IN_P <= '1';           --REANUDAMOS
    wait for CLK_PERIOD;
    IN_P <= '0';
    wait for 300 ns;
    --HASTA AQUÍ CUENTA BIEN HACIA ARRIBA Y HACIA ABAJO.
   
   wait;            --!!!SI NO SE PONE ESTE WAIT NO CUENTA EL PROGRAMA
    
  end process;
  
end;
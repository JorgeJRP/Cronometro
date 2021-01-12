library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;       --Añadimos esta librería para poder utilizar la conversion to_unsigned

entity Decoder_tb is
end Decoder_tb;

architecture Behavioral of Decoder_tb is

    --Inputs
    signal RESET_N      : std_logic;
    signal code         : std_logic_vector(3 downto 0);
    signal digsel       : std_logic_vector(7 downto 0);
    
    
    --Outputs
    signal segments     :std_logic_vector(6 downto 0);
    signal digits       :std_logic_vector(7 downto 0);
    
    component Decoder is
    port(
        RESET_N     : in std_logic;                     --RESET Negado
        code        : in std_logic_vector(3 downto 0);      --Código de número en binario del número a imprimir
        digsel      : in std_logic_vector(7 downto 0);      --Código de dígitos a encender
        
        segments    : out std_logic_vector(6 downto 0);     --Código de salida a displays
        digits      : out std_logic_vector(7 downto 0)      --Dígitos encendidos
    );
    end component Decoder;

constant CLK_PERIOD	 : time		:= 1 sec / 100_000_000;		--Periodo del Reloj ficticio

begin
    utt: Decoder
        port map(
            RESET_N     => RESET_N,
            code        => code,
            digsel      => digsel,
            
            segments    => segments,
            digits      => digits
        );

    tester: process
    begin
        RESET_N <= '1';
    
        digsel <= "11111111";
        wait for CLK_PERIOD;
        
        digsel <= "00001111";
        wait for CLK_PERIOD;
        
        for i in 1 to 16 loop
            code <= std_logic_vector(to_unsigned(i, code'length));  --Primero convertimos a unsigned y luego a binario
            wait for CLK_PERIOD;
        end loop;
        
        RESET_N <= '0';
        for i in 1 to 16 loop
            code <= std_logic_vector(to_unsigned(i, code'length));  --Primero convertimos a unsigned y luego a binario
            wait for CLK_PERIOD;
        end loop;
        
    wait for CLK_PERIOD;                --Mensaje de éxito de la simulación
        assert false
        	report "Simulacion terminada exitosamente"
            severity failure;
    
    end process;

end Behavioral;


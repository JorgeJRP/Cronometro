library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Decoder is
    port(
        RESET_N     : in std_logic;                     --RESET Negado
        code        : in std_logic_vector(3 downto 0);      --Código de número en binario del número a imprimir
        digsel      : in std_logic_vector(7 downto 0);      --Código de dígitos a encender
        
        segments    : out std_logic_vector(6 downto 0);     --Código de salida a displays
        digits      : out std_logic_vector(7 downto 0)      --Dígitos encendidos
    );
end entity Decoder;


architecture Dataflow of Decoder is

signal segmentos    : std_logic_vector(6 downto 0); --Variables auxiliares para el tratamiento de la información
signal digitos      : std_logic_vector(7 downto 0);

begin
    with code select
        segmentos <= "0000001" when "0000",  --0
                    "1001111" when "0001",  --1
                    "0010010" when "0010",  --2
                    "0000110" when "0011",  --3
                    "1001100" when "0100",  --4
                    "0100100" when "0101",  --5
                    "0100000" when "0110",  --6
                    "0001111" when "0111",  --7
                    "0000000" when "1000",  --8
                    "0000100" when "1001",  --9
                    "1000001" when "1010",  --U
                    "0011000" when "1011",  --P
                    "1000010" when "1100",  --d
                    "1100010" when "1101",  --o
                    "1111110" when others;  --Guión
                    
    digitos <= digsel;       --Conectamos la entrada a la salida
  
    --Al final pasamos los datos de los registros "segmentos" y "digitos" a las variables de salida
    segments <= segmentos when RESET_N = '1' else
    			"1111111" when RESET_N = '0';
    digits <= digitos when RESET_N = '1' else
    			"11111111" when RESET_N = '0';
                
end architecture Dataflow;

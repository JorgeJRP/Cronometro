library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( 
         clk               : in  STD_LOGIC;
         reset             : in  STD_LOGIC;
         startstop         : in  STD_LOGIC;
         up_down           : in  STD_LOGIC;
           
         display_number    : out  STD_LOGIC_VECTOR (6 downto 0);
         display_selection : out  STD_LOGIC_VECTOR (7 downto 0)
         );
end top;

architecture Behavioral of top is
-- SEÑALES ENTRE DIFERENTES COMPONENTES

    --SEÑALES SALIDA DEL DEBOUNCER  // ENTRADAS COUNTER
    signal STARTSTOP_DEB : std_logic;      --Boton startstop sin rebotes
    signal UPDOWN_DEB : std_logic;         --Boton up_down sin rebotes

    --SEÑALES SALIDA DEL COUNTER  //  ENTRADAS DECODER
    signal CODE : std_logic_vector(3 downto 0);
    signal DIGSEL : std_logic_vector(7 downto 0);
    
    
-- COMPONENTES

COMPONENT debouncer is
    port( 
         clk     : in std_logic;
         btn_in  : in std_logic; 
         reset   : in std_logic;
         btn_out : out std_logic
         );
end COMPONENT;

COMPONENT Counter
	Generic (frec: integer:=50000000);  -- VALOR PARA CONSEGUIR 1Hz 50000000
    port(  
        RESET_N     : in std_logic;
        CLK         : in std_logic;
        IN_P        : in std_logic;
        CAMBIO      : in std_logic;
        
        code        : out std_logic_vector(3 downto 0);
        digsel      : out std_logic_vector(7 downto 0)
        );
END COMPONENT;

COMPONENT Decoder is
    port(
        RESET_N     : in std_logic;                         --RESET Negado
        code        : in std_logic_vector(3 downto 0);      --Código de número en binario del número a imprimir
        digsel      : in std_logic_vector(7 downto 0);      --Código de dígitos a encender
        
        segments    : out std_logic_vector(6 downto 0);     --Código de salida a displays
        digits      : out std_logic_vector(7 downto 0)      --Dígitos encendidos
        );
end COMPONENT;


begin
-- INSTANCIAS DE LOS COMPONENTES

Inst_debouncer_STARTSTOP: debouncer        --Antirebotes para inicio-pausa
    port map(
            clk     =>  clk,
            btn_in  =>  startstop,           
            reset   =>  reset,
            
            btn_out =>  STARTSTOP_DEB
            );
            
Inst_debouncer_UPDOWN: debouncer            --Antirebotes para cambio
    port map(
            clk     =>  clk,
            btn_in  =>  up_down,           
            reset   =>  reset,
            
            btn_out =>  UPDOWN_DEB
            );
            
Inst_COUNTER : Counter
    generic map (frec => 50000000)
    port map(  
            RESET_N =>  reset,    
            CLK     =>  clk,              
            IN_P    =>  STARTSTOP_DEB,    
            CAMBIO  =>  UPDOWN_DEB,   
        
            code    =>  CODE,    
            digsel  =>  DIGSEL    
            );      
            
Inst_DECODER : decoder
     port map(
             RESET_N   =>  reset,    
             code      =>  CODE,
             digsel    =>  DIGSEL,
        
             segments  =>  display_number,
             digits    =>  display_selection
             );                   

end Behavioral;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Counter is
    Generic (frec: integer:=50000000);  -- VALOR PARA CONSEGUIR 1Hz
    port(  
        RESET_N     : in std_logic;
        CLK         : in std_logic;
        IN_P        : in std_logic;
        CAMBIO      : in std_logic;
        
        code        : out std_logic_vector(3 downto 0);
        digsel      : out std_logic_vector(7 downto 0)
        );
end entity Counter;
    
architecture Behavioral of Counter is

type state_t is (S0_INITIAL, S1_UPWARD, S2_STOPUP, S3_STOPDOWN, S4_DOWNWARD);
    --Creamos el tipo estado, que puede tomar 5 valores distintos
signal state, next_state	:	state_t;
    --Creamos dos señales de tipo estado para utilizarlas como registros

signal stop : std_logic;            --Variable flag para parar de contar
signal cuenta_min_dec, cuenta_min_un, cuenta_seg_dec, cuenta_seg_un   : unsigned (3 downto 0);

signal segundos : std_logic;      -- Señal que cambia de valor cada segundo

begin

    --Proceso de actualización del estado actual con el futuro
    state_register: process(CLK, RESET_N)
   	begin
    	if RESET_N = '0' then
        	state <= S0_INITIAL;
        elsif rising_edge(CLK) then
        	state <= next_state;
        	stop <= '0';           --Cuando se actualiza el estado se quita la prohibición de conteo
        end if;
    end process;
    
    --Proceso de cambio del siguiente estado
    next_state_decod: process (state, IN_P, CAMBIO)
    begin			            --En el decodificador de estados deben de estar todas las variables en la lista de sens
    	next_state <= state;
    	case state is
        	when S0_INITIAL =>
            	if IN_P = '1' then
                	next_state <= S1_UPWARD;
                end if;
            when S1_UPWARD =>
            	if IN_P = '1' then             --Transición por botón
                	next_state <= S2_STOPUP;
                end if;
                
                if cuenta_min_dec = 5 then
                   if cuenta_min_un = 9 then
                      if cuenta_seg_dec = 5 then
                         if cuenta_seg_un = 9 then          --Si llegamos al 59:59 se para
                            next_state <= S2_STOPUP;        
                            stop <= '1';                    --Activamos una prohibiíon de conteo para evitar sobrepasarnos
                         end if;
                      end if;
                   end if;
                end if;
                
            when S2_STOPUP =>
            	if IN_P = '1' then
                	next_state <= S1_UPWARD;           --Prioridad de inicio de cuenta hacia arriba frente a cambio
                	elsif CAMBIO = '1' then
                	      next_state <= S3_STOPDOWN; 
                end if;
            when S3_STOPDOWN =>
            	if IN_P = '1' then
                	next_state <= S4_DOWNWARD;         --Prioridad de inicio de cuenta hacia abajo frente a cambio
                	elsif CAMBIO = '1' then
                	       next_state <= S2_STOPUP;
                end if;
            when S4_DOWNWARD =>
            	if IN_P = '1' then
                	next_state <= S3_STOPDOWN;
                end if;
                
                if cuenta_min_dec = 0 then
                   if cuenta_min_un = 0 then
                      if cuenta_seg_dec = 0 then
                         if cuenta_seg_un = 0 then          --Si llegamos al 00:00 se para
                            next_state <= S3_STOPDOWN;
                            stop <= '1';                    --Activamos una prohibiíon de conteo para evitar sobrepasarnos
                         end if;
                      end if;
                   end if;
                end if;
                
           	when others	=>	--Llegar a este caso implica que ha habido interferencia con la señal
            	next_state <= S0_INITIAL;	--Por lo que lo más seguro es reiniciar el sistema
        end case;
    end process;
    
    --Proceso para obtener señal en segundos
    preescalado_reloj: process (CLK, RESET_N, IN_P)

    variable cnt:integer;
    begin
         -- AJUSTE DEL RELOJ
        if (RESET_N='0') then
		  cnt:=0;
		  segundos<='0';
		elsif (IN_P='1') then
		  cnt:=0;
		  segundos<='0';
		elsif rising_edge(CLK) then
			if (cnt=frec) then
				cnt:=0;
				segundos<=not(segundos);
			else
				cnt:=cnt+1;
			end if;
		end if;   
	end process;	
        
    
    memoria_contador: process (CLK)        
    begin
           
        case state is
            when S0_INITIAL =>                      --Reset de cuenta
                cuenta_min_dec <= (others => '0');
                cuenta_min_un  <= (others => '0');
                cuenta_seg_dec <= (others => '0');
                cuenta_seg_un  <= (others => '0');
            when S2_STOPUP =>                       --Se mantiene la cuenta
                cuenta_min_dec <= cuenta_min_dec;
                cuenta_min_un  <= cuenta_min_un;
                cuenta_seg_dec <= cuenta_seg_dec;
                cuenta_seg_un  <= cuenta_seg_un;
            when S3_STOPDOWN =>                     --Se mantiene la cuenta
                cuenta_min_dec <= cuenta_min_dec;
                cuenta_min_un  <= cuenta_min_un;
                cuenta_seg_dec <= cuenta_seg_dec;
                cuenta_seg_un  <= cuenta_seg_un;    
             when S1_UPWARD =>
             if rising_edge(segundos) then                       --PUEDE DAR PROBLEMAS!!!!!
                if stop = '0' then
                    if(cuenta_seg_un = 9) then
                        cuenta_seg_un <= (others => '0');
                        
                        if(cuenta_seg_dec = 5) then
                            cuenta_seg_dec <= cuenta_seg_dec - 5;
                            
                            if(cuenta_min_un = 9) then
                               cuenta_min_un <= (others => '0');
                               
                               if(cuenta_min_dec < 5) then
                                  cuenta_min_dec <= cuenta_min_dec + 1;
                               end if;
                               
                            else
                            cuenta_min_un <= cuenta_min_un + 1;
                            end if;
                            
                        else
                        cuenta_seg_dec <= cuenta_seg_dec + 1;
                        end if;
                        
                    else
                        cuenta_seg_un <= cuenta_seg_un + 1;
                    end if;
                end if;
             end if;
             when S4_DOWNWARD =>                
             if rising_edge(segundos) then                   --PUEDE DAR PROBLEMAS!!!!!
                if stop = '0' then
                    if(cuenta_seg_un = 0) then
                        cuenta_seg_un <= "1001";
                        
                        if(cuenta_seg_dec = 0) then
                            cuenta_seg_dec <= "0101";
                            
                            if(cuenta_min_un = 0) then
                                if(cuenta_min_dec = 0) then
                                
                                else
                                    cuenta_min_un <= "1001";
                                    cuenta_min_dec <= cuenta_min_dec - 1;
                                end if;
                               
                            else
                            cuenta_min_un <= cuenta_min_un - 1;
                            end if;
                            
                        else
                        cuenta_seg_dec <= cuenta_seg_dec - 1;
                        end if;
                        
                    else
                        cuenta_seg_un <= cuenta_seg_un + 1;
                    end if;
              end if;
        end if;
        end case;        
    end process;           
    
    emisor: process (CLK)
    variable n  : integer range 0 to 7;
    begin
        if rising_edge (CLK) then    --Código para la alternancia de dígitos
			if n=7 then             
				n:=0;
			else
				n:=n+1;
			end if;
		end if;
		
		case n is
				when 0 =>   --U
				    if state = S1_UPWARD or state = S2_STOPUP then      --Cuidado OR
				        code <= "1010";
				        digsel <= "10000000";
				    else
				        digsel <= "00000000";
				    end if;
				when 1 =>   --P
				    if state = S1_UPWARD or state = S2_STOPUP then      --Cuidado OR
				        code <= "1011";
				        digsel <= "01000000";
				    else
				        digsel <= "00000000";
				    end if;
				when 2 =>   --d
				    if state = S4_DOWNWARD or state = S3_STOPDOWN then      --Cuidado OR
				        code <= "1100";
				        digsel <= "00100000";
				    else
				        digsel <= "00000000";
				    end if;
				when 3 =>   --o
				    if state = S4_DOWNWARD or state = S3_STOPDOWN then      --Cuidado OR
				        code <= "1101";
				        digsel <= "00010000";
				    else
				        digsel <= "00000000";
				    end if;
			    when 4 =>   --Decenas minutos
				    code <= std_logic_vector(cuenta_min_dec);       --Cuidado error de longitud
				    digsel <= "00001000";                           --(que convierta a 4 bits)
				when 5 =>   --Unidades minutos
				    code <= std_logic_vector(cuenta_min_un);       --Cuidado error de longitud
				    digsel <= "00000100";
				when 6 =>   --Decenas segundos
				    code <= std_logic_vector(cuenta_seg_dec);       --Cuidado error de longitud
				    digsel <= "00000010";
		        when 7 =>   --Unidades segundos
				    code <= std_logic_vector(cuenta_seg_un);       --Cuidado error de longitud
				    digsel <= "00000001";				    
		end case;    
    end process;

end Behavioral;
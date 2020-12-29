library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
    Port ( clk : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           startstop : in  STD_LOGIC;
           up_down: in STD_LOGIC;
           display_number : out  STD_LOGIC_VECTOR (6 downto 0);
           display_selection : out  STD_LOGIC_VECTOR (3 downto 0));
end top;

architecture Behavioral of top is

    --SEÑAL ESTADO BOTON
    signal boton_st_ss : std_logic;
    
    --SEÑALES CLK_DIVIDER A COUNTER Y DISPLAY
	signal clk_counter:std_logic;
	signal clk_display:std_logic;
	
	--SEÑALES COUNTER A MULTIPLEXOR
    signal cuenta_unid_seg:std_logic_vector(3 downto 0);
	signal cuenta_dec_seg:std_logic_vector(3 downto 0);
	signal cuenta_unid_min:std_logic_vector(3 downto 0);
	signal cuenta_dec_min:std_logic_vector(3 downto 0);
	
	--SEÑALES COUNTER A COUNTER_N
    signal cuenta_unid_seg2:std_logic_vector(3 downto 0);
	signal cuenta_dec_seg2:std_logic_vector(3 downto 0);
	signal cuenta_unid_min2:std_logic_vector(3 downto 0);
	signal cuenta_dec_min2:std_logic_vector(3 downto 0);
	
	--SEÑALES COUNTER_N A MULTIPLEXOR
	signal cuenta_n_unid_seg:std_logic_vector(3 downto 0);
	signal cuenta_n_dec_seg:std_logic_vector(3 downto 0);
	signal cuenta_n_unid_min:std_logic_vector(3 downto 0);
	signal cuenta_n_dec_min:std_logic_vector(3 downto 0);
	
	--SEÑALES COUNTER_N A COUNTER
	signal cuenta_n_unid_seg2:std_logic_vector(3 downto 0);
	signal cuenta_n_dec_seg2:std_logic_vector(3 downto 0);
	signal cuenta_n_unid_min2:std_logic_vector(3 downto 0);
	signal cuenta_n_dec_min2:std_logic_vector(3 downto 0);
	
	
	--SEÑALES MULTIPLEXOR A DECODER
	signal cnt_unid_seg:std_logic_vector(3 downto 0);
	signal cnt_dec_seg:std_logic_vector(3 downto 0);
	signal cnt_unid_min:std_logic_vector(3 downto 0);
	signal cnt_dec_min:std_logic_vector(3 downto 0);
	
	--SEÑALES SALIDA CONTADOR
	signal salida_unid_seg:std_logic;
	signal salida_dec_seg:std_logic;
	signal salida_unid_min:std_logic;
	signal salida_dec_min:std_logic;
	
	--SEÑALES SALIDA CONTADOR_N
    signal salida_n_unid_seg:std_logic;
	signal salida_n_dec_seg:std_logic;
	signal salida_n_unid_min:std_logic;
	signal salida_n_dec_min:std_logic;
	
	--SEÑALES DECODER A DISPLAY
	signal segment_unid_seg:std_logic_vector(6 downto 0);
	signal segment_dec_seg:std_logic_vector(6 downto 0);
	signal segment_unid_min:std_logic_vector(6 downto 0);
	signal segment_dec_min:std_logic_vector(6 downto 0);


--COMPONENTES
	COMPONENT clk_divider
	GENERIC (frec: integer:=50000000);
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		clk_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT boton_state
	PORT (
	    clk : in std_logic;
	    btn_in : in std_logic;
        rst : in std_logic;
        btn_sta : out std_logic
	);
	END COMPONENT;
	
	COMPONENT counter
	GENERIC (tope:integer:=10); -- por defecto cuenta hasta 9
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enable : IN std_logic;
		up_down: IN STD_LOGIC; 
		load: IN  STD_LOGIC_VECTOR (3 downto 0);
		count : OUT std_logic_vector(3 downto 0);
		count2 : OUT std_logic_vector(3 downto 0);
		salida : OUT std_logic
		);
	END COMPONENT;
	
    COMPONENT counter_n
	GENERIC (min:integer:=0;
	         max:integer:=9); -- por defecto empieza en 9
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		enable : IN std_logic;
		up_down: IN STD_LOGIC;  
		load: IN  STD_LOGIC_VECTOR (3 downto 0);        
		count : OUT std_logic_vector(3 downto 0);
		count2 : OUT std_logic_vector(3 downto 0);
		salida : OUT std_logic
		);
	END COMPONENT;

	COMPONENT decoder
	PORT(
		code : IN std_logic_vector(3 downto 0);          
		led : OUT std_logic_vector(6 downto 0)
		);
	END COMPONENT;


   COMPONENT display_refresh
	PORT(
		clk : IN std_logic;
		segment_unid_seg : IN std_logic_vector(6 downto 0);
		segment_unid_min : IN std_logic_vector(6 downto 0);
		segment_dec_seg : IN std_logic_vector(6 downto 0);
		segment_dec_min : IN std_logic_vector(6 downto 0);         
		display_number : OUT std_logic_vector(6 downto 0);
		display_selection : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT multiplexor
	 Port ( code_counter : in STD_LOGIC_VECTOR (3 downto 0);
           code_counter_n : in STD_LOGIC_VECTOR (3 downto 0);
           up_down: in STD_LOGIC;
           code : out STD_LOGIC_VECTOR (3 downto 0)
           );        
     END COMPONENT;

   signal aux1,aux2,aux3,aux4,aux5,aux6: std_logic;

begin
-- INSTANCIAS DE TODOS LOS COMPONENTES
	Inst_clk_divider_counter: clk_divider generic map (frec=>50000000) PORT MAP(
		clk => clk,
		reset => reset,
		clk_out => clk_counter
	);
	
	Inst_clk_divider_display: clk_divider generic map (frec=>100000) PORT MAP(
		clk => clk,
		reset => reset,
		clk_out => clk_display
	);
	
	Inst_boton_state_SS: boton_state PORT MAP (
        clk => clk,
        btn_in => startstop,
        rst => reset,
        btn_sta => boton_st_ss
    );
	
	
   Inst_counter_unid_seg: counter generic map (tope=>9) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => boton_st_ss,
		up_down => up_down,
		load => cuenta_n_unid_seg2,
		count => cuenta_unid_seg,
		count2 => cuenta_unid_seg2,
		salida => salida_unid_seg
	);
	
	aux1<=salida_unid_seg and boton_st_ss;
	
	 Inst_counter_dec_seg: counter generic map (tope=>5) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => aux1,
		up_down => up_down,
		load => cuenta_n_dec_seg2,
		count => cuenta_dec_seg,
		count2 => cuenta_dec_seg2,
		salida => salida_dec_seg
	);
	
	aux2<=salida_dec_seg and salida_unid_seg and boton_st_ss;
	
	  Inst_counter_unid_min: counter generic map (tope=>9) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => aux2,
		up_down => up_down,
		load => cuenta_n_unid_min2,
		count => cuenta_unid_min,
		count2 => cuenta_unid_min2,
		salida => salida_unid_min
	);
	
	aux3<=salida_unid_min and salida_dec_seg and salida_unid_seg and boton_st_ss;
	
	 Inst_counter_dec_min: counter generic map (tope=>5) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => aux3,
		up_down => up_down,
		load => cuenta_n_dec_min2,
		count => cuenta_dec_min,
		count2 => cuenta_dec_min2,
		salida => salida_dec_min
	);
	
	--
	
	   Inst_counter_n_unid_seg: counter_n generic map (max=>9) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => boton_st_ss,
		up_down => up_down,
		load => cuenta_unid_seg2,
		count => cuenta_n_unid_seg,
		salida => salida_n_unid_seg
	);
	
	aux4<=salida_n_unid_seg and boton_st_ss;
	
	 Inst_counter_n_dec_seg: counter_n generic map (max=>5) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => aux4,
		up_down => up_down,
		load => cuenta_dec_seg2,
		count => cuenta_n_dec_seg,
		salida => salida_n_dec_seg
	);
	
	aux5<=salida_n_dec_seg and salida_n_unid_seg and boton_st_ss;
	
	  Inst_counter_n_unid_min: counter_n generic map (max=>9) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => aux5,
		up_down => up_down,
		load => cuenta_unid_min2,
		count => cuenta_n_unid_min,
		salida => salida_n_unid_min
	);
	
	aux6<=salida_n_unid_min and salida_n_dec_seg and salida_n_unid_seg and boton_st_ss;
	
	 Inst_counter_n_dec_min: counter_n generic map (max=>5) PORT MAP(
		clk => clk_counter,
		rst => reset,
		enable => aux6,
		up_down => up_down,
		load => cuenta_dec_min2,
		count => cuenta_n_dec_min,
		salida => salida_n_dec_min
	);
		
	Inst_multiplexor_unid_seg: multiplexor PORT MAP(
	code_counter=>cuenta_unid_seg,
	code_counter_n=>cuenta_n_unid_seg,
	up_down=>up_down,
	code=> cnt_unid_seg
	);

    Inst_multiplexor_dec_seg: multiplexor PORT MAP(
	code_counter=>cuenta_dec_seg,
	code_counter_n=>cuenta_n_dec_seg,
	up_down=>up_down,
	code=> cnt_dec_seg
	);
	
	Inst_multiplexor_unid_min: multiplexor PORT MAP(
	code_counter=>cuenta_unid_min,
	code_counter_n=>cuenta_n_unid_min,
	up_down=>up_down,
	code=> cnt_unid_min
	);

    Inst_multiplexor_dec_min: multiplexor PORT MAP(
	code_counter=>cuenta_dec_min,
	code_counter_n=>cuenta_n_dec_min,
	up_down=>up_down,
	code=> cnt_dec_min
	);
	
	Inst_decoder_unid_seg: decoder PORT MAP(
		code => cnt_unid_seg,
		led => segment_unid_seg
	);
	
	Inst_decoder_dec_seg: decoder PORT MAP(
		code => cnt_dec_seg,
		led => segment_dec_seg
	);
	
	Inst_decoder_unid_min: decoder PORT MAP(
		code => cnt_unid_min,
		led => segment_unid_min
	);
	
	Inst_decoder_dec_min: decoder PORT MAP(
		code => cnt_dec_min,
		led => segment_dec_min
	);
	
	Inst_display_refresh: display_refresh PORT MAP(
		clk => clk_display,
		segment_unid_seg => segment_unid_seg,
		segment_unid_min => segment_unid_min,
		segment_dec_seg => segment_dec_seg,
		segment_dec_min => segment_dec_min,
		display_number => display_number,
		display_selection => display_selection 
	);
end Behavioral;
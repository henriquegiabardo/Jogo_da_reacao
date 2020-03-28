----------------------------------------------------------------
-- Arquivo   : interface_leds_botoes.vhd
-- Projeto   : Jogo do Tempo de Reacao aplicado a E-SPorts
-- Data      : 21/03/2020
----------------------------------------------------------------
-- Descricao : Projeto de Lab Digi 1
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor                        Descricao
--     21/03/2020  1.0     Henrique Geribello 			   criacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


--colocar a entity
entity interface_leds_botoes is
port (  clock, reset: in std_logic;
        liga, a, b, c, d: in std_logic; 
        
        ligado, preparar, ledA, ledB, ledC, ledD, erro, fim, pontuou: out std_logic         
 );
end interface_leds_botoes; 

architecture completa of interface_leds_botoes is
-- copiar as entities dos componentes a serem instanciados


component controlador_interface_leds_botoes is
   port ( clock, reset:        in  STD_LOGIC;
          ligar, a, b, c, d, fim_espera_3_segundos, fim_espera_30_segundos: in  STD_LOGIC;
			 aleatorio: in std_logic_vector (1 downto 0);
          ligado, preparar, conta_30_segundos, somar_ponto, ledA, ledB, ledC, ledD, erro, fim: out STD_LOGIC
        );
end component;


component contador_modm is
    generic (
        constant M: integer := 50 -- valor default do modulo do contador
    );
   port (
        clock, zera, conta: in std_logic;
        Q: out std_logic_vector (natural(ceil(log2(real(M))))-1 downto 0);
        fim: out std_logic 
   );
end component;


component aleatorio is
port (  clock, reset: in std_logic;
        gerar_novo_aleatorio: in std_logic; 
        aleatorio: out std_logic_vector(1 downto 0)
        
 );
end component;

-- sinais intermediários para serem transmitidos do controlador para os componentes
signal signal_preparar, signal_fim_espera_3_segundos, signal_conta_30_segundos, signal_fim_espera_30_segundos, signal_somar_ponto: std_logic;
signal signal_novo_aleatorio: std_logic_vector(1 downto 0);
begin 

-- instanciar components

CONTADOR3_segundos: contador_modm generic map (M => 3000)
                            port map (clock => clock, 
                            zera => reset, 
                            conta => signal_preparar, 
                            Q => open, 
                            fim => signal_fim_espera_3_segundos
                            );

CONTADOR30_segundos: contador_modm generic map (M => 33000) -- 33 segundos pois ele inicia a contagem junto com o contador anterior
                            port map (clock => clock, 
                            zera => reset, 
                            conta => signal_conta_30_segundos, 
                            Q => open, 
                            fim => signal_fim_espera_30_segundos
                            );									 
									 
CONTROLADOR: controlador_interface_leds_botoes port map( clock => clock,
																			reset => reset,
																			ligar => liga,
																			a => a,
																			b => b,
																			c => c,
																			d => d,
																			fim_espera_3_segundos => signal_fim_espera_3_segundos,
																			fim_espera_30_segundos => signal_fim_espera_30_segundos,
																		   aleatorio => signal_novo_aleatorio,
																		   ligado => ligado,
																			preparar => preparar,
																			conta_30_segundos => signal_conta_30_segundos,
																			somar_ponto => signal_somar_ponto,
																			ledA => ledA,
																			ledB => ledB,
																			ledC => ledC,
																			ledD => ledD,
																			erro => erro,
																			fim => fim
																		);	
																
COMPONENTE_ALEATORIO: aleatorio port map(  clock => clock,
										  reset => reset,
										  gerar_novo_aleatorio => signal_somar_ponto, 
										  aleatorio => signal_novo_aleatorio
										);		  
																		
																		
 									 
pontuou <= signal_somar_ponto;
            
end architecture;
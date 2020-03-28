----------------------------------------------------------------
-- Arquivo   : controlador_interface_leds_botoes.vhd
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

entity controlador_interface_leds_botoes is
   port ( clock, reset:        in  STD_LOGIC;
          ligar, a, b, c, d, fim_espera_3_segundos, fim_espera_30_segundos: in  STD_LOGIC;
			 aleatorio: in std_logic_vector (1 downto 0);
          ligado, preparar, conta_30_segundos, somar_ponto, ledA, ledB, ledC, ledD, erro, fim: out STD_LOGIC
        );
end controlador_interface_leds_botoes;

architecture controlador_arch of controlador_interface_leds_botoes is
   type tipo_Estado is (E_Inicial, E_Ligado, E_Espera_3_segundos, E_Aleatorio, E_a, E_b, E_c, E_d, E_Erro, E_Fim);
   signal Ereg, Eprox: tipo_Estado;
begin

   -- mudanca de estado
   process (clock, reset)
   begin
      if reset = '1' then
         Ereg <= E_Inicial;
      elsif clock'event and clock = '1' then
         Ereg <= Eprox;
      end if;
   end process;

   -- logica de proximo estado
   process (ligar, a, b, c, d, fim_espera_3_segundos, fim_espera_30_segundos)
   begin
      case Ereg is
      
         when E_Inicial =>  if ligar = '0' then   Eprox <= E_Inicial;
                            else                  Eprox <= E_Ligado;
                            end if;
                          
         when E_Ligado =>  if    a = '0' then   Eprox <= E_Ligado;
                           elsif b = '0' then   Eprox <= E_Ligado;
                           elsif c = '0' then   Eprox <= E_Ligado;
                           elsif d = '0' then   Eprox <= E_Ligado;
									else Eprox <= E_Espera_3_segundos;
                           end if;
                          
         when E_Espera_3_segundos =>   if fim_espera_3_segundos = '0' then   Eprox <= E_Espera_3_segundos;
													else                 Eprox <= E_Aleatorio;
													end if;
                          
         when E_Aleatorio =>  if fim_espera_30_segundos = '1' then Eprox <= E_Fim;
										elsif aleatorio = "00" then   Eprox <= E_a;
										elsif aleatorio = "01" then   Eprox <= E_b;
										elsif aleatorio = "10" then   Eprox <= E_c;
										elsif aleatorio = "11" then   Eprox <= E_d;
										else Eprox <= E_Aleatorio;
                              end if;
										
			when E_a => if    b = '1' then   Eprox <= E_Erro;
                     elsif c = '1' then   Eprox <= E_Erro;
                     elsif d = '1' then   Eprox <= E_Erro;
                     elsif a = '1' then   Eprox <= E_Aleatorio;
							elsif fim_espera_30_segundos = '1' then Eprox <= E_Fim;
							else Eprox <= E_a;
                     end if;
							
			when E_b => if    a = '1' then   Eprox <= E_Erro;
                     elsif c = '1' then   Eprox <= E_Erro;
                     elsif d = '1' then   Eprox <= E_Erro;
                     elsif b = '1' then   Eprox <= E_Aleatorio;
							elsif fim_espera_30_segundos = '1' then Eprox <= E_Fim;
							else Eprox <= E_b;
                     end if;
							
			when E_c => if    a = '1' then   Eprox <= E_Erro;
                     elsif b = '1' then   Eprox <= E_Erro;
                     elsif d = '1' then   Eprox <= E_Erro;
                     elsif c = '1' then   Eprox <= E_Aleatorio;
							elsif fim_espera_30_segundos = '1' then Eprox <= E_Fim;
							else Eprox <= E_c;
                     end if;
							
			when E_d => if    a = '1' then   Eprox <= E_Erro;
                     elsif b = '1' then   Eprox <= E_Erro;
                     elsif c = '1' then   Eprox <= E_Erro;
                     elsif d = '1' then   Eprox <= E_Aleatorio;
							elsif fim_espera_30_segundos = '1' then Eprox <= E_Fim;
							else Eprox <= E_d;

                     end if;
							
			when E_Erro =>if    a = '0' then   Eprox <= E_Erro;
                       elsif b = '0' then   Eprox <= E_Erro;
                       elsif c = '0' then   Eprox <= E_Erro;
                       elsif d = '0' then   Eprox <= E_Erro;
							  else Eprox <= E_Espera_3_segundos;
                       end if;
							  
		  when E_Fim => if    a = '0' then   Eprox <= E_Fim;
                      elsif b = '0' then   Eprox <= E_Fim;
                      elsif c = '0' then   Eprox <= E_Fim;
                      elsif d = '0' then   Eprox <= E_Fim;
							 else Eprox <= E_Espera_3_segundos;
                      end if;
							
         when others =>  Eprox <= E_Inicial;
      end case;
   end process;

   -- sinais de controle ativos em alto
               
   with Ereg select
      ligado <=   '0' when E_Inicial,
						'1' when others;
						
	with Ereg select
		preparar <= '1' when E_Espera_3_segundos,
						'0' when others;
						
	with Ereg select
		conta_30_segundos <= '0' when E_Inicial | E_Ligado | E_Fim | E_Erro,
									'1' when others;
						
	with Ereg select
		somar_ponto <= '1' when E_Aleatorio,
							'0' when others;
							
	with Ereg select
		ledA <= '1' when E_a,
				  '0'	when others;
		
	with Ereg select 
		ledB <= '1' when E_b,
				  '0'	when others;

	with Ereg select 
		ledC <= '1' when E_c,
				  '0'	when others;
				  
	with Ereg select 
		ledD <= '1' when E_d,
				  '0'	when others;

	with Ereg select 
		fim <= '1' when E_Fim,
				  '0'	when others;				  

	with Ereg select
		erro <= '1' when E_Erro,
				  '0'	when others;				  
				  
end controlador_arch; 
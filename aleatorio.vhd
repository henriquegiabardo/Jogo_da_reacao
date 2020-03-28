----------------------------------------------------------------
-- Arquivo   : aleatorio.vhd
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


--colocar a entity
entity aleatorio is
port (  clock, reset: in std_logic;
        gerar_novo_aleatorio: in std_logic; 
        aleatorio: out std_logic_vector(1 downto 0)
        
 );
end aleatorio; 

architecture completa of aleatorio is
-- copiar as entities dos componentes a serem instanciados


component contador_1a3 is
   port (
        clock    : in  std_logic;
        clr  : in  std_logic;
        ent, enp : in  std_logic;
        Q        : out std_logic_vector (1 downto 0);
        rco      : out std_logic 
   );
end component;

component registrador2bits is
  port ( clock:         in  std_logic;
         clear, enable: in  std_logic;
         D:             in  std_logic_vector (1 downto 0);
         Q:             out std_logic_vector (1 downto 0) 
       );
end component;


-- sinais intermediários para serem transmitidos do controlador para os componentes
signal signal_registrador, signal_contador, signal_soma_registrador_contador: std_logic_vector(1 downto 0);	

begin 

-- instanciar components

CONTA_1A3: contador_1a3 port map ( 	clock => clock,
													clr => reset,
													ent => '1',
													enp => '1',
													Q => signal_contador,
													rco => open
												);
												
REGIST2BITS: registrador2bits port map ( 	clock => clock,
																clear => reset,
																enable => gerar_novo_aleatorio,
																D => signal_soma_registrador_contador,
																Q => signal_registrador
															);

															
signal_soma_registrador_contador <= signal_registrador + signal_contador;
aleatorio <= signal_soma_registrador_contador;												
end architecture;
----------------------------------------------------------------
-- Arquivo   : jogo_reacao_projeto.vhd
-- Projeto   : Jogo do Tempo de Reacao aplicado a E-SPorts
-- Data      : 18/03/2020
----------------------------------------------------------------
-- Descricao : Projeto de Lab Digi 1
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor                        Descricao
--     18/03/2020  1.0     Henrique Geribello 			   criacao
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


--colocar a entity
entity jogo_reacao_projeto is
port (  clock, reset: in std_logic;
        liga, a, b, c, d: in std_logic; 
        
        ligado, preparar, ledA, ledB, ledC, ledD, erro, fim, pontuou: out std_logic;
		  display0, display1: out std_logic_vector (6 downto 0) -- displays 7 segmentos
 
 );
end jogo_reacao_projeto; 

architecture completa of jogo_reacao_projeto is
-- copiar as entities dos componentes a serem instanciados


component interface_leds_botoes is
port (  clock, reset: in std_logic;
        liga, a, b, c, d: in std_logic; 
        
        ligado, preparar, ledA, ledB, ledC, ledD, erro, fim, pontuou: out std_logic         
 );
end component;

component hexa7seg is
port (
    hexa : in std_logic_vector(3 downto 0);
    sseg : out std_logic_vector(6 downto 0)
  );
end component;    

component contador8bits is
   port (
        clock : in  std_logic;
        zera  : in  std_logic;
        conta : in  std_logic;
        Q     : out std_logic_vector (7 downto 0);
        rco   : out std_logic 
   );
end component;

-- sinais intermediários para serem transmitidos do controlador para os componentes
signal signal_fim, signal_pontuou: std_logic;
signal signal_pontos: std_logic_vector(7 downto 0);

begin 

-- instanciar components

INTERFACE: interface_leds_botoes port map( clock => clock,
														 reset => reset,
														 liga => liga,
														 a => a,
														 b => b,
														 c => c,
														 d => d,
														 
														 ligado => ligado,
														 preparar => preparar,
														 ledA => ledA,
														 ledB => ledB,
														 ledC => ledC,
														 ledD => ledD,
														 erro => erro,
														 fim => signal_fim,
														 pontuou => signal_pontuou
														);

														
CONTADOR_PONTOS: contador8bits port map ( clock => clock,
														zera => reset,
														conta => signal_pontuou,
														Q => signal_pontos,
														rco => open
														);


fim <= signal_fim;														
pontuou <= signal_pontuou;
DISP0: hexa7seg port map(hexa => signal_pontos(3 downto 0), sseg => display0);
DISP1: hexa7seg port map(hexa => signal_pontos(7 downto 4), sseg => display1);													

            
end architecture;
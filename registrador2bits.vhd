----------------------------------------------------------------
-- Arquivo   : registrador2bits.vhd
-- Projeto   : E-sports
-- Data      : 04/01/2020
----------------------------------------------------------------
-- Descricao : registrador de 2 bits 
--             com enable e clear sincronos e ativos em alto
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     15/01/2020  1.0     Henrique Geribello  criacao
-- 	 21/03/2020  2.0     Henrique					adaptação para o projeto
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity registrador2bits is
  port ( clock:         in  std_logic;
         clear, enable: in  std_logic;
         D:             in  std_logic_vector (1 downto 0);
         Q:             out std_logic_vector (1 downto 0) 
       );
end registrador2bits;

architecture comportamental of registrador2bits is 
  signal IQ: std_logic_vector (1 downto 0);
begin

  process(clock)
  begin
      if clock'event and clock='1' then
        if clear = '1' then 
          IQ <= (others => '0');
        elsif enable ='1' then 
          IQ <= D;
        else
          IQ <= IQ; -- para evitar inferencia de latches
        end if;
      end if;
  end process;
  
  Q <= IQ;
  
end comportamental;
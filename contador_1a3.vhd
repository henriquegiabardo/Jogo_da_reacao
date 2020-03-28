----------------------------------------------------------------
-- Arquivo   : contador_1a3.vhd
-- Projeto   : Jogo do Tempo de Reacao
-- Data      : 04/01/2020
----------------------------------------------------------------
-- Descricao : contador binario hexadecimal (modulo 16) 
--             similar ao CI 74163
----------------------------------------------------------------
-- Revisoes  :
--     Data        Versao  Autor             Descricao
--     04/01/2020  1.0     Edson Midorikawa  criacao
--     21/03/2020  2  		Henrique 			adaptação para o projeto
----------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_1a3 is
   port (
        clock    : in  std_logic;
        clr  : in  std_logic;
        ent, enp : in  std_logic;
        Q        : out std_logic_vector (1 downto 0);
        rco      : out std_logic 
   );
end contador_1a3;

architecture comportamental of contador_1a3 is
  signal IQ: integer range 0 to 15;
begin
  
  process (clock,clr,ent,enp,IQ)
  begin

    if clock'event and clock='1' then
      if clr='0' then   IQ <= 0; 
      elsif ent='1' and enp='1' then
        if IQ=3 then   IQ <= 1; 
        else            IQ <= IQ + 1; 
        end if;
      else              IQ <= IQ;
      end if;
    end if;
    
    if IQ=3 and ENT='1' then rco <= '1'; 
    else                      rco <= '0'; 
    end if;

    Q <= std_logic_vector(to_unsigned(IQ, Q'length));

  end process;
end comportamental;

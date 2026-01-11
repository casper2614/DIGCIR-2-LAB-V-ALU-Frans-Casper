------------------------------------------------------------------------------
--! \file      logicUnit.vhd
--! \date      see top of 'Version History'
--! \brief     n-bit logic unit
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 3
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------------
ENTITY logicUnit is

   GENERIC (
      N: INTEGER := 4   --! logic unit is designed for 4-bits
   );
   
   PORT (
      A : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! n-bit binary input
      B : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! n-bit binary input
      F : IN  STD_LOGIC_VECTOR (2   DOWNTO 0); --! 3-bit opcode
      R : OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0)  --! n-bit binary output
   );
   
END ENTITY logicUnit;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF logicUnit IS
BEGIN

WITH F SELECT
	R <= 	(A AND B)		WHEN 						"000",
			(A OR B)			WHEN 						"001",
			(A XOR B)		WHEN						"010",
			(NOT A)			WHEN						"011",
			(A(N-2 DOWNTO 0) & '0') 		WHEN	"100", 	-- shift left
			(A(N-2 DOWNTO 0) & A(N-1))		WHEN 	"101", --wat hier staat basicly betekent, je pakt alleen bit 'N-2' t/m 0 (--Dus "4(321)"--) en voeg je 'N-1' toe achterin (-- Dus "321(4)"--) 
			('0' & (A(N-1 DOWNTO 1)))	 	WHEN 	"110",	-- shift right
			A(N-4) & (A(N-1 DOWNTO 1)) 	WHEN 	"111",	-- reverse van daarnet
			(OTHERS => '0') 	WHEN				  OTHERS;

END ARCHITECTURE implementation;

--------------------------------------------------------------------
--! \file      arithmeticUnit.vhd
--! \date      see top of 'Version History'
--! \brief     n-bit arithmetic unit
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 3
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
------------------------------------------------------------------------------
ENTITY arithmeticUnit is

   GENERIC (
      N: INTEGER := 4  --! logic unit is designed for 4-bits
   );
   
   PORT (
      A : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
      B : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
      P : IN  STD_LOGIC_VECTOR (3   DOWNTO 0);
      F : IN  STD_LOGIC_VECTOR (2   DOWNTO 0);
      R : OUT STD_LOGIC_VECTOR (N   DOWNTO 0) 
   );
   
END ENTITY arithmeticUnit;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF arithmeticUnit IS

	SIGNAL u_A 	: UNSIGNED(N-1 DOWNTO 0); 
	SIGNAL u_B	: UNSIGNED(N-1 DOWNTO 0);
	SIGNAL u_C  : UNSIGNED(N	DOWNTO 0);
	
	SIGNAL bcdOpgeteld	:	UNSIGNED(N DOWNTO 0);
	SIGNAL bcdAntwoord	:	UNSIGNED(N DOWNTO 0);

BEGIN

	bcdOpgeteld <= ('0' & u_A) + ('0' & u_B) + u_C;
	bcdAntwoord <= bcdOpgeteld + 6 WHEN (bcdOpgeteld > 9) ELSE bcdOpgeteld;
	
	
	u_C(0) <= P(0);
	u_C(N DOWNTO 1) <= (OTHERS => '0');
	
		WITH F SELECT
		R <=
			(OTHERS => '0')                                                 WHEN "000",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) + 1)                         WHEN "001",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) - 1)                         WHEN "010",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) + UNSIGNED('0' & B))         WHEN "011",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) + UNSIGNED('0' & B) + u_C)   WHEN "100",
			STD_LOGIC_VECTOR(bcdAntwoord)                                   WHEN "101",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) - UNSIGNED('0' & B))         WHEN "110",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) - UNSIGNED('0' & B) - u_C)   WHEN "111",
			(OTHERS => '0')                 WHEN OTHERS;





END ARCHITECTURE implementation;

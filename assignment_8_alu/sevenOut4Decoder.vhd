------------------------------------------------------------------------------
--! \file      lsevenOut4Decoder.vhd
--! \date      see top of 'Version History'
--! \brief     Placegolder for 7 segment decoder with dot-driver and extended characters
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 2
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
------------------------------------------------------------------------------
ENTITY sevenOut4Decoder is

	GENERIC (
		CONSTANT zero : STD_LOGIC_VECTOR(0 TO 6) := "0000001";
		CONSTANT one : STD_LOGIC_VECTOR(0 TO 6) := "1001111";
		CONSTANT two : STD_LOGIC_VECTOR(0 TO 6) := "0010010";
		CONSTANT three : STD_LOGIC_VECTOR(0 TO 6) := "0000110";
		CONSTANT four : STD_LOGIC_VECTOR(0 TO 6) := "1001100";
		CONSTANT five : STD_LOGIC_VECTOR(0 TO 6) := "0100100";
		CONSTANT six : STD_LOGIC_VECTOR(0 TO 6) := "0100000";
		CONSTANT seven : STD_LOGIC_VECTOR(0 TO 6) := "0001111";
		CONSTANT eight : STD_LOGIC_VECTOR(0 TO 6) := "0000000";
		CONSTANT nine : STD_LOGIC_VECTOR(0 TO 6) := "0000100";
		
		CONSTANT off : STD_LOGIC_VECTOR(0 TO 6) := "1111111";
		CONSTANT plus : STD_LOGIC_VECTOR(0 TO 6) := "1001110";
		CONSTANT minus : STD_LOGIC_VECTOR(0 TO 6) := "1111110"
	);

   PORT (
      input   : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dot     : IN  STD_LOGIC;                   
      ctrl    : IN  STD_LOGIC;                   
      display : OUT STD_LOGIC_VECTOR(0 TO 7)     
   );
   
END ENTITY sevenOut4Decoder;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF sevenOut4Decoder IS

   SIGNAL std_seg: STD_LOGIC_VECTOR(0 TO 6) := "0000000";
   SIGNAL ext_seg: STD_LOGIC_VECTOR(0 TO 6) := "0000000";
	
BEGIN

-- Step 1: Connect port "dot" to the dot-segment in the HEX display.
   display(7) <= NOT dot;
   
   -- Step 2: Implement here the multiplexer that will present the normal characters.
   WITH input SELECT
   std_seg <= zero WHEN "0000",
              one WHEN "0001",
              two WHEN "0010",
              three WHEN "0011",
              four WHEN "0100",
              five WHEN "0101",
              six WHEN "0110",
              seven WHEN "0111",
              eight WHEN "1000",
              nine WHEN "1001",
              off WHEN OTHERS;
   
   -- Step 3: Implement here the multiplexter that will the extended characters.
   WITH input SELECT
   ext_seg <= plus WHEN "0001",
              minus WHEN "0010",
              off WHEN OTHERS;
   
   -- Step 4: Implement here the  selector of the normal characters and the 
   -- extended characters using the ctrl signal.
   WITH ctrl SELECT
   display(0 TO 6) <= std_seg WHEN '0',
                      ext_seg WHEN '1';


END ARCHITECTURE implementation;
------------------------------------------------------------------------------

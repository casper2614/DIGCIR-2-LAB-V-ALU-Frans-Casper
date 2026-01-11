--------------------------------------------------------------------
--! \file      operandResultInterpreter.vhd
--! \date      see top of 'Version History'
--! \brief     Interpreter of operand and result with carry and opcode
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students shall replace this file for the result of assignment 4
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
------------------------------------------------------------------------------
ENTITY operandResultInterpreter is

   PORT (
      opcode :           IN   STD_LOGIC_VECTOR(3 DOWNTO 0); --! 4-bit opcode
      result :           IN   STD_LOGIC_VECTOR(3 DOWNTO 0); --! n-bit binary input carrying Result
      signed_operation : IN   STD_LOGIC;
      hexSignal0,
      hexSignal1 :       OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dotSignal0,
      control0,
      dotSignal1,
      control1 :         OUT  STD_LOGIC
   );
   
END ENTITY operandResultInterpreter;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF operandResultInterpreter IS

	SIGNAL opcodeSelected : STD_LOGIC;

BEGIN
   hexSignal0 <= result;
	control0   <= '1';
	
	opcodeSelected <= '1' WHEN 
        (opcode = "0001" OR
         opcode = "0010" OR
         opcode = "0011" OR
         opcode = "0100" OR
         opcode = "0110" OR
         opcode = "0111") 
        ELSE '0';
	
	PROCESS(signed_operation, opcodeSelected, result)
    BEGIN
        IF signed_operation = '1' AND opcodeSelected = '1' THEN
            IF SIGNED(result) < 0 THEN
                hexSignal1 <= "1011"; -- hexSingal voor MIN 
            ELSE
                hexSignal1 <= "1010"; -- hexSignal voor PLUS
            END IF;
            
            control1 <= '1';  -- display 1 aan zetten 
        ELSE
            hexSignal1 <= "0000"; 
            control1   <= '0';    --basicly alles uit
        END IF;
    END PROCESS;

  

END ARCHITECTURE implementation;
------------------------------------------------------------------------------

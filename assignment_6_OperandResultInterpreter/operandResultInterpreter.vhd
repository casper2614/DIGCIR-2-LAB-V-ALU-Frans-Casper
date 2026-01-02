--------------------------------------------------------------------
--! \file      operandResultInterpreter.vhd
--! \date      see top of 'Version History'
--! \brief     Interpreter of operand and result with carry and opcode
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students that submit this code have to complete their details:
--!
--! Student 1 name         : 
--! Student 1 studentnumber: 
--! Student 1 email address: 
--!
--! Student 2 name         : 
--! Student 2 studentnumber: 
--! Student 2 email address: 
--!
--! Student 3 name         : 
--! Student 3 studentnumber: 
--! Student 3 email address: 
--!
--!
--! Version History:
--! ----------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 001    |22-10-2019 |WLGRW   |Inital version
--! 002    |25-11-2020 |WLGRW   |Adapted version for H-EHE-SOC class
--! 003    |19-12-2020 |WLGRW   |Version created to be used as assignment
--! 004    |23-03-2021 |WLGRW   |Correction of documentation and input-output-diagram
--!
--! \todo Add revsion history when executing these assignments.
--!
--! Function
--! --------
--!
--! The purpose of the unit is to control 2 7-segment displays (HEX-displays)
--! and present the result of the ALU operation of both displays.
--!
--! In the ALU, operand A and B as well as the result R are presented on 2 
--! HEX-displays. The left display can present the number 1, the symbols '+'
--! and '-' or switched off. The right display will present the hexadecimal 
--! numbers 0 to F. See figure 1.
--!
--! \verbatim
--!
--!  Figure 1: arrangement of HEX displays for operand or result.
--!
--!   Left (0)  Right (1)
--!    Display   Display
--!   +-------+ +-------+
--!   |  --   | |  --   |
--!   | |  |  | | |  |  |
--!   |  --   | |  --   |
--!   | |  |  | | |  |  |
--!   |  -- o | |  -- o |
--!   +-------+ +-------+
--!
--! \endverbatim
--!
--! HEX display 0 is primary controlled by the signed-operation signal. 
--! in SIGNED operation it is switched on and in UNSIGNED operation off.
--! 
--! HEX display 1 present the hexadecimal numbers 0 to F.
--!
--! The dot-led is not used with the ALU and therefore always switched off.
--!
--! Design
--! ------
--!
--! Figure 2 presents the input-output diagram of the operand-result-interpreter.
--!
--! \verbatim
--!
--!  Figure 2: Input-output diagram of the operand-result-interpreter.
--! 
--!                 +----------------+   4
--!                 |                |---/--- hexSignal 0     \
--!             4   |                |                        |
--!  Result ----/---|                |------- dotSignal 0     +-> 1st 7-segment display
--!                 |                |                        |
--!             4   |    Operand     |------- controlSignal 0 /
--!  Opcode ----/---|     result     |   4
--!                 |   Interpreter  |---/--- hexSignal 1     \
--!                 |                |                        |
--!  Signed ops ----|                |------- dotSignal 1     +-> 2nd 7-segment display
--!                 |                |                        |
--!                 |                |------- controlSignal 1 /
--!                 +----------------+
--!
--! \endverbatim
--!
--! Opcodes and operations of the ALU
--! ---------------------------------
--! The following table is for reference purpose.
--!
--! Table 1: Opcodes and operations of the ALU.
--!
--! Bin  | Opcode  | Functionality/Operation
--! -----|---------|--------------------------------------------------------------------------------------
--! 0000 | OP_CLRR | CLR R, clear R (R:=0), all flag bits are affected
--! 0001 | OP_INCA | INC A, Increment A, R:=A+1, all flag bits are affected 
--! 0010 | OP_DECA | DEC A, Decrement A, R:=A-1, all flag bits are affected
--! 0011 | OP_ADD  | ADD A with B, R:=A+B, all flag bits are affected
--! 0100 | OP_ADC  | ADC A with B and Carry, R:=A+B+C, all flag bits are affected
--! 0101 | OP_ADB  | ADB A with B and Carry, R:=A+B+C using BCD arithmetic, C and Z flag bits are affected
--! 0110 | OP_SUB  | SUB B from A, R:=A-B, flag bits are affected
--! 0111 | OP_SBC  | SBC B from A including C, R:=A-B-C, flag bits are affected
--!        
--! Bin  | Opcode  | Functionality/Operation
--! -----|---------|-------------------------------------------------------------------
--! 1000 | OP_AND  | AND A with B, R:=A AND B, bitwise AND, Z-flag bit is affected
--! 1001 | OP_OR   | OR A with B, R:=A OR B, bitwise OR,    Z-flag bit is affected
--! 1010 | OP_XOR  | XOR A with B, R:=A XOR B, bitwise XOR, Z-flag bit is affected
--! 1011 | OP_NOTA | NOT A, R:=NOT A,                       Z-flag bit is affected
--! 1100 | OP_SHLA | SHL A, R:=SHL A,                       flag bits are not affected
--! 1101 | OP_ROLA | ROL A, R:=ROL A,                       flag bits are not affected
--! 1110 | OP_SHRA | SHR A, R:=SHR A,                       flag bits are not affected
--! 1111 | OP_RORA | ROR A, R:=ROR A,                       flag bits are not affected

------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
------------------------------------------------------------------------------
ENTITY operandResultInterpreter is

     GENERIC (
      N: INTEGER := 4;  --! logic unit is designed for 4-bits
      
      --! Implement here CONSTANTS as GENERIC when required.
		
	ZERO : STD_LOGIC_VECTOR(0 TO 6) := "0000001";
   ONE : STD_LOGIC_VECTOR(0 TO 6) := "1001111";
   TWO: STD_LOGIC_VECTOR(0 TO 6) := "0010010";
   THREE: STD_LOGIC_VECTOR(0 TO 6) := "0000110";
   FOUR : STD_LOGIC_VECTOR(0 TO 6) := "1001100";
   FIVE : STD_LOGIC_VECTOR(0 TO 6) := "0100100";
   SIX : STD_LOGIC_VECTOR(0 TO 6) := "0100000";
   SEVEN : STD_LOGIC_VECTOR(0 TO 6) := "0001111";
   EIGHT : STD_LOGIC_VECTOR(0 TO 6) := "0000000";
   NINE : STD_LOGIC_VECTOR(0 TO 6) := "0000100";
   HEX_A : STD_LOGIC_VECTOR(0 TO 6) := "0001000";
   HEX_b : STD_LOGIC_VECTOR(0 TO 6) := "1100000";
   HEX_C : STD_LOGIC_VECTOR(0 TO 6) := "0110001";
   HEX_d : STD_LOGIC_VECTOR(0 TO 6) := "1000010";
   HEX_E : STD_LOGIC_VECTOR(0 TO 6) := "0110000";
   HEX_F : STD_LOGIC_VECTOR(0 TO 6) := "0111000";
   BLANK : STD_LOGIC_VECTOR(0 TO 6) := "1111111";
	
	PLUS	: STD_LOGIC_VECTOR(0 TO 6) 	:= "1111000";
	NEGATIVE : STD_LOGIC_VECTOR(0 TO 6) := "1111110"
		
   );
	
   
   PORT (
      opcode :           	IN   STD_LOGIC_VECTOR(3 DOWNTO 0); --! 4-bit opcode
      result :           	IN   STD_LOGIC_VECTOR(3 DOWNTO 0); --! n-bit binary input carrying Result
      signed_operation : 	IN   STD_LOGIC;
      hexSignal0,
      hexSignal1 :       	OUT  STD_LOGIC_VECTOR(3 DOWNTO 0);
      dotSignal0,	
      control0,
      dotSignal1,
      control1 :         	OUT  STD_LOGIC;
		
		HEX0 : OUT STD_LOGIC_VECTOR(0 TO 7);
		HEX1 : OUT STD_LOGIC_VECTOR(0 TO 7);
		
		A	:				IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --Operand A
		B	:				IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0)  --Operand B
		
		
   );
   
END ENTITY operandResultInterpreter;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF operandResultInterpreter IS




   -- Implement here the SIGNALS to your descretion\
	
	
	SIGNAL u_A 	: UNSIGNED(N-1 DOWNTO 0); 
	SIGNAL u_B	: UNSIGNED(N-1 DOWNTO 0);
	SIGNAL u_R	: UNSIGNED(N   DOWNTO 0);
	SIGNAL u_C  : UNSIGNED(N	DOWNTO 0);
	
	SIGNAL bcdOpgeteld	:	UNSIGNED(N DOWNTO 0);
	SIGNAL bcdAntwoord	:	UNSIGNED(N DOWNTO 0);
	
	SIGNAL tussenResult 	: 	STD_LOGIC_VECTOR(N DOWNTO 0);

BEGIN

	bcdOpgeteld <= ('0' & u_A) + ('0' & u_B) + u_C;
	bcdAntwoord <= bcdOpgeteld + 6 WHEN (bcdOpgeteld > 9) ELSE bcdOpgeteld;
	
	
	WITH opcode SELECT
		tussenResult <=
			(OTHERS => '0')                                                 WHEN "0000",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) + 1)                         WHEN "0001",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) - 1)                         WHEN "0010",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) + UNSIGNED('0' & B))         WHEN "0011",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) + UNSIGNED('0' & B) + u_C)   WHEN "0100",
			STD_LOGIC_VECTOR(bcdAntwoord)                                   WHEN "0101",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) - UNSIGNED('0' & B))         WHEN "0110",
			STD_LOGIC_VECTOR(UNSIGNED('0' & A) - UNSIGNED('0' & B) - u_C)   WHEN "0111",
			('0' & (A AND B))               WHEN "1000",
			('0' & (A OR B))                WHEN "1001",
			('0' & (A XOR B))               WHEN "1010",
			('0' & (NOT A))                 WHEN "1011",
			('0' & A(N-2 DOWNTO 0) & '0')   WHEN "1100",    
			('0' & A(N-2 DOWNTO 0) & A(N-1))WHEN "1101", 
			('0' & '0' & A(N-1 DOWNTO 1))   WHEN "1110",  
			('0' & A(0) & A(N-1 DOWNTO 1))  WHEN "1111",
			(OTHERS => '0')                 WHEN OTHERS;
	
	-- Functionality/Operation
	
	
	WITH tussenResult SELECT
		hexSignal1 <=
			ZERO  WHEN "0000",
			ONE   WHEN "0001",
			TWO   WHEN "0010",
			THREE WHEN "0011",
			FOUR  WHEN "0100",
			FIVE  WHEN "0101",
			SIX   WHEN "0110",
			SEVEN WHEN "0111",
			EIGHT WHEN "1000",
			NINE  WHEN "1001",
			HEX_A	WHEN	"1010",
			HEX_B WHEN	"1011",
			HEX_C	WHEN	"1100",
			HEX_D	WHEN	"1101",
			HEX_E	WHEN	"1110",
			HEX_F	WHEN	"1111",
			BLANK	WHEN OTHERS;
	
	
	HEX0 <= 
		NEGATIVE & '1' WHEN (signed_operation = '1' AND tussenResult(3) = '1') ELSE
		PLUS     & '1' WHEN (signed_operation = '1' AND tussenResult(3) = '0') ELSE
		BLANK    & '1';
	
	dotSignal0 <= '0';
   dotSignal1 <= '0';
	control0 <= '1';
   control1 <= '1';
  
END ARCHITECTURE implementation;
------------------------------------------------------------------------------

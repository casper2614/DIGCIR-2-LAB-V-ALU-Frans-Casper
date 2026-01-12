--------------------------------------------------------------------
--! \file      logicUnit.vhd
--! \date      see top of 'Version History'
--! \brief     n-bit logic unit
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students that submit this code have to complete their details:
--!
--! -Student 1 name         : Frans Ebbers
--! -Student 1 studentnumber: 2151119
--! -Student 1 email address: fxjba.ebbers@student.han.nl
--! 
--! -Student 2 name         : Casper Janssen
--! -Student 2 studentnumber: 2171774
--! -Student 2 email address: CN.Janssen@student.han.nl
--!
--!
--! Version History:
--! ----------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 001    |18-10-2019 |WLGRW   |Inital version
--! 002    |9-1-2020   |WLGRW   |Added use of shift functions
--! 003    |24-11-2020 |WLGRW   |Modifed for use in SOC-class January 2021
--! 004    |9-12-2020  |WLGRW   |Modifications for assignment
--! 005    |24-1-2025  |WLGRW   |Removed unnecessary code
--! 
--! \todo Add revsion history when executing these assignments.
--!
--! Design:
--! -------
--! Figure 1 presents the input-output diagram of the logic unit.
--! Depending on the opcode the logic unit will apply the operation
--! as specified in table 1.
--! 
--! \verbatim
--!
--!  Figure 1: Input-output diagram of the logic unit.
--! 
--!                  +---------+
--!              n   |         |
--! operand A ---/---|         |
--!              n   |  logic  |   4
--! operand B ---/---|         |---/--- Result
--!              3   |  unit   |
--! opcode ------/---|         |
--!                  |         |
--!                  +---------+
--! 
--! \endverbatim
--!
--! Function:
--! -----------
--! Table 1: Opcodes and operations of the logic unit.
--!
--! Bin | Opcode  | Functionality/Operation
--! ----|---------|-------------------------------------------------------------------
--! 000 | OP_AND  | AND A with B, R:=A AND B, bitwise AND, Z-flag bit is affected
--! 001 | OP_OR   | OR A with B, R:=A OR B, bitwise OR,    Z-flag bit is affected
--! 010 | OP_XOR  | XOR A with B, R:=A XOR B, bitwise XOR, Z-flag bit is affected
--! 011 | OP_NOTA | NOT A, R:=NOT A,                       Z-flag bit is affected
--! 100 | OP_SHLA | SHL A, R:=SHL A,                       flag bits are not affected
--! 101 | OP_ROLA | ROL A, R:=ROL A,                       flag bits are not affected
--! 110 | OP_SHRA | SHR A, R:=SHR A,                       flag bits are not affected
--! 111 | OP_RORA | ROR A, R:=ROR A,                       flag bits are not affected
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;

------------------------------------------------------------------------------
ENTITY logicUnit is

   GENERIC (
      N: INTEGER := 4  --! logic unit is designed for 4-bits
      
      --! Implement here CONSTANTS as GENERIC when required.
      
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

   --! Implement here the logic-unit that executes the operations as presented
   --! in table 1.
	
WITH F(2 DOWNTO 0) SELECT
    R <=    (A AND B)                       WHEN "000", -- And-gate A and B
            (A OR B)                        WHEN "001", -- Or-gate A and B
            (A XOR B)                       WHEN "010", -- Xor-gate A and B
            (NOT A)                         WHEN "011", -- Not-gate A
            (A(N-2 DOWNTO 0) & '0') 		WHEN "100", -- Append 0 to right side of A, meaning left shift
            (A(N-2 DOWNTO 0) & A(N-1))		WHEN "101", -- Wrap arround, MSB/Left bit will be appended to right side/LSB 
            ('0' & (A(N-1 DOWNTO 1)))	 	WHEN "110",	-- Append 0 to left side of A, meaning right shift
            A(N-4) & (A(N-1 DOWNTO 1))      WHEN "111", -- Wrap arround reverse, LSB/Right bit will be appened to left side/MSB
            (OTHERS => '0')                 WHEN OTHERS; -- Fallback, when opcode isn't valid, return all zero's

END ARCHITECTURE implementation;

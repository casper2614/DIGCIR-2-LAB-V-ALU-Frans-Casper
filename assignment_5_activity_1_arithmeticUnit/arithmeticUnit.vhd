--------------------------------------------------------------------
--! \file      arithmeticUnit.vhd
--! \date      see top of 'Version History'
--! \brief     n-bit arithmetic unit
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! \todo Students that submit this code have to complete their details:
--!
--! -Student 1 name         : 
--! -Student 1 studentnumber: 
--! -Student 1 email address: 
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
--! 002    |25-11-2020 |WLGRW   |Adapted for H-ESE-SOC class
--! 003    |9-12-2020  |WLGRW   |Modifications for assignment
--!
--! \todo Add revsion history when executing these assignments.
--!
--! Design:
--! -------
--! Figure 1 presents the input-output diagram of the artithmetic unit.
--! Depending on the opcode the artithmetic unit will apply the operation
--! as specified in table 1.
--! 
--!
--! \verbatim
--!
--!  Figure 1: Input-output diagram of the artithmetic unit.
--! 
--!                   +----------------+
--!               n   |                |
--!  Operand A ---/---|                |
--!                   |                |
--!               n   |                |
--!  Operand B ---/---|                |
--!                   | Arthmatic unit |   n+1
--!               3   |                |---/--- Result R
--!  Opcode F ----/---|                |
--!                   |                |
--!               4   |                |
--!  Flags P -----/---|                |
--!                   |                |
--!                   +----------------+
--!
--! \endverbatim
--!
--! Function:
--! -----------
--! Table 1: Opcodes and operations of the artithmetic unit.
--!
--! Bin | Opcode  | Functionality/Operation
--! ----|---------|--------------------------------------------------------------------------------------
--! 000 | OP_CLRR | CLR R, clear R (R:=0), all flag bits are affected
--! 001 | OP_INCA | INC A, Increment A, R:=A+1, all flag bits are affected 
--! 010 | OP_DECA | DEC A, Decrement A, R:=A-1, all flag bits are affected
--! 011 | OP_ADD  | ADD A with B, R:=A+B, all flag bits are affected
--! 100 | OP_ADC  | ADC A with B and Carry, R:=A+B+C, all flag bits are affected
--! 101 | OP_ADB  | ADB A with B and Carry, R:=A+B+C using BCD arithmetic, C and Z flag bits are affected
--! 110 | OP_SUB  | SUB B from A, R:=A-B, flag bits are affected
--! 111 | OP_SBC  | SBC B from A including C, R:=A-B-C, flag bits are affected
--! 
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;  --! STD_LOGIC
USE ieee.numeric_std.all;     --! SIGNED
------------------------------------------------------------------------------
ENTITY arithmeticUnit is

   GENERIC (
      N  : INTEGER := 4  --! logic unit is designed for 4-bits
      
      --! Implement here CONSTANTS as GENERIC when required.
      
   );
   
   PORT (
      A : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! OPERAND A	n-bit binary input
      B : IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0); --! Operand B	n-bit binary input
      P : IN  STD_LOGIC_VECTOR (3   DOWNTO 0); --! FLAGS			Flags input P(0)=Carry-bit
      F : IN  STD_LOGIC_VECTOR (2   DOWNTO 0); --! OPCODE 		3-bit opcode
      R : OUT STD_LOGIC_VECTOR (N   DOWNTO 0)  --! RESULT 		n+1-bit binary output
   );
   
END ENTITY arithmeticUnit;
------------------------------------------------------------------------------
ARCHITECTURE implementation OF arithmeticUnit IS
   
   -- Implement here the SIGNALS to your descretion

    SIGNAL u_A : UNSIGNED(N-1 DOWNTO 0); 
    SIGNAL u_B : UNSIGNED(N-1 DOWNTO 0);
    SIGNAL u_R : UNSIGNED(N   DOWNTO 0);
    SIGNAL u_C : UNSIGNED(N	DOWNTO 0); 	--1 bit used

    -- Operand A, B, R and C now unsigend

    SIGNAL bcdSum	:	UNSIGNED(N DOWNTO 0);
    SIGNAL bcdResult	:	UNSIGNED(N DOWNTO 0);


BEGIN

   -- Implement here your arithmetic unit.


    bcdSum <= ('0' & u_A) + ('0' & u_B) + u_C;
    bcdResult <= bcdSum + 6 WHEN (bcdSum > 9) ELSE bcdSum;

    u_C(0) <= P(0);
    u_C(N DOWNTO 1) <= (OTHERS => '0');


    WITH F SELECT
    u_R <= (OTHERS => '0')                   WHEN "000",
           ('0' & u_A) + 1                   WHEN "001",
           ('0' & u_A) - 1                   WHEN "010",
           ('0' & u_A) + ('0' & u_B)         WHEN "011",
           ('0' & u_A) + ('0' & u_B) + u_C   WHEN "100",
           bcdResult                         WHEN "101",
           ('0' & u_A) - ('0' & u_B)         WHEN "110",
           ('0' & u_A) + ('0' & u_B) - u_C   WHEN "111",
           (OTHERS => '0')                   WHEN OTHERS;

    R <= STD_LOGIC_VECTOR (u_R(N DOWNTO 0));

END ARCHITECTURE implementation;

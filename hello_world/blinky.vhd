--------------------------------------------------------------------
--! \file      demo.vhd
--! \date      see top of 'Version History'
--! \brief     Hello World on DE10-Lite (Blinky)
--! \author    Remko Welling (WLGRW) remko.welling@han.nl
--! \copyright HAN TF ELT/ESE Arnhem 
--!
--! Version History:
--! ----------------
--!
--! Nr:    |Date:      |Author: |Remarks:
--! -------|-----------|--------|-----------------------------------
--! 001    |29-12-2020 |WLGRW   |Inital version
--!
--! # Layout of DE10-Lite board
--!
--! \verbatim
--!                                                  +--+
--!      DE10-Lite KEY, SW, LED, and HEX layout      |##| <= KEY0
--!                                                  +--+
--!                                                  |##| <= KEY1
--!                                                  +--+
--!
--!                                  9 8 7 6 5 4 3 2 1 0  <- Number
--!                                 +-+-+-+-+-+-+-+-+-+-+
--!    7-segment hexDisplays (HEX)  | | | | | | | | | | | <= Leds (LEDR)
--!      +---+---+---+---+---+---+  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |   |   |                     
--!      |   |   |   |   |   |   |  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |   |   |  | | | | | | | | | | |
--!      |   |   |   |   |   |   |  +-+-+-+-+-+-+-+-+-+-+
--!      |   |   |   |   |   |   |  |#|#|#|#|#|#|#|#|#|#| <= Switch (SW)
--!      +---+---+---+---+---+---+  +-+-+-+-+-+-+-+-+-+-+
--!        5   4   3   2   1   0     9 8 7 6 5 4 3 2 1 0  <- Number
--!
--! \endverbatim
--!
--! # "Hello World" on DE10-Lite (Blinky))
--!
--! This project will blink LEDR0 on the DE10-Lite board in a 1 second interval.
--! 
--! - KEY0 will reset the counter involved to make LEDR0 blink. 
--! - While pressing KEY0, LEDR0 will halt blinking.
--!
--!
--------------------------------------------------------------------
LIBRARY ieee;                 -- this lib needed for STD_LOGIC
USE ieee.std_logic_1164.all;  -- the package with this info
USE ieee.numeric_std.all;     -- UNSIGNED
--------------------------------------------------------------------
ENTITY blinky is

   GENERIC (
      N:                INTEGER := 4;        --! Width of the databus
      CLOCK_FREQUENCY:  INTEGER := 50000000  --! Clock frequency in Hz of the DE-Lite board
   );
   
   PORT( 
      MAX10_CLK1_50: IN STD_LOGIC;
      SW   : IN  STD_LOGIC_VECTOR(0 TO 9);  --! Switches
      KEY  : IN  STD_LOGIC_VECTOR(0 TO 1);  --! Keys
      LEDR : OUT STD_LOGIC_VECTOR(0 TO 9);  --! Leds
      HEX0,
      HEX1,
      HEX2,
      HEX3,
      HEX4,
      HEX5 : OUT STD_LOGIC_VECTOR(0 TO 7)   --! 7-signals to control leds in HEX-hexDisplay
   );

END ENTITY blinky;
--------------------------------------------------------------------
ARCHITECTURE implementation OF blinky IS

   SIGNAL   reset,               --! Reset signal
            clk,                 --! 50 MHz clock from DE-Lite board
            output: STD_LOGIC;   --! Output signal

BEGIN

   --! #### clock devider based on a integer counter: #### 
   devider : PROCESS (clk, reset)
   
      --! integer for counting delimited to 64 there for 6 lines on vector.
      VARIABLE counter : INTEGER RANGE 0 TO CLOCK_FREQUENCY/2 := 0;

   BEGIN
   
      IF (reset = '0') THEN                       -- reset outputs and variables
         counter :=  0;                         -- set counter to 0
         output  <= '0';                        -- set output to 0 
      ELSIF rising_edge(clk) THEN               -- on clock edge
      
         IF (counter < CLOCK_FREQUENCY/2) THEN  -- as long as the counter is below 64
           counter := counter + 1;              -- increment counter
         ELSE                                   -- as the counter reached 64
           counter := 0;                        -- reset counter to 0
           output  <= NOT output;
         END IF;
         
      END IF;                                   -- put result of counter on signal

   END PROCESS;
   
   -- Interconnect SIGNALS to PORTS:
   LEDR(0)  <= output;
   clk      <= MAX10_CLK1_50;
   reset    <= KEY(0);
   
   -- Switch off HEX-displays, Because of negative logic assign '1'
   HEX0 <= (OTHERS => '1');
   HEX1 <= (OTHERS => '1');
   HEX2 <= (OTHERS => '1');
   HEX3 <= (OTHERS => '1');
   HEX4 <= (OTHERS => '1');
   HEX5 <= (OTHERS => '1');

END ARCHITECTURE implementation;
--------------------------------------------------------------------

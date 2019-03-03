----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.02.2019 15:17:01
-- Design Name: 
-- Module Name: instructiontruction_Incoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.decoder.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instructiontantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity instruction_Incoder is
Port (clock:in Std_Logic ;
      instruction: in Std_Logic_Vector(31 downto 0);
      instr: out i_decoded_type;
      ins_class : out instr_class_type
        );

end instruction_Incoder;

architecture Behavioral of instruction_Incoder is
signal instr_class : instr_class_type;
signal cond : std_logic_vector (3 downto 0);
signal F_field : std_logic_vector (1 downto 0);
begin
F_field <= instruction(27 downto 26);
cond <= instruction(31 downto 28);
instr_class<= DP when F_field="00" else
              DT when F_field="01" else
              branch when F_field="10" else
              halt;
ins_class<=instr_class ;
instr<= add when instr_class=DP and instruction(24 downto 21)="0100" else
            sub when instr_class=DP and instruction(24 downto 21)="0010" else
            mov when instr_class=DP and instruction(24 downto 21)="1101" else
            cmp when instr_class=DP and instruction(24 downto 21)="1010" else
            ldr when instr_class=DT and instruction(20)='1' else
            str when instr_class=DT and instruction(20)='0' else
            beq when instr_class=branch and cond="0000" else
            bne when instr_class=branch and cond="0001" else
            b when instr_class=branch and cond="1110" else
            halt;    

end Behavioral;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 05:15:07 PM
-- Design Name: 
-- Module Name: controlstate - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controlstate is
  Port (clock: in std_logic;
        ld_bit: in std_logic;
        instr: in i_decoded_type;
        ins_class : in instr_class_type;
        state1: out controlStates; 
        cen:in std_logic);
end controlstate;

architecture Behavioral of controlstate is
    signal state: controlStates;
begin
state1<=state;
state_proc:process(clock)
begin
if(rising_edge(clock)) then
if cen='1' then
if(state=fetch ) then
    state<=decode;
elsif (state=decode and ins_class=DP) then
    state<=arith;
elsif state=arith then
    state<=res2RF;
elsif state=res2RF then
    state<=fetch;
elsif state=decode and ins_class=DT then
    state<=addr;
elsif state=addr and ld_bit='0'  then
    state<=mem_wr;
elsif state=addr and ld_bit='1'  then
     state<=mem_rd;
elsif state=mem_rd   then
     state<=mem2RF;
elsif state=mem2RF  then
     state<=fetch;
elsif state=decode and ins_class=branch  then
     state<=brn;
elsif state=halt and ins_class=halt  then
     state<=halt;
elsif state=halt  then
     state<=fetch;
elsif state=brn  then
     state<=fetch;
end if;
end if;
end if;
end process;

end Behavioral;

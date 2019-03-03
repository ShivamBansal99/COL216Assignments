----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/28/2019 05:42:47 PM
-- Design Name: 
-- Module Name: execution_state - Behavioral
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

entity execution_state is
  Port (clock: in std_logic;
        step,go,instr: in std_logic;
        ctr_state: in controlStates;
        state1: out executionStates );
end execution_state;

architecture Behavioral of execution_state is
signal state: executionStates:=initial;
begin
state1<=state;
state_proc:process(clock)
begin
if(rising_edge(clock)) then
--TODO: complete execution states
if(state=initial and step='1') then
    state<=onestep;
elsif (state=initial and go='1') then
    state<=cont;
elsif (state=initial and instr='1') then
    state<=oneinstr;
elsif state=initial then
    state<=initial;
elsif state=onestep then
    state<=done;
elsif state=done and step='0' and go='0' and instr='0' then
    state<=initial;
elsif state= done then
    state<=done;
elsif state= cont and ctr_state=halt then
    state<=done;
elsif state=cont then
    state<=cont;
elsif state= oneinstr and (ctr_state=res2RF or ctr_state=mem_wr or ctr_state=mem2RF or ctr_state=brn or ctr_state=halt) then
    state<=done;
else state<=oneinstr;
end if;

end if;
end process;


end Behavioral;

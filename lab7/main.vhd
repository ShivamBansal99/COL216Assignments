----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 04:44:19 PM
-- Design Name: 
-- Module Name: main - Behavioral
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

package decoder is
type instr_class_type is (DP, DT, branch,halt);
type i_decoded_type is (add,sub,cmp,mov,ldr,str,beq,bne,b,halt);
type controlStates is (fetch,decode, arith,res2RF, addr,mem_wr,mem_rd,mem2RF,brn,halt);
type executionStates is (initial, onestep, oneinstr, cont, done);
end package decoder;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
 -- Port (clk:in std_logic );
end main;

architecture Behavioral of main is
begin


end Behavioral;

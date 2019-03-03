----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 05:04:55 PM
-- Design Name: 
-- Module Name: ALU - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
  Port (ins: in i_decoded_type;
        r1: in std_logic_vector(31 downto 0);
        r2: in std_logic_vector(31 downto 0);
        rout: out std_logic_vector(31 downto 0);
        flags: out std_logic;
        Fen: in std_logic;
        cen: in std_logic;
        clk:in std_logic;
        ctr_state: in controlStates ;
        instruction: in std_logic_vector(31 downto 0)
         );
end ALU;

architecture Behavioral of ALU is
Signal Z : std_logic:='0';
signal ztemp: integer:=0;
begin

rout<= std_logic_vector(signed(r1) + signed(r2)) when ctr_state=fetch or (ctr_state=addr and instruction(23)='1') or (ctr_state=arith and ins=add) else
       std_logic_vector(signed(r1) - signed(r2)) when (ctr_state=arith and ins=sub) or (ctr_state=addr and instruction(23)='0') else
       std_logic_vector(signed(r1) + signed(r2)+4) when ctr_state=brn else
         "00000000000000000000000000000000";
Ztemp<=to_integer(signed(r1) - signed(r2));
flags<=z;
process(clk)
begin
--check for cen condition in flag
if rising_edge(clk) then
    if(Fen='1' ) then
        if(Ztemp=0) then
            z<='0';
        else
            z<='1';
        end if;
    end if;
end if;

end process;
end Behavioral;

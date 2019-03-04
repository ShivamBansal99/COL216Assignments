----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2019 04:50:39 PM
-- Design Name: 
-- Module Name: RegFile - Behavioral
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

entity RegFile is
  Port (    r1: in std_logic_vector(3 downto 0);
            r2: in std_logic_vector(3 downto 0);
            r1out: out std_logic_vector(31 downto 0);
            r2out: out std_logic_vector(31 downto 0);
            wad: in std_logic_vector(3 downto 0);
            we: in std_logic;
            wdata: in std_logic_vector(31 downto 0);
            PCdin: in std_logic_vector(31 downto 0);
            PCout: out std_logic_vector(31 downto 0);
            PCwe:in std_logic;
            clk: in std_logic;
            ctr_state: in controlStates;
            instr_dec:  in i_decoded_type ;
            instruction: in std_logic_vector(31 downto 0)
            --reset: in std_logic 
           );
end RegFile;

architecture Behavioral of RegFile is
type rig is array(15 downto 0) of std_logic_vector(31 downto 0);
signal regist : rig:=(others=>(others=>'0'));
begin

r1out<=regist(to_integer(unsigned(r1)));
r2out<= "000000000000000000000000" & instruction(7 downto 0) when (instruction(27 downto 25)="001") else
       regist(to_integer(unsigned(r2))) ;
PCout<=regist(15);
--reset condition
--regist<=(others=>(others=>'0')) when reset='1' ;

process(clk)
begin

if rising_edge(clk) then
    if(we='1') then
        regist(to_integer(unsigned(wad)))<=wdata;
    end if;
    if(PCwe='1') then
        regist(15)<=PCdin;
    end if;
end if;

end process;
end Behavioral;

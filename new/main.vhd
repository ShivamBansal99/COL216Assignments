----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/01/2019 02:15:27 PM
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
  Port (
        clock: in std_logic;
        reset : in std_logic
         );
end main;

architecture Behavioral of main is
signal ins,ind,adim,addm,wd: std_logic_vector(31 downto 0):= "00000000000000000000000000000000";
signal addm1,adim1: std_logic_vector(7 downto 0);
signal en : std_logic:= '0';
    component alu
    port(
                clock : in STD_LOGIC;
                reset : in std_logic;
                ins : in std_logic_vector(31 downto 0);
                ind : in std_logic_vector(31 downto 0);
                adim : out std_logic_vector(31 downto 0);
                addm : out std_logic_vector(31 downto 0);
                wd :out std_logic_vector(31 downto 0);
                en : out std_logic 
    );
end component;
component dist_mem_gen_0 
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;
component dist_mem_gen_1 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;
begin
a: alu port map(clock,reset,ins,ind,adim,addm,wd,en);
b: dist_mem_gen_1 port map(
    a=>adim1,
    spo=>ins);
c: dist_mem_gen_0 port map(
a=>addm1,
d=>wd,
clk=>clock,
we=>en,
spo=>ind);
addm1<=addm(9 downto 2);
adim1<=adim(9 downto 2);
end Behavioral;

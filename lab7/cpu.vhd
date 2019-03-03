----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/01/2019 01:30:35 PM
-- Design Name: 
-- Module Name: cpu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use work.decoder.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cpu is
    Port (
      clk: in std_logic;
      --reset : in std_logic;
      step : in std_logic;
      go: in std_logic;
      instr: in std_logic;
      progselect : in std_logic_vector(2 downto 0);
      dispselect : in std_logic_vector(3 downto 0);
      ledo : out std_logic_vector(15 downto 0)
       );
  
end cpu;

architecture Behavioral of cpu is
component instruction_Incoder is
Port (clock:in Std_Logic ;
      instruction: in Std_Logic_Vector(31 downto 0);
      instr: out i_decoded_type;
      ins_class : out instr_class_type
        );
end component;
component RegFile is
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
            instr_dec:  in i_decoded_type
           );
end component;
component ALU is
  Port (ins: in i_decoded_type;
        r1: in std_logic_vector(31 downto 0);
        r2: in std_logic_vector(31 downto 0);
        rout: out std_logic_vector(31 downto 0);
        flags: out std_logic;
        Fen: in std_logic;
        cen: in std_logic;
        clk:in std_logic;
        ctr_state: in controlStates;
        instruction: in std_logic_vector(31 downto 0)
         );
end component;
component controlstate is
  Port (clock: in std_logic;
        ld_bit: in std_logic;
        instr: in i_decoded_type;
        ins_class : in instr_class_type;
        state1: out controlStates; 
        cen: in std_logic);
end component;
component execution_state is
  Port (clock: in std_logic;
        step: in std_logic;
        go: in std_logic;
        instr: in std_logic;
        ctr_state: in controlStates;
        state1: out executionStates );
end component;
component dist_mem_gen_1
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END component;
component dist_mem_gen_0 IS
  PORT (
    a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    spo : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
end component;
signal r1out,r2out,wdata,PCdin,PCout,r1alu,r2alu,pcalu,routalu,pcoutalu,ramspo,ramd,instruction:std_logic_vector(31 downto 0);
signal r1reg,r2reg,wadreg:std_logic_vector(3 downto 0);
signal wereg,PCwereg,flags,fen,ld_bit,cen,step1,go1,instr1,ramwe: std_logic:='0';
signal aram,arom: std_logic_vector(7 downto 0);
signal ctrstate: controlStates;
signal instr_class: instr_class_type;
signal i_decode: i_decoded_type;
signal exestate: executionStates;
--signal localpc: std_logic_vector(31 downto 0):="00000000000000000000000000000000";
begin
Reg: RegFile port map(r1reg,r2reg,r1out,r2out,wadreg,wereg,wdata,PCdin,PCout,PCwereg,clk,ctrstate,i_decode);
Al: ALU  port map(i_decode,r1alu,r2alu,routalu,flags,fen,cen,clk,ctrstate,instruction);
cs: controlstate port map(clk,ld_bit,i_decode,instr_class,ctrstate,cen);
es: execution_state port map(clk,step,go,instr,ctrstate);
ram: dist_mem_gen_1 port map(aram,ramd,clk,ramwe,ramspo);
rom: dist_mem_gen_0 port map(arom,instruction);
Ins_decoder: instruction_Incoder port map(clk,instruction,i_decode,instr_class);

--cen for pc
cen<='1' when go1='1' or instr1='1' or step1='1' else
    '0' ;
--reg and pc sorted
PCdin<=routalu when ctrstate=fetch or ctrstate=brn else
    "00000000000000000000000000000000" ;
PCwereg<='1' when (ctrstate=fetch or ctrstate=brn) and cen='1' else
        '0' ;
r1reg<=instruction(19 downto 16) ;
r2reg<=instruction(3 downto 0) when instr_class=DP else
    instruction(15 downto 12) ;
wereg<='1' when ctrstate=res2RF or ctrstate=mem2RF else
    '0' ;
wdata<=routalu when ctrstate=res2RF else
        ramspo when ctrstate=mem2RF else
        "00000000000000000000000000000000"  ;
wadreg<=instruction(15 downto 12) ;
--alu
r1alu<=PCout when ctrstate =fetch or ctrstate=brn else
       r1out ;
r2alu<=r2out when ctrstate=arith or ctrstate=res2RF else
    "00000000000000000000000000000100" when ctrstate=fetch else
    "00000000000000000000" & instruction(11 downto 0) when ctrstate=addr or ctrstate=mem_wr or ctrstate=mem_rd or ctrstate=mem2RF else
    std_logic_vector(resize(4*unsigned(instruction(23 downto 0)), 32)) when ctrstate=brn and (instruction(31 downto 28)="1110" or (instruction(31 downto 28)="0000" and flags='1') or (instruction(31 downto 28)="0001" and flags='0') ) else 
    "00000000000000000000000000000000"  ;
fen<='1' when ctrstate=arith else
 '0' ;
 --rom
 arom<=PCout(9 downto 2) ;
 --ram
 aram<=routalu(9 downto 2) when instr_class=DT else
    "00000000" ;
ramd<=routalu ;
ramwe<='1' when ctrstate<=mem_wr else
        '0' ;
--debounce to be done
step1<=step ;
go1<=go ;
instr1<=instr ;
--control state
ld_bit<='1' when i_decode=ldr else
    '0' ;
end Behavioral;

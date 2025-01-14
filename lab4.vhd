----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/25/2019 01:29:46 PM
-- Design Name: 
-- Module Name: alu - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity alu is
    Port ( clock : in STD_LOGIC;
            reset : in std_logic;
            ins : in std_logic_vector(31 downto 0);
            ind : in std_logic_vector(31 downto 0);
            adim : out std_logic_vector(31 downto 0);
            addm : out std_logic_vector(31 downto 0);
            wd :out std_logic_vector(31 downto 0);
            en : out std_logic );
end alu;

architecture Behavioral of alu is
signal r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,rn,rd,op2,rm,rs,pcoffset,output,outputdelay,addmdelay : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
signal offset : std_logic_vector(23 downto 0);
signal z: std_logic;
signal regis: std_logic_vector(3 downto 0):= "0000";
type instr_class_type is (DP, DT, branch, unknown);
type i_decoded_type is (add,sub,cmp,mov,ldr,str,beq,bne,b,unknown);
signal instr_class : instr_class_type;
signal i_decoded : i_decoded_type;
signal cond : std_logic_vector (3 downto 0);
signal F_field : std_logic_vector (1 downto 0);
signal I_bit : std_logic;
signal shift_spec : std_logic_vector (7 downto 0);
signal k : integer;
signal ztemp:integer;
signal writeen:std_logic:= '0';
signal regchange:std_logic:='0' ;
begin
cond <= ins(31 downto 28);
F_field <= ins(27 downto 26);
I_bit <= ins(25);
shift_spec <= ins (11 downto 4);
instr_class<= DP when F_field="00" else
              DT when F_field="01" else
              branch when F_field="10" else
              unknown;
i_decoded<= add when instr_class=DP and ins(24 downto 21)="0100" else
            sub when instr_class=DP and ins(24 downto 21)="0010" else
            mov when instr_class=DP and ins(24 downto 21)="1101" else
            cmp when instr_class=DP and ins(24 downto 21)="1010" else
            ldr when instr_class=DT and ins(20)='1' else
            str when instr_class=DT and ins(20)='0' else
            beq when instr_class=branch and cond="0000" else
            bne when instr_class=branch and cond="0001" else
            b when instr_class=branch and cond="1110" else
            unknown;       
--k<=
--op2(31 downto 0) <=  
rn<= r0 when ins(19 downto 16)="0000" else
     r1 when ins(19 downto 16)="0001" else
     r2 when ins(19 downto 16)="0010" else
     r3 when ins(19 downto 16)="0011" else
     r4 when ins(19 downto 16)="0100" else
     r5 when ins(19 downto 16)="0101" else
     r6 when ins(19 downto 16)="0110" else
     r7 when ins(19 downto 16)="0111" else
     r8 when ins(19 downto 16)="1000" else
          r9 when ins(19 downto 16)="1001" else
          r10 when ins(19 downto 16)="1010" else
          r11 when ins(19 downto 16)="1011" else
          r12 when ins(19 downto 16)="1100" else
          r13 when ins(19 downto 16)="1101" else
          r14 when ins(19 downto 16)="1110" else
          r15 when ins(19 downto 16)="1111" else
          "00000000000000000000000000000000" ;
op2<="000000000000000000000000" & ins(7 downto 0) when ins(25)='1' else
	r0 when ins(3 downto 0)="0000" and ins(25)='0' else
     r1 when ins(3 downto 0)="0001" and ins(25)='0' else
     r2 when ins(3 downto 0)="0010" and ins(25)='0' else
     r3 when ins(3 downto 0)="0011" and ins(25)='0' else
     r4 when ins(3 downto 0)="0100" and ins(25)='0' else
     r5 when ins(3 downto 0)="0101" and ins(25)='0' else
     r6 when ins(3 downto 0)="0110" and ins(25)='0' else
     r7 when ins(3 downto 0)="0111" and ins(25)='0' else
     r8 when ins(3 downto 0)="1000" and ins(25)='0' else
		  r9 when ins(3 downto 0)="1001" and ins(25)='0' else
          r10 when ins(3 downto 0)="1010" and ins(25)='0' else
          r11 when ins(3 downto 0)="1011" and ins(25)='0' else
          r12 when ins(3 downto 0)="1100" and ins(25)='0' else
          r13 when ins(3 downto 0)="1101" and ins(25)='0' else
          r14 when ins(3 downto 0)="1110" and ins(25)='0' else
          r15 when ins(3 downto 0)="1111" and ins(25)='0' else
          "00000000000000000000000000000000" ;
	
output<= std_logic_vector(signed(rn) + signed(op2)) when i_decoded=add else
         std_logic_vector(signed(rn) - signed(op2)) when i_decoded=sub else
         op2 when i_decoded=mov else
         std_logic_vector(signed(rn) - signed(op2)) when i_decoded=cmp else
         ind when i_decoded=ldr else
         r0 when ins(15 downto 12)="0000" and i_decoded=str else
                        r1 when ins(15 downto 12)="0001" and i_decoded=str else
                        r2 when ins(15 downto 12)="0010" and i_decoded=str else
                        r3 when ins(15 downto 12)="0011" and i_decoded=str else
                        r4 when ins(15 downto 12)="0100" and i_decoded=str else
                        r5 when ins(15 downto 12)="0101" and i_decoded=str else
                        r6 when ins(15 downto 12)="0110" and i_decoded=str else
                        r7 when ins(15 downto 12)="0111" and i_decoded=str else
                        r8 when ins(15 downto 12)="1000" and i_decoded=str else
                             r9 when ins(15 downto 12)="1001" and i_decoded=str else
                             r10 when ins(15 downto 12)="1010" and i_decoded=str else
                             r11 when ins(15 downto 12)="1011" and i_decoded=str else
                             r12 when ins(15 downto 12)="1100" and i_decoded=str else
                             r13 when ins(15 downto 12)="1101" and i_decoded=str else
                             r14 when ins(15 downto 12)="1110" and i_decoded=str else
                             r15 when ins(15 downto 12)="1111" and i_decoded=str else
							"00000000000000000000000000000000" ;

--r15<= rd when ins(15 downto 12)="1111" ;

addm<=std_logic_vector(signed(rn) + signed(ins(11 downto 0))) when instr_class=DT and ins(23)='1' else
		std_logic_vector(signed(rn) - signed(ins(11 downto 0))) when instr_class=DT and ins(23)='0' ;
wd<=output when writeen='1' else
	"00000000000000000000000000000000" ;
en<=writeen;

writeen<= '1' when ins(20)='0' and instr_class=DT else
            '0';

r0<= rd when regis="0000" and regchange='1';
    r1<= rd when regis="0001" and regchange='1';
    r2<= rd when regis="0010" and regchange='1';
    r3<= rd when regis="0011" and regchange='1';
    r4<= rd when regis="0100" and regchange='1';
    r5<= rd when regis="0101" and regchange='1';
    r6<= rd when regis="0110" and regchange='1';
    r7<= rd when regis="0111" and regchange='1';
    r8<= rd when regis="1000" and regchange='1';
    r9<= rd when regis="1001" and regchange='1';
    r10<= rd when regis="1010" and regchange='1';
    r11<= rd when regis="1011" and regchange='1';
    r12<= rd when regis="1100" and regchange='1';
    r13<= rd when regis="1101" and regchange='1';
    r14<= rd when regis="1110" and regchange='1';

offset<= ins(23 downto 0);
pcoffset <= std_logic_vector(resize(signed(offset(23 downto 0)&"00"), pcoffset'length));
ztemp<=to_integer(signed(rn) - signed(op2));
adim<=r15 ;
process(clock)
begin 
if(rising_edge(clock)) then
    outputdelay<=output;
    regis<=ins(15 downto 12); 
    if ins(26)=ins(20) then regchange<='1';
    else regchange<='0';
    end if;
	if instr_class=DP and ins(20)='0' then
		rd<=output;
		r15<=std_logic_vector(signed(r15) +4) ;
	elsif instr_class=DP and ins(20)='1' then
		if ztemp=0 then z<='1' ;
		else z<='0';
		end if;
		r15<=std_logic_vector(signed(r15) +4) ;
	elsif instr_class=DT then
		if ins(20)/='0' then 
			rd<=output ;
		end if;
		r15<=std_logic_vector(signed(r15) +4) ;
	elsif instr_class=branch then
	   if cond="0000" and z='0' then r15<=std_logic_vector(signed(r15) +4) ;
	   elsif cond="0001" and z='1' then r15<=std_logic_vector(signed(r15) +4) ;
	   else r15<=std_logic_vector(signed(r15) + signed(pcoffset)+8) ;
	   end if ;
	end if;
end if ;
end process ;
end Behavioral;

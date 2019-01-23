.equ SWI_Exit, 0x11
.text
mov  r1, #0
mov r0, #0
mov r8, #10
ldr  r4, =myExp
ldrb r5,[r4,#0]
bl Expression
b ends


Expression: mov r3, #0 
STMFD sp!, {lr}
bl term
mov r3,r6 
addition: ldrb r5,[r4,#0]
cmp r5,#43
bne multiplication
add r4,r4,#1
bl term
add r3,r3,r6
ldrb r5,[r4,#0]
b addition

multiplication: cmp r5,#42
bne subtraction
add r4,r4,#1
bl term
mul r3,r6,r3
ldrb r5,[r4,#0]
b addition

subtraction: cmp r5,#45
bne een
add r4,r4,#1
bl term
sub r3,r3,r6
ldrb r5,[r4,#0]
b addition

een: LDMFD sp!,{lr}
mov pc,lr


term: 	mov r6,#0
ldrb r5,[r4,#0]
cmp r5,#40
bne t1
add r4,r4, #1
STMFD sp!, {r3,lr}	
bl Expression 
mov r6,r3	
LDMFD sp!, {r3,lr}
add r4,r4,#1
b t2
t1: mov r12,lr 
bl constant
mov lr,r12
t2: mov pc,lr
 
 
constant: mov r9,#0
ldrb r5,[r4,#0]
loop: cmp r5,#48
blt cen 
mul r9,r8,r9
sub r5,r5,#48
add r9,r9,r5
add r4,r4,#1
ldrb r5,[r4,#0]
b loop
cen: mov r6,r9 
mov pc,lr


ends: 

swi   SWI_Exit
.data
myExp: .asciz "-(-1-1)"
.end

.equ SWI_Exit, 0x11
.extern expr, prints, fgets, itoa
.text
mov r3, #10
mov r5, #0
mov r2,#0
mov r1, #400
ldr r0, =AA
bl fgets
mov r4,r0
ldrb r6, [r4,r5]
bl expr
ldr r1, =BB
bl itoa
bl prints

 swi SWI_Exit
 .data
AA: .space 400
BB: .space 10
.end

.equ SWI_Exit, 0x11
.text
mov r3, #10
ldr r4, =AA
mov r5, #0
ldrb r6, [r4,r5]
bl expr

@consTail function with parameter in r1 and return in r0, pc stored in r2
cnsTail:
push {lr}
ldrb r6,[r4,r5]
cmp r6,#0x30
blt consneg
cmp r6,#0x39
bgt consneg
mul r1,r1,r3
sub r6,r6,#48
add r1,r1,r6
add r5,r5,#1
bl cnsTail
pop {pc}
@another return statement of consTail
consneg: mov r0 , r1
pop {pc}

@function constant with result in r0(as result of constail is in r0) 
cons: 
push {lr}
ldrb r6,[r4,r5]
sub r1, r6,#48
add r5,#1
bl cnsTail
pop {pc}

term:
push {lr}
ldrb r6,[r4,r5]
cmp r6 , #0x28
bne cnstrm
add r5,r5,#1
bl expr
add r5,r5,#1
pop {pc}
cnstrm: bl cons
pop {pc}

expTail:
push {lr}
ldrb r6, [r4,r5]
cmp r6, #0x2B
bne subt
add r5,r5,#1
push {r1}
bl term
pop {r1}
add r1,r1,r0
bl expTail

subt:
cmp r6, #0x2D
bne mult
add r5,r5,#1
push {r1}
bl term
pop {r1}
sub r1,r1,r0
bl expTail

mult:
cmp r6, #0x2A
bne none
add r5,r5,#1
push {r1}
bl term
pop {r1}
mul r2,r1,r0
mov r1,r2
bl expTail

none:
 mov r0,r1
pop {pc}

expr:
push {lr}
bl term
mov r1,r0
bl expTail
pop {pc}

 swi SWI_Exit
 .data
AA: .asciz "(5+(2*3)+((6+2)*(7+3)))"
.end

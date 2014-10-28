.text
.align 2
.global fib
.type fib, %function
fib:
stmfd sp!, {r4, lr}
sub sp, sp, #8
str r0, [sp, #4]
ldr r3, [sp, #4]
cmp r3, #1
bhi .L2
ldr r3, [sp, #4]
str r3, [sp, #0]
b .L4
.L2:
ldr r3, [sp, #4]
sub r3, r3, #1
mov r0, r3
bl fib
mov r4, r0
ldr r3, [sp, #4]
sub r3, r3, #2
mov r0, r3
bl fib
mov r3, r0
add r4, r4, r3
str r4, [sp, #0]
.L4:
ldr r3, [sp, #0]
mov r0, r3
add sp, sp, #8
ldmfd sp!, {r4, lr}
bx lr
.size fib, .-fib

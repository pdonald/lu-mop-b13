.text
.align   2
.global  matmul
.type    matmul, %function

@ r0 = w1
@ r1 = h1
@ r2 = w2
@ r3 = i
@ r4 = j
@ r5 = k
@ r6 = sum

matmul:
  mov r3, r1, #-1  @ i = h1-1

i_loop:
  mov r4, r2, #-1  @ j = w2-1

j_loop:
  mov r5, r2, #-1  @ k = w1-1
  mov r6, #0       @ sum = 0

k_loop:
  @ sum += m1[i * w1 + k] * m2[k * w2 + j];

k_test:
  subs r5, r5, #1  @ k--
  bhi k_loop       @ k >= 0?

k_endloop:
  mul r7, r1       @ i * h1
  add r7, r4       @ i * h1 + j
  @ m3[i * h1 + j] = sum;

j_test:
  subs r4, r4, #1  @ j--
  bhi j_loop:      @ j >= 0?

j_endloop:
i_test:
  subs r3, r3, #1  @ i--
  bhi i_loop       @ i >= 0?

i_endloop:
  bx lr

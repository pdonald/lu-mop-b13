.text
.global matmul

matmul:
  push {r4,r5,r6,r7,r8,r9,r10}

  @ nomaina parametrus atpakaļ uz matmul(w1, h1, m1, w2, h2, m2, m3)
  mov r4, r0
  mov r0, r1        @ r0 = w1
  mov r1, r4        @ r1 = h1
  mov r4, r3        @ r4 = h2
  ldr r3, [sp, #28] @ r3 = w2  #28 = push
  
  @ r0 = w1 = h2
  @ r1 = h1 = sum
  @ r2 = m1         
  @ r3 = w2
  @ r4 = m2
  @ r5 = m3
  @ r6 = w1w2
  @ r7 = m1idx
  @ r8 = m2idx
  @ r9 = m3idx
  @ r10 = w1w2 - w2
  
  cmp r0, #0
  blt error @ w1 < 0
  cmp r1, #0
  blt error @ h1 < 0
  cmp r3, #0
  blt error @ w2 < 0
  cmp r4, #0
  blt error @ h2 < 0
  cmp r0, r4
  bne error @ w1 != h2
  
  mul r7, r1, r0    @ m1idx = h1 * w1
  mul r8, r4, r3    @ m1idx = h2 * w2  
  
  @ h1*w1 == 0 && h1 != w1
  cmp r7, #0        @ h1 * w1 == 0
  addne pc, pc, #4  @ goto after bne error
  cmpeq r0, r1      @ h1 == w1
  bne error         @ h1 != w1
  
  @ h2*w2 == 0 && h2 != w2
  cmp r8, #0        @ h2 * w2 == 0
  addne pc, pc, #4  @ goto after bne error
  cmpeq r4, r3      @ h2 == w2
  bne error         @ h2 != w2 
  
  sub r7, #1        @ m1idx = h1 * w1 - 1
  
  mul r9, r1, r3    @ m3idx = h1 * w2
  sub r9, #1        @ m3idx = h2 * w2 - 1
  
  mul r6, r0, r3    @ w1w2 = w1 * w2
  sub r6, #1        @ w1w2 = w1 * w2 - 1
  
  sub r10, r6, r3   @ w1w2 - w2
  
loop1:
  mov r8, r6        @ m2idx = w1w2
  
loop2:
  mov r1, #0        @ sum = 0

loop3:
  ldr r5, [r2, r7, lsl #2]  @ m1[m1idx]
  ldr r4, [sp, #32]         @ m2  #32 = push + 4
  ldr r4, [r4, r8, lsl #2]  @ m2[m2idx]
  mul r4, r5, r4            @ m1[m1idx] * m2[m2idx]
  add r1, r1, r4            @ sum += m1[m1idx] * m2[m2idx]
  
  sub r7, #1        @ m1idx--
  subs r8, r8, r3   @ m2idx -= w2
  
  bge loop3         @ m2idx >= 0
  
  ldr r4, [sp, #36]          @ m3  #36 = push + 8
  str r1, [r4, r9, lsl #2]   @ m3[m3idx] = sum
  
  sub r9, #1        @ m3idx--
  add r8, r8, r6    @ m2idx += w1w2
  
  cmp r8, r10       @ m2idx un w1w2 - w2
  addgt r7, r7, r0  @ if (m2idx > w1w2 - w2) m1idx += w1
  
  bgt loop2         @ m2idx > w1w2 - w2
  
  cmp r9, #0        @ m3idx
  bge loop1         @ m3idx >= 0
  
return:
  pop {r4,r5,r6,r7,r8,r9,r10}
  mov r0, #0
  bx lr

error:
  pop {r4,r5,r6,r7,r8,r9,r10}
  mov r0, #1
  bx lr

@ optimizēts variants:
@ reizināšana ir tikai sākumā
@ un pašu matricu vērtību reizināšana
@ indeksi masīvā netiek rēķināti ar reizināšanu
@
@ int m1idx = h1 * w1 - 1;
@ int m3idx = h1 * w2 - 1;
@ int w1w2 = w1 * w2 - 1;
@ int m2idx;
@ int sum;
@
@ do
@ {
@     m2idx = w1w2;
@
@     do
@     {
@         sum = 0;
@
@         do
@         {
@             sum += m1[m1idx] * m2[m2idx];
@             m1idx--;
@             m2idx -= w2;
@         }
@         while (m2idx >= 0);
@
@         m3[m3idx] = sum;
@
@         m3idx--;
@         m2idx += w1w2;
@         if (m2idx > w1w2 - w2) m1idx += w1;
@     }
@     while (m2idx > w1w2 - w2);
@ }
@ while (m3idx >= 0);

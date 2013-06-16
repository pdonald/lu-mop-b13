.text

.extern FrameBufferGetAddress
.extern FrameBufferGetWidth
.extern FrameBufferGetHeight

.global setPixColor
.global pixel
.global line
.global triangleFill
.global circle

.comm currentColor, 4, 4
currentColor_word: .word currentColor

setPixColor:
  ldr r1, [r0]               @ colorop
  ldr r2, currentColor_word  @ currentColor
  str r1, [r2]               @ currentColor = colorop
  bx lr

getPixelAddr:
  @ r0 = x
  @ r1 = y
  
  cmp r0, r0                @ x
  blt getPixelAddr_oob      @ x < 0
  cmp r1, r1                @ y
  blt getPixelAddr_oob      @ y < 0
  
  push {r4-r6}
  mov r4, r0                @ x
  mov r5, r1                @ y
  
  push {lr}
  bl FrameBufferGetWidth    @ r0 = width
  pop {lr}
  cmp r0, r4                @ width un x
  blt getPixelAddr_oob_pop  @ x >= width
  mov r6, r0                @ width
  
  push {lr}
  bl FrameBufferGetHeight   @ r0 = height
  pop {lr}
  cmp r0, r5                @ height un y
  blt getPixelAddr_oob_pop  @ y >= height
  
  push {lr}
  bl FrameBufferGetAddress  @ r0 = frameBuffer
  pop {lr}
  
  mul r1, r6, r5            @ index = width * y
  add r1, r1, r4            @ index = width * y + x
  add r0, r0, r1, lsl #2    @ frameBuffer[index]
  
  pop {r4-r6}
  bx lr

getPixelAddr_oob_pop:
  pop {r4-r6}

getPixelAddr_oob:
  mov r0, #-1
  bx lr

pixel:
  @ r0 = x
  @ r1 = y
  @ r2 = colorop
  
  push {r2,lr}
  bl getPixelAddr    @ r0 = frameBuffer[index]
  pop {r2,lr}
  cmp r0, #-1
  bxeq lr            @ out of bounds
  
  ldr r1, [r2]       @ colorop
  lsr r3, r1, #30    @ op
  
  cmp r3, #0         @ COPY
  beq pixel_end

  ldr r2, [r0]       @ prev color
  
  cmp r3, #1         @ AND
  andeq r1, r1, r2
  beq pixel_end
  
  cmp r3, #2         @ OR
  orreq r1, r1, r2
  beq pixel_end
  
  cmp r3, #3         @ XOR
  eoreq r1, r1, r2

pixel_end:    
  str r1, [r0]       @ frameBuffer[index] = colorop
  bx lr

line:
  @ r0 = x0
  @ r1 = y0
  @ r2 = x1
  @ r3 = y1
  
  push {r4-r8,r10,r12,lr}
  
  subs r4, r2, r0   @ dx = x1-x0
  mvnlt r4, r4      @ dx = abs(dx)
  addlt r4, r4, #1  @ dx = abs(dx)
  mov r6, #0        @ sx
  movgt r6, #1      @ sx
  movlt r6, #-1     @ sx
  
  subs r5, r3, r1   @ dy = y1-y0
  mvnlt r5, r5      @ dy = abs(dy)
  addlt r5, r5, #1  @ dy = abs(dy)
  movlt r7, #-1     @ sy, if y0 >= y1
  mov r7, #0        @ sy
  movgt r7, #1      @ sy
  movlt r7, #-1     @ sy
  
  sub r8, r4, r5    @ err = dx - dy
  
  ldr r10, currentColor_word  @ currentColor
  
line_loop:
  bl line_plot
  
  @ if (x0 == x1 && y0 == y1)
  cmp r0, r2
  cmpeq r1, r3
  beq line_done
  
  add r12, r8, r8    @ e2 = 2 * err

  cmn r12, r5        @ if (e2 > -dy)
  subgt r8, r8, r5   @ err -= dy
  addgt r0, r0, r6   @ x0 += sx
  
  @ if (x0 == x1 && y0 == y1)
  cmp r0, r2
  cmpeq r1, r3
  beq line_plot_and_finish
  
  cmp r12, r4       @ if e2 < dx
  addlt r8, r8, r4  @ err += dx
  addlt r1, r1, r7  @ y0 += sy

  b line_loop

line_plot:
  push {r0-r3,lr}
  mov r2, r10
  bl pixel
  pop {r0-r3,lr}
  bx lr
  
line_plot_and_finish:
  bl line_plot
  
line_done:
  pop {r4-r8,r10,r12,lr}
  bx lr

triangleFill:
  @ r0 = x1
  @ r1 = y1
  @ r2 = x2
  @ r3 = y2
  @ r4 = x3
  @ r5 = y3
  
  push {r4-r12}
  
  subs r4, r2, r0   @ dx1 = x2-x1
  mvnlt r4, r4      @ dx1 = abs(dx2)
  addlt r4, r4, #1  @ dx1 = abs(dx2)
  mov r6, #0        @ sx1
  movgt r6, #1      @ sx1
  movlt r6, #-1     @ sx1
  
  mov r12, r4       @ i = dx1
  
  subs r5, r3, r1   @ dy1 = y2-y1
  mvnlt r5, r5      @ dy1 = abs(dy1)
  addlt r5, r5, #1  @ dy1 = abs(dy1)
  mov r7, #0        @ sy1
  movgt r7, #1      @ sy1
  movlt r7, #-1     @ sy1
  
  add r8, r5, r5    @ e1 = 2 * dy1
  sub r8, r8, r4    @ e1 = 2 * dy1 - dx1
  
  @ if dy1 > dx1 then swap(dx1, dy1)
  cmp r5, r4
  movgt r10, r4
  movgt r4, r5
  movgt r5, r10
  movgt r10, #1
  movle r10, #0
  
  ldr r2, [sp, #36]  @ x3
  ldr r3, [sp, #40]  @ y3
  
  push {r4-r8,r10}  @ dx1, dy1, sx1, sy1, e1, changed1
  
  subs r4, r2, r0   @ dx2 = x3-x1
  mvnlt r4, r4      @ dx2 = abs(dx2)
  addlt r4, r4, #1  @ dx2 = abs(dx2)
  mov r6, #0        @ sx2
  movgt r6, #1      @ sx2
  movlt r6, #-1     @ sx2
  
  subs r5, r3, r1   @ dy2 = y3-y1
  mvnlt r5, r5      @ dy2 = abs(dy2)
  addlt r5, r5, #1  @ dy2 = abs(dy2)
  mov r7, #0        @ sy2
  movgt r7, #1      @ sy2
  movlt r7, #-1     @ sy2
  
  add r8, r5, r5    @ e2 = 2 * dy2
  sub r8, r8, r4    @ e2 = 2 * dy2 - dx2
  
  @ if dy2 > dx2 then swap(dx2, dy2)
  cmp r5, r4
  movgt r10, r4
  movgt r4, r5
  movgt r5, r10
  movgt r10, #1
  movle r10, #0
  
  push {r4-r8,r10}      @ dx2, dy2, sx2, sy2, e2, changed2
  
  mov r2, r0
  mov r3, r1
  
triangleFill_loop:
  push {r0-r3,lr}
  bl line
  pop {r0-r3,lr}
  
  @ 0 4 8 12 16 20       24 28 32 36 40 44
  ldr r4, [sp, #40]  @ e1   
  ldr r5, [sp, #44]  @ changed1
  cmp r5, #1
  ldreq r6, [sp, #32]  @ sx1
  ldrne r6, [sp, #36]  @ sy1
  ldr r7, [sp, #24]    @ dx1
  ldr r8, [sp, #28]    @ dy1
  
  cmp r4, #0
  blt triangleFill_while_e1_done

triangleFill_while_e1:
  cmp r5, #1
  addeq r0, r0, r6   @ x1 += sx1
  addne r1, r1, r6   @ y1 += sy1
  sub r4, r4, r7     @ e1 -= dx1
  subs r4, r4, r7    @ e1 -= 2*dx1
  bge triangleFill_while_e1

triangleFill_while_e1_done:
  cmp r5, #1
  addeq r1, r1, r6
  addne r0, r0, r6
  
  add r4, r4, r8     @ e1 += dy1
  add r4, r4, r8     @ e1 += 2*dy1
  str r4, [sp, #40]

  cmp r3, r1
  beq triangleFill_while_yy_done

  ldr r4, [sp, #16]   @ e2
  ldr r5, [sp, #20]   @ changed2
  cmp r4, #0
  ldreq r6, [sp, #8]  @ sx2
  ldrne r6, [sp, #12] @ sy2
  ldr r7, [sp, #0]    @ dx2
  ldr r8, [sp, #4]    @ dy2

triangleFill_while_yy:
  cmp r4, #0
  blt triangleFill_while_e2_done

triangleFill_while_e2:
  cmp r5, #1
  addeq r2, r2, r6   @ x2 += sx2
  addne r3, r3, r6   @ y2 += sy2
  sub r4, r4, r7     @ e2 -= dx2
  subs r4, r4, r7    @ e2 -= 2*dx2
  bge triangleFill_while_e2

triangleFill_while_e2_done:
  cmp r5, #1
  addeq r3, r3, r6
  addne r2, r2, r6
  
  add r4, r4, r8     @ e2 += dy2
  add r4, r4, r8     @ e2 += 2*dy2
  str r4, [sp, #40]
  
  cmp r3, r1
  bne triangleFill_while_yy

triangleFill_while_yy_done:  
  subs r12, r12, #1       @ i--
  bge triangleFill_loop   @ i >= 0
  
triangleFill_done:  
  pop {r4-r8,r10}
  pop {r4-r8,r10}
  
  pop {r4-r12}
  bx lr

circle:
  @ r0 = x0
  @ r1 = y0
  @ r2 = radius
  
  cmp r2, #0
  bxlt lr         @ radius < 0
  
  push {r4-r8,r10}
  
  mov r4, r2      @ x = radius
  mov r5, #0      @ y = 0
  mvn r6, r4      @ radiusError = ~x
  add r6, r6, #2  @ radiusError = -x + 1
  mov r7, r0      @ x0
  mov r8, r1      @ y0
  
  ldr r10, currentColor_word  @ currentColor

circle_loop:
  add r0, r4, r7  @ x + x0
  add r1, r5, r8  @ y + y0
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
  
  add r0, r5, r7  @ y + x0
  add r1, r4, r8  @ x + y0
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
  
  sub r0, r7, r4  @ x0 - x
  add r1, r5, r8  @ y + y0
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
  
  sub r0, r7, r5  @ x0 - y
  add r1, r4, r8  @ x + y0
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
  
  sub r0, r7, r4  @ x0 - x
  sub r1, r8, r5  @ y0 - y
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
  
  sub r0, r7, r5  @ x0 - y
  sub r1, r8, r4  @ y0 - x
  mov r2, r10
  push {lr}; bl pixel; pop {lr}

  add r0, r4, r7  @ x + x0
  sub r1, r8, r5  @ y0 - y
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
      
  add r0, r5, r7  @ y + x0
  sub r1, r8, r4  @ y0 - x
  mov r2, r10
  push {lr}; bl pixel; pop {lr}
  
  add r5, r5, #1   @ y++
  
  cmp r6, #0       @ radiusError
  add r6, r6, #1   @ radiusError += 1
  add r6, r6, r5   @ radiusError += 1+y
  add r6, r6, r5   @ radiusError += 1+y+y
  
  @ if radiusError >= 0
  subge r4, r4, #1  @ x--
  subge r6, r6, r4  @ raidusError += 1+y+y -x
  subge r6, r6, r4  @ raidusError += 1+y+y -x-x
  
  cmp r4, r5        @ x, y
  bge circle_loop   @ x >= y

  pop {r4-r7,r8,r10}
  bx lr

.data
format: .asciz "%d\n"
format_a: .word format


  
@  push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
@  @mov r4, r1
@  @mov r5, r5
@  ldr r6, =format_a
@  ldr r0, [r6]
@  mov r1, r4
@  bl printf
@  pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}

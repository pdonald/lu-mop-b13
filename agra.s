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

  cmp r0, r0             @ x
  blt getPixelAddr_oob   @ x < 0
  cmp r1, r1             @ y
  blt getPixelAddr_oob   @ y < 0
  
  push {r0,r1,lr}
  bl FrameBufferGetWidth    @ r0 = width
  mov r2, r0                @ width
  pop {r0,r1,lr}
  cmp r2, r0                @ width un x
  blt getPixelAddr_oob      @ x >= width
  
  push {r0,r1,r2,lr}
  bl FrameBufferGetHeight   @ r0 = height
  mov r3, r0                @ height
  pop {r0,r1,r2,lr}
  cmp r3, r1                @ height un y
  blt getPixelAddr_oob      @ y >= height
  
  push {r0,r1,r2,lr}
  bl FrameBufferGetAddress  @ r0 = frameBuffer
  mov r4, r0                @ frameBuffer
  pop {r0,r1,r2,lr}
  
  mul r5, r2, r1            @ index = width * y
  add r5, r5, r0            @ index = width * y + x
  
  add r0, r4, r5, lsl #2    @ frameBuffer[index]
  bx lr

getPixelAddr_oob:
  mov r0, #-1
  bx lr
 
pixel: @TODO: ņemt vērā op
  @ r0 = x
  @ r1 = y
  @ r2 = colorop
  
  push {r2,lr}
  bl getPixelAddr    @ r0 = frameBuffer[index]
  pop {r2,lr}
  
  cmp r0, #-1
  bxeq lr            @ out of bounds
  
  ldr r1, [r2]       @ colorop
  str r1, [r0]       @ frameBuffer[index] = colorop
  bx lr

line:
  @ r0 = x0
  @ r1 = y0
  @ r2 = x1
  @ r3 = y1
  
  @ 4 params + 5 locals + currentColor = 10
  @ r4, r5, r6, r7,  r8, r10, r11
  
  push {lr}
  
  mov r6, #1       @ sx
  subs r4, r2, r0   @ dx = x1-x0
  mvnlt r4, r4      @ dx = abs(dx)
  addlt r4, r4, #1  @ dx = abs(dx)
  movlt r6, #-1     @ sx, if x0 >= x1
  
  mov r7, #1        @ sy
  subs r5, r3, r1   @ dy = y1-y0
  mvnlt r5, r5      @ dy = abs(dy)
  addlt r5, r5, #1  @ dy = abs(dy)
  movlt r7, #-1     @ sy, if y0 >= y1
  
  sub r8, r4, r5    @ err = dx - dy
  
  ldr r10, currentColor_word  @ currentColor
  
line_loop:
  bl line_plot
  
  @ if (x0 == x1 && y0 == y1)
  cmp r0, r2
  cmpeq r1, r3
  beq line_done
  
  add r12, r8, r8    @ e2 = 2 * err
  
  push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
  mov r4, r0
  mov r5, r5
  ldr r6, =format_a
  ldr r0, [r6]
  mov r1, r4
  @bl printf
  pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
  
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
  push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
  mov r2, r10
  bl pixel
  pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
  bx lr
  
line_plot_and_finish:
  bl line_plot
  
line_done:
  pop {lr}
  bx lr

triangleFill:
  push {r0,r1,r2,r3,lr}
  bl line
  pop {r0,r1,r2,r3,lr}
  
  ldr r4, [sp]
  ldr r5, [sp, #4]
  
  push {r0,r1,r2,r3,r4,r5,lr}
  mov r2, r4
  mov r3, r5
  bl line
  pop {r0,r1,r2,r3,r4,r5,lr}
  
  push {r0,r1,r2,r3,r4,r5,lr}
  mov r0, r4
  mov r1, r5
  bl line
  pop {r0,r1,r2,r3,r4,r5,lr}
  
  add r6, r0, r2   @ x1 + x2
  add r6, r6, r4   @ x1 + x2 + x3
  add r7, r1, r3   @ y1 + y2
  add r7, r7, r5   @ y1 + y2 + y3
  ldr r8, =0x55555556
  umull r10, r6, r6, r8  @ r6 = (x1+x2+x3)/3
  umull r10, r7, r7, r8  @ r7 = (y1+y2+y3)/3
  
  @push {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  @mov r0, r6
  @mov r1, r7
  @ldr r2, currentColor_word
  @bl pixel
  @pop {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  
  push {lr}
  mov r0, r6
  mov r1, r7
  ldr r2, currentColor_word
  bl floodfill
  pop {lr}
  
  bx lr

floodfill:
  @ r0 = x
  @ r1 = y
  @ r2 = target color

  push {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  bl FrameBufferGetWidth    @ r0 = width
  mov r4, r0
  pop {r0,r1,r2,r3,r4,r5,r6,r7,lr}
 
  push {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  bl FrameBufferGetAddress  @ r0 = frameBuffer
  mov r5, r0
  pop {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  
  mul r6, r4, r1          @ index = width * y
  add r6, r6, r0          @ index = width * y + x
  add r7, r5, r6, lsl #2  @ frameBuffer[index]
  
  @ TODO: kas ir, ja operācija?
  cmp r2, r7  @ target color, node color
  bxeq lr
  
  push {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  bl pixel
  pop {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  
  push {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  add r1, r1, #1  @ x, y+1
  bl floodfill
  pop {r0,r1,r2,r3,r4,r5,r6,r7,lr}
  
  bx lr
  

circle:
  @ r0 = x0
  @ r1 = y0
  @ r2 = radius
  
  cmp r2, #0
  bxlt lr     @ radius < 0
  
  push {lr}
  
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
  bl circle_plot
  
  add r0, r5, r7  @ y + x0
  add r1, r4, r8  @ x + y0
  bl circle_plot
  
  sub r0, r7, r4  @ x0 - x
  add r1, r5, r8  @ y + y0
  bl circle_plot
  
  sub r0, r7, r5  @ x0 - y
  add r1, r4, r8  @ x + y0
  bl circle_plot
  
  sub r0, r7, r4  @ x0 - x
  sub r1, r8, r5  @ y0 - y
  bl circle_plot
  
  sub r0, r7, r5  @ x0 - y
  sub r1, r8, r4  @ y0 - x
  bl circle_plot

  add r0, r4, r7  @ x + x0
  sub r1, r8, r5  @ y0 - y
  bl circle_plot
      
  add r0, r5, r7  @ y + x0
  sub r1, r8, r4  @ y0 - x
  bl circle_plot
  
  add r5, r5, #1   @ y++
  
  cmp r6, #0       @ radiusError
  add r6, r6, #1   @ radiusError += 1
  add r6, r6, r5   @ radiusError += 1+y
  add r6, r6, r5   @ radiusError += 1+y+y
  
  @ if radiusError >= 0
  subge r4, r4, #1  @ x--
  subge r6, r6, r4  @ raidusError += 1+y+y -x
  subge r6, r6, r4  @ raidusError += 1+y+y -x-x
  
  cmp r4, r5 @ x, y
  bge circle_loop

circle_done:
  pop {lr}
  bx lr

circle_plot:
  push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
  mov r2, r10
  bl pixel
  pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
  bx lr

.data
format: .asciz "%u\n"

format_a: .word format

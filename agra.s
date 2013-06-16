@ todo push

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
  
  push {r4,r5,r6}
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
  
  pop {r4,r5,r6}
  bx lr

getPixelAddr_oob_pop:
  pop {r4,r5,r6}

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
  
  push {r4,r5,r6,r7,r8,r10,r12,lr}
  
  mov r6, #1        @ sx
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
  push {r0,r1,r2,r3,lr}
  mov r2, r10
  bl pixel
  pop {r0,r1,r2,r3,lr}
  bx lr
  
line_plot_and_finish:
  bl line_plot
  
line_done:
  pop {r4,r5,r6,r7,r8,r10,r12,lr}
  bx lr

triangleFill:
  @ r0 = x1
  @ r1 = y1
  @ r2 = x2
  @ r3 = y2
  @ r4 = x3
  @ r5 = y3

  @ line (x1,y1) => (x2,y2)
  push {r0,r1,r2,r3,lr}
  bl line
  pop {r0,r1,r2,r3,lr}
  
  ldr r4, [sp]      @ x3
  ldr r5, [sp, #4]  @ y3
  
  @ line (x1,y1) => (x3,y3)
  push {r0,r1,r2,r3,r4,r5,lr}
  mov r2, r4
  mov r3, r5
  bl line
  pop {r0,r1,r2,r3,r4,r5,lr}
  
  @ line (x3,y3) => (x2,y2)
  push {r0,r1,r2,r3,r4,r5,lr}
  mov r0, r4
  mov r1, r5
  bl line
  pop {r0,r1,r2,r3,r4,r5,lr}
  
  @ triangle center
  add r6, r0, r2          @ x1 + x2
  add r6, r6, r4          @ x1 + x2 + x3
  add r7, r1, r3          @ y1 + y2
  add r7, r7, r5          @ y1 + y2 + y3
  ldr r8, =0x55555556
  umull r10, r0, r6, r8   @ r0 = (x1+x2+x3)/3
  umull r10, r1, r7, r8   @ r1 = (y1+y2+y3)/3
  
  @ flood fill from the center
  push {lr}
  ldr r2, currentColor_word
  bl floodfill
  pop {lr}
  
  bx lr

floodfill:
  @ r0 = x
  @ r1 = y
  @ r2 = target color
  push {r0,r1,r2,lr}
  bl getPixelAddr     @ r0 = frameBuffer[index]
  mov r3, r0          @ frameBuffer[index] 
  pop {r0,r1,r2,lr}
  cmp r3, #-1
  bxeq lr             @ out of bounds
  
  @ TODO: kas ir, ja operācija?
  ldr r4, [r2]        @ target color
  ldr r5, [r3]        @ node color
  cmp r5, r4
  bxeq lr
  
  push {r0,r1,r2,lr}
  bl pixel
  pop {r0,r1,r2}
  
  push {r0,r1}
  add r1, r1, #1  @ x, y+1
  bl floodfill
  pop {r0,r1}
  
  push {r0,r1}
  add r0, r0, #1  @ x+1, y
  bl floodfill
  pop {r0,r1}
  
  push {r0,r1}
  sub r0, r0, #1  @ x-1, y
  bl floodfill
  pop {r0,r1}
  
  sub r1, r1, #1  @ x, y-1
  bl floodfill
  
  pop {lr}
  bx lr

circle:
  @ r0 = x0
  @ r1 = y0
  @ r2 = radius
  
  cmp r2, #0
  bxlt lr         @ radius < 0
  
  push {r4,r5,r6,r7,r8,r10}
  
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

  pop {r4,r5,r6,r7,r8,r10}
  bx lr

.data
format: .asciz "%x\n"
format_a: .word format


  
@  push {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}
@  @mov r4, r1
@  @mov r5, r5
@  ldr r6, =format_a
@  ldr r0, [r6]
@  mov r1, r4
@  bl printf
@  pop {r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,lr}

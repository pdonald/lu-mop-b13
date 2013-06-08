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
 
pixel:
  cmp r0, r0  @ x
  bxlt lr     @ x < 0
  cmp r1, r1  @ y
  bxlt lr     @ y < 0
  
  mov r4, lr  @ lr
  mov r5, r0  @ x
  mov r6, r1  @ y
  mov r7, r2  @ colorop
  
  bl FrameBufferGetWidth    @ r0 = width
  cmp r0, r5                @ width un x
  bxlt r4                   @ x >= width
  mov r8, r0                @ width
  
  bl FrameBufferGetHeight   @ r0 = height
  cmp r0, r6                @ height un y
  bxlt r4                   @ y >= height
  
  bl FrameBufferGetAddress  @ r0 = frameBuffer
  mul r6, r8, r6            @ index = width * y
  add r6, r6, r5            @ index = width * y + x
  
  add r0, r0, r6, lsl #2    @ frameBuffer[index]
  ldr r1, [r7]              @ colorop
  str r1, [r0]              @ frameBuffer[index] = colorop
  
  @TODO: ņemt vērā op
  
  bx r4

line:
  bx lr

triangleFill:
  bx lr

circle:
  bx lr

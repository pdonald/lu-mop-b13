.text
.align   2
.global  asum
.type    asum, %function

asum:
  @ n atrodas r0
  @ sum atrodas r1
  mov r1, #0       @ sum = 0

loop:
  adds r1, r1, r0  @ sum += n
  bhs overflow     @ sum > MAX?

test:
  subs r0, r0, #1  @ n--
  bhi loop         @ n > 0?

endloop:
  mov r0, r1       @ r0 = sum
  bx lr

overflow:
  mov r0, #0
  bx lr

.size asum, .-asum

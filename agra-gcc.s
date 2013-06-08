	.arch armv5t
	.fpu softvfp
	.eabi_attribute 20, 1
	.eabi_attribute 21, 1
	.eabi_attribute 23, 3
	.eabi_attribute 24, 1
	.eabi_attribute 25, 1
	.eabi_attribute 26, 2
	.eabi_attribute 30, 6
	.eabi_attribute 34, 0
	.eabi_attribute 18, 4
	.file	"agra.c"
	.comm	currentColor,4,4
	.text
	.align	2
	.global	pixel
	.type	pixel, %function
pixel:
	@ args = 0, pretend = 0, frame = 24
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #24
	str	r0, [fp, #-16]
	str	r1, [fp, #-20]
	str	r2, [fp, #-24]
	bl	FrameBufferGetAddress
	str	r0, [fp, #-12]
	mov	r3, #1
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-8]
	mov	r3, r3, asl #2
	ldr	r2, [fp, #-12]
	add	r2, r2, r3
	ldr	r3, [fp, #-24]
	ldrh	r3, [r3, #0]	@ movhi
	mov	r3, r3, asl #6
	mov	r3, r3, asl #16
	mov	r3, r3, asr #16
	mov	r3, r3, asr #6
	mov	r3, r3, asl #16
	mov	r1, r3, lsr #16
	ldr	r3, [r2, #0]
	mov	r1, r1, asl #22
	mov	r3, r3, lsr #10
	orr	r3, r3, r1
	mov	r3, r3, ror #22
	str	r3, [r2, #0]
	ldr	r3, [fp, #-8]
	mov	r3, r3, asl #2
	ldr	r2, [fp, #-12]
	add	r0, r2, r3
	ldr	r3, [fp, #-24]
	ldr	r3, [r3, #0]
	mov	r3, r3, asl #12
	mov	r3, r3, asr #22
	mov	r3, r3, asl #16
	mov	r1, r3, lsr #16
	ldr	r2, [r0, #0]
	ldr	r3, .L2
	and	r1, r1, r3
	mov	r3, r3, asl #10
	bic	r3, r2, r3
	mov	r1, r1, asl #10
	orr	r2, r1, r3
	str	r2, [r0, #0]
	ldr	r3, [fp, #-8]
	mov	r3, r3, asl #2
	ldr	r2, [fp, #-12]
	add	r0, r2, r3
	ldr	r3, [fp, #-24]
	ldrh	r3, [r3, #2]	@ movhi
	mov	r3, r3, asl #2
	mov	r3, r3, asl #16
	mov	r3, r3, asr #16
	mov	r3, r3, asr #6
	mov	r3, r3, asl #16
	mov	r1, r3, lsr #16
	ldr	r2, [r0, #0]
	ldr	r3, .L2
	and	r1, r1, r3
	mov	r3, r3, asl #20
	bic	r3, r2, r3
	mov	r1, r1, asl #20
	orr	r2, r1, r3
	str	r2, [r0, #0]
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L3:
	.align	2
.L2:
	.word	1023
	.size	pixel, .-pixel
	.align	2
	.global	setPixColor
	.type	setPixColor, %function
setPixColor:
	@ args = 0, pretend = 0, frame = 8
	@ frame_needed = 1, uses_anonymous_args = 0
	@ link register save eliminated.
	str	fp, [sp, #-4]!
	add	fp, sp, #0
	sub	sp, sp, #12
	str	r0, [fp, #-8]
	ldr	r3, .L5
	ldr	r2, [fp, #-8]
	str	r2, [r3, #0]
	add	sp, fp, #0
	ldmfd	sp!, {fp}
	bx	lr
.L6:
	.align	2
.L5:
	.word	currentColor
	.size	setPixColor, .-setPixColor
	.align	2
	.global	line
	.type	line, %function
line:
	@ args = 0, pretend = 0, frame = 40
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #40
	str	r0, [fp, #-32]
	str	r1, [fp, #-36]
	str	r2, [fp, #-40]
	str	r3, [fp, #-44]
	ldr	r2, [fp, #-40]
	ldr	r3, [fp, #-32]
	rsb	r3, r3, r2
	cmp	r3, #0
	rsblt	r3, r3, #0
	str	r3, [fp, #-24]
	ldr	r2, [fp, #-44]
	ldr	r3, [fp, #-36]
	rsb	r3, r3, r2
	cmp	r3, #0
	rsblt	r3, r3, #0
	str	r3, [fp, #-20]
	ldr	r2, [fp, #-32]
	ldr	r3, [fp, #-40]
	cmp	r2, r3
	bge	.L8
	mov	r3, #1
	b	.L9
.L8:
	mvn	r3, #0
.L9:
	str	r3, [fp, #-16]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-44]
	cmp	r2, r3
	bge	.L10
	mov	r3, #1
	b	.L11
.L10:
	mvn	r3, #0
.L11:
	str	r3, [fp, #-12]
	ldr	r2, [fp, #-24]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, r2
	str	r3, [fp, #-28]
	b	.L17
.L19:
	mov	r0, r0	@ nop
.L17:
	ldr	r3, .L20
	ldr	r3, [r3, #0]
	ldr	r0, [fp, #-32]
	ldr	r1, [fp, #-36]
	mov	r2, r3
	bl	pixel
	ldr	r2, [fp, #-32]
	ldr	r3, [fp, #-40]
	cmp	r2, r3
	bne	.L12
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-44]
	cmp	r2, r3
	beq	.L18
.L12:
	ldr	r3, [fp, #-28]
	mov	r3, r3, asl #1
	str	r3, [fp, #-8]
	ldr	r3, [fp, #-20]
	rsb	r2, r3, #0
	ldr	r3, [fp, #-8]
	cmp	r2, r3
	bge	.L14
	ldr	r2, [fp, #-28]
	ldr	r3, [fp, #-20]
	rsb	r3, r3, r2
	str	r3, [fp, #-28]
	ldr	r2, [fp, #-32]
	ldr	r3, [fp, #-16]
	add	r3, r2, r3
	str	r3, [fp, #-32]
.L14:
	ldr	r2, [fp, #-32]
	ldr	r3, [fp, #-40]
	cmp	r2, r3
	bne	.L15
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-44]
	cmp	r2, r3
	bne	.L15
	ldr	r3, .L20
	ldr	r3, [r3, #0]
	ldr	r0, [fp, #-32]
	ldr	r1, [fp, #-36]
	mov	r2, r3
	bl	pixel
	mov	r0, r0	@ nop
	b	.L7
.L15:
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-24]
	cmp	r2, r3
	bge	.L19
	ldr	r2, [fp, #-28]
	ldr	r3, [fp, #-24]
	add	r3, r2, r3
	str	r3, [fp, #-28]
	ldr	r2, [fp, #-36]
	ldr	r3, [fp, #-12]
	add	r3, r2, r3
	str	r3, [fp, #-36]
	b	.L19
.L18:
	mov	r0, r0	@ nop
.L7:
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L21:
	.align	2
.L20:
	.word	currentColor
	.size	line, .-line
	.align	2
	.global	plot4points
	.type	plot4points, %function
plot4points:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	str	r2, [fp, #-16]
	str	r3, [fp, #-20]
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-16]
	add	r1, r2, r3
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-20]
	add	r2, r2, r3
	ldr	r3, .L26
	ldr	r3, [r3, #0]
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	pixel
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	beq	.L23
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-16]
	rsb	r1, r3, r2
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-20]
	add	r2, r2, r3
	ldr	r3, .L26
	ldr	r3, [r3, #0]
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	pixel
.L23:
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	beq	.L24
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-16]
	add	r1, r2, r3
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-20]
	rsb	r2, r3, r2
	ldr	r3, .L26
	ldr	r3, [r3, #0]
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	pixel
.L24:
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	beq	.L22
	ldr	r3, [fp, #-20]
	cmp	r3, #0
	beq	.L22
	ldr	r2, [fp, #-8]
	ldr	r3, [fp, #-16]
	rsb	r1, r3, r2
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-20]
	rsb	r2, r3, r2
	ldr	r3, .L26
	ldr	r3, [r3, #0]
	mov	r0, r1
	mov	r1, r2
	mov	r2, r3
	bl	pixel
.L22:
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
.L27:
	.align	2
.L26:
	.word	currentColor
	.size	plot4points, .-plot4points
	.align	2
	.global	plot8points
	.type	plot8points, %function
plot8points:
	@ args = 0, pretend = 0, frame = 16
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #16
	str	r0, [fp, #-8]
	str	r1, [fp, #-12]
	str	r2, [fp, #-16]
	str	r3, [fp, #-20]
	ldr	r0, [fp, #-8]
	ldr	r1, [fp, #-12]
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-20]
	bl	plot4points
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-20]
	cmp	r2, r3
	beq	.L28
	ldr	r0, [fp, #-8]
	ldr	r1, [fp, #-12]
	ldr	r2, [fp, #-20]
	ldr	r3, [fp, #-16]
	bl	plot4points
.L28:
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
	.size	plot8points, .-plot8points
	.align	2
	.global	circle
	.type	circle, %function
circle:
	@ args = 0, pretend = 0, frame = 32
	@ frame_needed = 1, uses_anonymous_args = 0
	stmfd	sp!, {fp, lr}
	add	fp, sp, #4
	sub	sp, sp, #32
	str	r0, [fp, #-24]
	str	r1, [fp, #-28]
	str	r2, [fp, #-32]
	ldr	r3, [fp, #-32]
	rsb	r3, r3, #0
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-32]
	str	r3, [fp, #-12]
	mov	r3, #0
	str	r3, [fp, #-8]
	b	.L31
.L32:
	ldr	r0, [fp, #-24]
	ldr	r1, [fp, #-28]
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-8]
	bl	plot8points
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-8]
	add	r3, r3, #1
	str	r3, [fp, #-8]
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-8]
	add	r3, r2, r3
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-16]
	cmp	r3, #0
	blt	.L31
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-12]
	rsb	r3, r3, r2
	str	r3, [fp, #-16]
	ldr	r3, [fp, #-12]
	sub	r3, r3, #1
	str	r3, [fp, #-12]
	ldr	r2, [fp, #-16]
	ldr	r3, [fp, #-12]
	rsb	r3, r3, r2
	str	r3, [fp, #-16]
.L31:
	ldr	r2, [fp, #-12]
	ldr	r3, [fp, #-8]
	cmp	r2, r3
	bge	.L32
	sub	sp, fp, #4
	ldmfd	sp!, {fp, pc}
	.size	circle, .-circle
	.ident	"GCC: (Ubuntu/Linaro 4.7.3-1ubuntu1) 4.7.3"
	.section	.note.GNU-stack,"",%progbits

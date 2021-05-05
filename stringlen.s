	.arch armv8-a

	.global stringlen
	.text

// count number of characters in a cstr
// x0: char ptr
// return x0: count of characters
// clobbers: x1, x2, x3, v0, v1, v2, v3
	.equ    pot_batch, 16
	.align 6
stringlen:
	ldr     q1, =0x0f0e0d0c0b0a09080706050403020100
	movi    v2.16b, pot_batch
	ands    x3, x0, pot_batch - 1
	bne     .Lmisaligned
	add     x1, x0, pot_batch
.Lloop:
	ldr     q0, [x0], pot_batch
	cmeq    v0.16b, v0.16b, 0
	bsl     v0.16b, v1.16b, v2.16b
	uminv   b0, v0.16b
	fmov    w2, s0
	cmp     w2, pot_batch
	beq     .Lloop
	sub     x0, x0, x1
	add     x0, x0, x2
	ret
.Lmisaligned:
	and     x0, x0, -pot_batch
	dup     v3.16b, w3
	ldr     q0, [x0], pot_batch
	cmge    v3.16b, v1.16b, v3.16b
	cmeq    v0.16b, v0.16b, 0
	and     v0.16b, v0.16b, v3.16b
	bsl     v0.16b, v1.16b, v2.16b
	uminv   b0, v0.16b
	fmov    w2, s0
	cmp     w2, pot_batch
	add     x1, x0, x3
	beq     .Lloop
	sub     x0, x2, x3
	ret

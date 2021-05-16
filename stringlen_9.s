	.arch armv8-a

	.global stringlen_9
	.text

// count number of characters in a cstr
// special prerequisite: fpcr.FZ must be low
// x0: char ptr
// return x0: count of characters
// clobbers: x1, x2, x3, v0, v1, v2, v3, v4, v5, v6, v7
	.equ    pot_batch, 32
	.align 6
stringlen_9:
	ldr     q2, =0x0f0e0d0c0b0a09080706050403020100
	ldr     q5, =0x1f1e1d1c1b1a19181716151413121110
	movi    v3.16b, pot_batch
	ands    x3, x0, pot_batch - 1
	bne     .Lmisaligned
	add     x1, x0, pot_batch
	movi    v4.2d, 0
.Lloop:
	ldp     q0, q1, [x0], pot_batch
	cmeq    v0.16b, v0.16b, 0
	cmeq    v1.16b, v1.16b, 0
	addp    d6, v0.2d
	addp    d7, v1.2d
	fcmp    d6, d4
	fccmp   d7, d4, 0, eq
	beq     .Lloop
	bsl     v0.16b, v2.16b, v3.16b
	bsl     v1.16b, v5.16b, v3.16b
	umin    v0.16b, v0.16b, v1.16b
	uminv   b0, v0.16b
	fmov    w2, s0
	sub     x0, x0, x1
	add     x0, x0, x2
	ret
.Lmisaligned:
	and     x0, x0, -pot_batch
	ldp     q0, q1, [x0], pot_batch
	dup     v4.16b, w3
	cmge    v6.16b, v2.16b, v4.16b
	cmge    v7.16b, v5.16b, v4.16b
	cmeq    v0.16b, v0.16b, 0
	cmeq    v1.16b, v1.16b, 0
	and     v0.16b, v0.16b, v6.16b
	and     v1.16b, v1.16b, v7.16b
	addp    d6, v0.2d
	addp    d7, v1.2d
	movi    v4.2d, 0
	add     x1, x0, x3
	fcmp    d6, d4
	fccmp   d7, d4, 0, eq
	beq     .Lloop
	bsl     v0.16b, v2.16b, v3.16b
	bsl     v1.16b, v5.16b, v3.16b
	umin    v0.16b, v0.16b, v1.16b
	uminv   b0, v0.16b
	fmov    w2, s0
	sub     x0, x2, x3
	ret

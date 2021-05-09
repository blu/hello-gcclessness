	.arch armv8-a

	.global stringlen_6
	.text

// count number of characters in a cstr
// x0: char ptr
// return x0: count of characters
// clobbers: x1, x2, x3, x4, x5, x6, v0, v1, v2, v3, v4, v5, v6, v7, v16, v17, v18, v19, v20, v21
	.equ    pot_batch, 64
	.align 6
stringlen_6:
	ldr     q4, =0x0f0e0d0c0b0a09080706050403020100
	ldr     q5, =0x1f1e1d1c1b1a19181716151413121110
	ldr     q6, =0x2f2e2d2c2b2a29282726252423222120
	ldr     q7, =0x3f3e3d3c3b3a39383736353433323130
	movi    v16.16b, pot_batch
	ands    x3, x0, pot_batch - 1
	bne     .Lmisaligned
	add     x1, x0, pot_batch
.Lloop:
	ldp     q0, q1, [x0], pot_batch / 2
	ldp     q2, q3, [x0], pot_batch / 2

	cmeq    v0.16b, v0.16b, 0
	cmeq    v1.16b, v1.16b, 0
	cmeq    v2.16b, v2.16b, 0
	cmeq    v3.16b, v3.16b, 0

	umaxv   b17, v0.16b
	umaxv   b18, v1.16b
	umaxv   b19, v2.16b
	umaxv   b20, v3.16b

	fmov    w2, s17
	fmov    w4, s18
	fmov    w5, s19
	fmov    w6, s20
	cbnz    w2, .Lmatch0
	cbnz    w4, .Lmatch1
	cbnz    w5, .Lmatch2
	cbz     w6, .Lloop

	bsl     v3.16b, v7.16b, v16.16b
	uminv   b3, v3.16b
	fmov    w2, s3
	sub     x0, x0, x1
	add     x0, x0, x2
	ret
.Lmatch0:
	bsl     v0.16b, v4.16b, v16.16b
	uminv   b0, v0.16b
	fmov    w2, s0
	sub     x0, x0, x1
	add     x0, x0, x2
	ret
.Lmatch1:
	bsl     v1.16b, v5.16b, v16.16b
	uminv   b1, v1.16b
	fmov    w2, s1
	sub     x0, x0, x1
	add     x0, x0, x2
	ret
.Lmatch2:
	bsl     v2.16b, v6.16b, v16.16b
	uminv   b2, v2.16b
	fmov    w2, s2
	sub     x0, x0, x1
	add     x0, x0, x2
	ret
.Lmisaligned:
	and     x0, x0, -pot_batch
	ldp     q0, q1, [x0], pot_batch / 2
	ldp     q2, q3, [x0], pot_batch / 2

	dup     v17.16b, w3
	cmge    v18.16b, v4.16b, v17.16b
	cmge    v19.16b, v5.16b, v17.16b
	cmge    v20.16b, v6.16b, v17.16b
	cmge    v21.16b, v7.16b, v17.16b

	cmeq    v0.16b, v0.16b, 0
	cmeq    v1.16b, v1.16b, 0
	cmeq    v2.16b, v2.16b, 0
	cmeq    v3.16b, v3.16b, 0

	and     v0.16b, v0.16b, v18.16b
	and     v1.16b, v1.16b, v19.16b
	and     v2.16b, v2.16b, v20.16b
	and     v3.16b, v3.16b, v21.16b

	bsl     v0.16b, v4.16b, v16.16b
	bsl     v1.16b, v5.16b, v16.16b
	bsl     v2.16b, v6.16b, v16.16b
	bsl     v3.16b, v7.16b, v16.16b

	umin    v0.16b, v0.16b, v1.16b
	umin    v2.16b, v2.16b, v3.16b
	umin    v0.16b, v0.16b, v2.16b
	uminv   b0, v0.16b

	fmov    w2, s0
	cmp     w2, pot_batch - 1
	add     x1, x0, x3
	bhi     .Lloop
	sub     x0, x2, x3
	ret

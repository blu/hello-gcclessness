	.arch armv8-a
	.include "include.inc"

	.global _start
	.text

// convert x16 to string
// x0: output buffer
// w1: value to convert, bits [15:0]
// clobbers: x2, x3, x4, x5
	.align 4
string_x16:
	mov     w3, '0'
	mov     w4, 'a' - 0xa
	mov     w2, 0
	bfxil   w2, w1, 12, 4
	cmp     w2, 0xa
	csel    w5, w3, w4, LO
	add     w2, w2, w5
	strb    w2, [x0], 1
	mov     w2, 0
	bfxil   w2, w1, 8, 4
	cmp     w2, 0xa
	csel    w5, w3, w4, LO
	add     w2, w2, w5
	strb    w2, [x0], 1
	mov     w2, 0
	bfxil   w2, w1, 4, 4
	cmp     w2, 0xa
	csel    w5, w3, w4, LO
	add     w2, w2, w5
	strb    w2, [x0], 1
	and     w2, w1, 15
	cmp     w2, 0xa
	csel    w5, w3, w4, LO
	add     w2, w2, w5
	strb    w2, [x0], 1
	ret

// convert x16 to string
// x0: output buffer
// w1: value to convert, bits [15:0]
// clobbers: x2, x3, x4, x5, x6, x7
	.align 4
string_x16_1:
	mov     w3, '0'
	mov     w4, 'a' - 0xa
	mov     w5, 0xa
	mov     w6, 0x0f0f
	lsr     w2, w1, 4
	and     w1, w1, w6 // even-index nibbles
	and     w2, w2, w6 // odd-index nibbles
	
	cmp     w5, w1, UXTB
	csel    w6, w3, w4, HI
	cmp     w5, w2, UXTB
	csel    w7, w3, w4, HI
	
	add     w1, w1, w6
	add     w2, w2, w7
	strb    w1, [x0, 3]
	strb    w2, [x0, 2]
	
	lsr     w1, w1, 8
	lsr     w2, w2, 8
	
	cmp     w5, w1, UXTB
	csel    w6, w3, w4, HI
	cmp     w5, w2, UXTB
	csel    w7, w3, w4, HI
	
	add     w1, w1, w6
	add     w2, w2, w7
	strb    w1, [x0, 1]
	strb    w2, [x0, 0]
	ret

// convert x16 to string
// x0: output buffer
// w1: value to convert, bits [15:0]
// clobbers: v0, v1, v3, v4, v5, v6
	.align 4
string_x16_2:
	rev16   w1, w1 // we write the result via a single store op, so correct for digit order, part one: swap octet order
	movi    v3.8b, '0'
	movi    v4.8b, 'a' - 0xa
	movi    v5.8b, 0xa
	movi    v6.8b, 0xf
	mov     v0.4h[0], w1
	ushr    v1.8b, v0.8b, 4
	and     v0.8b, v0.8b, v6.8b
	zip1    v0.8b, v1.8b, v0.8b // we write the result via a single store op, so correct for digit order, part two: swap nibble order
	cmhi    v1.8b, v5.8b, v0.8b
	bsl     v1.8b, v3.8b, v4.8b
	add     v0.8b, v0.8b, v1.8b
	str     s0, [x0]
	ret

// convert x32 to string
// x0: output buffer
// w1: value to convert, bits [31:0]
// clobbers: v0, v1, v3, v4, v5, v6
	.align 4
string_x32:
	rev     w1, w1 // we write the result via a single store op, so correct for digit order, part one: swap octet order
	movi    v3.8b, '0'
	movi    v4.8b, 'a' - 0xa
	movi    v5.8b, 0xa
	movi    v6.8b, 0xf
	mov     v0.2s[0], w1
	ushr    v1.8b, v0.8b, 4
	and     v0.8b, v0.8b, v6.8b
	zip1    v0.8b, v1.8b, v0.8b // we write the result via a single store op, so correct for digit order, part two: swap nibble order
	cmhi    v1.8b, v5.8b, v0.8b
	bsl     v1.8b, v3.8b, v4.8b
	add     v0.8b, v0.8b, v1.8b
	str     d0, [x0]
	ret

// program entry point
_start:
	mov     x8, SYS_write
	mov     x2, routine_name_len
	adr     x1, routine_name_txt
	mov     x0, STDOUT_FILENO
	svc     0

	mov     x28, 4096 * 65536
1:
	adr     x0, buffer_txt
	movl    w1, 0x12342ad
	bl      string_x32

	subs    x28, x28, 1
	bne     1b

	mov     x8, SYS_write
	mov     x2, buffer_len
	adr     x1, buffer_txt
	mov     x0, STDOUT_FILENO
	svc     0

	mov     x8, SYS_exit
	svc     0
	
	.data

routine_name_txt:
	.ascii "string_xNN(0x12342ad)\n"
routine_name_len = . - routine_name_txt

	.align 3
buffer_txt:
	.ascii "        \n"
buffer_len = . - buffer_txt

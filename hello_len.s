	.arch armv8-a
	.include "include.inc"

	.global _start
	.text

	.equ    BUFFER_MIN, 1 << 20
	.equ    AT_FDCWD, -100

// program entry point
_start:
	mov     x8, SYS_openat
	mov     x2, O_RDONLY
	adr     x1, filename_rand
	mov     x0, AT_FDCWD
	svc     0
	cmp     x0, xzr
	bge     .Lread

	// error: openat
	mov     x8, SYS_exit
	mov     x0, -1
	svc     0

.Lread:
	mov     x9, x0

	mov     x8, SYS_read
	mov     x2, BUFFER_MIN
	adr     x1, buffer_txt
	svc     0
	cmp     x0, BUFFER_MIN
	beq     .Lclose

	// error: read
	mov     x8, SYS_exit
	mov     x0, -2
	svc     0

.Lclose:
	mov     x8, SYS_close
	mov     x0, x9
	svc     0

	mov     x28, 10000
	adr     x27, buffer_txt
	add     x27, x27, BUFFER_MIN
.Lrep:
	adr     x26, buffer_txt
.Lstring:
	mov     x0, x26
.if ALT == 99
	bl      _strlen
.elseif ALT == 5
	bl      stringlen_5
.elseif ALT == 4
	bl      stringlen_4
.elseif ALT == 3
	bl      stringlen_3
.elseif ALT == 2
	bl      stringlen_2
.elseif ALT == 1
	bl      stringlen_1
.else
	bl      stringlen
.endif
	add     x0, x0, 1
	add     x26, x26, x0
	cmp     x26, x27
	bls     .Lstring

	subs    x28, x28, 1
	bne     .Lrep

	mov     x8, SYS_exit
	mov     x0, xzr
	svc     0

	.data

filename_rand:
	.ascii	"./rand"

	.bss

	.align 10
buffer_txt:
	.fill   BUFFER_MIN + 1

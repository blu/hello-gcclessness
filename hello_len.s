	.arch armv8-a
	.include "include.inc"

	.global _start
	.text

	.equ    BUFFER_MIN, 1 << 20
	.equ    AT_FDCWD, -100

// program entry point
_start:
	// reset fpcr.FZ as some participants requre that
	mrs     x0, fpcr
	and     w0, w0, ~(1 << 24)
	msr     fpcr, x0

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
	adrp    x1, buffer_txt
	add     x1, x1, :lo12:buffer_txt
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

	mov     x28, 32768
	adrp    x27, buffer_txt
	add     x27, x27, :lo12:buffer_txt
	add     x27, x27, BUFFER_MIN
.Lrep:
	adrp    x26, buffer_txt
	add     x26, x26, :lo12:buffer_txt
.Lstring:
	mov     x0, x26
.if ALT == 99
	bl      __strlen_generic
.elseif ALT == 98
	bl      __strlen_asimd
.elseif ALT == 9
	bl      stringlen_9
.elseif ALT == 8
	bl      stringlen_8
.elseif ALT == 7
	bl      stringlen_7
.elseif ALT == 6
	bl      stringlen_6
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
	.ascii  "./rand"

	.bss

	.align 10
buffer_txt:
	.fill   BUFFER_MIN + 1

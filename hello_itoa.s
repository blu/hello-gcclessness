	.arch armv8-a
	.include "include.inc"

	.global _start
	.text

	.equ    sample_x64, 0x123456789abcdef

// program entry point
_start:
	mov     x8, SYS_write
	mov     x2, routine_name_len
	adr     x1, routine_name_txt
	mov     x0, STDOUT_FILENO
	svc     0

	mov     x28, 4096 * 65536
1:
.if ALT == 99
	movq    x0, sample_x64
	adr     x1, buffer_txt + 16
	mov     x2, 16  // radix
	mov     x3, xzr // ascii case: lower
	bl      _itoa_word
.elseif ALT == 6
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x8
.elseif ALT == 5
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x16_2
.elseif ALT == 4
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x16_1
.elseif ALT == 3
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x16
.elseif ALT == 2
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x32
.elseif ALT == 1
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x64_1
.else
	adr     x0, buffer_txt
	movq    x1, sample_x64
	bl      string_x64
.endif

	subs    x28, x28, 1
	bne     1b

	mov     x8, SYS_write
	mov     x2, buffer_len
	adr     x1, buffer_txt
	mov     x0, STDOUT_FILENO
	svc     0

	mov     x8, SYS_exit
	mov     x0, xzr
	svc     0

// assemble an ascii character from a 4-bit hex value
.macro ascii_from_x4, val:req
	.if 0xa > \val
		.byte \val + 0x30 - 0x0
	.else
		.byte \val + 0x61 - 0xa
	.endif
.endm

// assemble an ascii sequence from a 64-bit hex value
.macro ascii_from_x64, val:req
	.set i, 0
	.rept 16
		ascii_from_x4 (\val >> ((15 - i) * 4) & 0xf)
		.set i, i + 1
	.endr
.endm

	.data

	.altmacro
routine_name_txt:
	.ascii "string_xNN("
	ascii_from_x64 %sample_x64
	.ascii ")\n"
routine_name_len = . - routine_name_txt

	.align 4
buffer_txt:
	.ascii "                \n"
buffer_len = . - buffer_txt

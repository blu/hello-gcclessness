	.arch armv8-a

	.global __stack_chk_guard
	.global __stack_chk_fail

	.text

// stub symbols sought by _fitoa_word, which we never call
__stack_chk_guard:
__stack_chk_fail:

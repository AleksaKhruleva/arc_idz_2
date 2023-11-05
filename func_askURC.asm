.global	ask_URC_func
.include "lib_macros.asm"

# function:
#	Ask User to Repeat Calculation
# return:
#	a0 - register
.text
ask_URC_func:
	coutT(lit_coi)			# print welcome text
	cinC				# input Char
check_yes:
	la	t0, yes_chars		# load address yes_chars literals
do_yes:
	lbu	t1, (t0)			# load current char from check string
	beq	t1, zero, check_no	# branch if end of null-terminated string
	beq	t1, a0, end_yes		# branch if char in yes-chars
	addi	t0, t0, 1		# goto next char in string
	j	do_yes			# jump to next ittertion
check_no:
	la	t0, no_chars		# load address yes_chars literals
do_no:
	lbu	t1, (t0)			# load current char from check string
	beq	t1, zero, ask_URC_func	# branch if end of null-terminated string
	beq	t1, a0, end_no		# branch if char in yes-chars
	addi	t0, t0, 1		# goto next char in string
	j	do_no			# jump to next ittertion
end_yes:
	coutT(lit_nl)			# print new line
	coutT(lit_nl)			# print new line
	li	a0, 0			# return YES code
	ret				# return
end_no:
	coutT(lit_nl)			# print new line
	coutT(lit_nl)			# print new line
	li	a0, 1			# return NO code
	ret				# return
.data
yes_chars:	.asciz	"Yy\n"
no_chars:	.asciz	"Nn"

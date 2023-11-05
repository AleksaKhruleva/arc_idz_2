# macro:
#	Calculate integral of: f(x) = a + b / (x * x)
#	27. Razrabotat' programmu integrirovaniya funkcii y = a + b / (x * x)
#	(zadayotsya dvumya chislami a, b) v zadannom diapazone (zadayotsya tak zhe)
#	metodom Simpsona (tochnost' vychislenij = 0.0001).
# arguments:
#	a1 - target function address (register, input)
#	a2 - target function custom data address (register, input)
#	X1 - the X1 (register, input)
#	X2 - the X2 (register, input)
#	E  - the E  (register, input)
# return:
#	fa0 - register
.macro	calc_I (%a1, %a2, %X1, %X2, %E)
	addi	sp, sp, -32		# obtain stack for arguments
	sw	%a1, +0(sp)		# target function address
	sw	%a2, +4(sp)		# target function custom data address
	fsd	%X1, +8(sp)		# the X1 (register, input)
	fsd	%X2, +16(sp)		# the X2 (register, input)
	fsd	%E, +24(sp)		# the N (register, input)
	jal	calc_I_func		# call function
	addi	sp, sp, 32		# free stack
.end_macro


# macro:
#	Calculate integral of: f(x) = a + b / (x * x)
# arguments:
#	a1 - target function address (register, input)
#	a2 - target function custom data address (register, input)
#	X1 - the X1 (register, input)
#	X2 - the X2 (register, input)
#	N  - the N  (register, input)
# return:
#	fa0 - register
.macro	funcS (%a1, %a2, %X1, %X2, %N)
	addi	sp, sp, -28		# obtain stack for arguments
	sw	%a1, +0(sp)		# target function address
	sw	%a2, +4(sp)		# target function custom data address
	fsd	%X1, +8(sp)		# the X1 (register, input)
	fsd	%X2, +16(sp)		# the X2 (register, input)
	sw	%N, +24(sp)		# the N (register, input)
	jal	funcS_func		# call function
	addi	sp, sp, 28		# free stack
.end_macro


# macro:
#	Configure target function custom data
# arguments:
#	S - custom data address (register, input)
#	A - the A (register, input)
#	B - the B (register, input)
.macro	cnf_tfunc(%S, %A, %B)
	addi	sp, sp, -20		# obtain stack for arguments
	sw	%S, +0(sp)		# store S
	fsd	%A, +4(sp)		# store A
	fsd	%B, +12(sp)		# store B
	jal	cnf_tfunc_func		# call function
	addi	sp, sp, 20		# free stack
.end_macro


# macro:
#	Check X1 & X2 are correct
# arguments:
#	X1 - the X1 (register, input)
#	X2 - the X2 (register, input)
.macro	check_x1x2 (%X1, %X2)
	addi	sp, sp, -16		# obtain stack for arguments
	fsd	%X1, +0(sp)		# store X1
	fsd	%X2, +8(sp)		# store X2
	jal	check_x1x2_func		# call function
	addi	sp, sp, 16		# free stack
.end_macro

# macro:
#	Ask User to Repeat Calculation
# return:
#	a0 - register
.macro	ask_URC
	jal	ask_URC_func		# call function
.end_macro


# macro:
#	Input Double
# arguments:
#	D - address of the label to save the number
.macro	inputD (%D)
	addi	sp, sp, -4		# obtain stack for arguments
	sw	%D, +0(sp)		# store address
	jal	inputD_func		# call function
	addi	sp, sp, 4		# free stack
.end_macro


# macro:
#	Read Double from console
.macro	cinD
	li	a7, 7
	ecall
.end_macro


# macro:
#	Print Double to console
.macro	coutD
	li	a7, 3
	ecall
.end_macro


# macro:
#	Print Text to console
# arguments:
#	text - address of the label to print
.macro	coutT(%text)
	la	a0, %text
	li	a7, 4
	ecall
.end_macro


# macro:
#	Read char from console
.macro	cinC
	li	a7, 12
	ecall
.end_macro


# macro:
#	Finish program with code 0 
.macro	done
	li	a7, 10
	ecall
.end_macro


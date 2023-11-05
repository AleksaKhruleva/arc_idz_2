.global	check_x1x2_func
.include "lib_macros.asm"

# function:
#	Check A & B are correct
# arguments:
#	stack (+00) - the A (double, input)
#	stack (+08) - the B (double, input)
# return:
#	a0 (register) - 0 - ok! (A & B are correct)
.text
check_x1x2_func:
	fld	ft1, +0(sp)		# load A value
	fld	ft2, +8(sp)		# load B value
	li	a0, 1			# load return value (A & B are incorrect)
	fcvt.d.w	ft0, zero		# initialize double register to zero
	# check the A = 0
	feq.d	t0, ft1, ft0		# test to zero
	bgt	t0, zero, check_x1x2_1_1	# branch if the A = 0
	# check the B = 0
	feq.d	t0, ft2, ft0		# test to zero
	bgt	t0, zero, check_x1x2_1_1	# branch if the B = 0
	# check the 0 in [A,B]
	flt.d	t1, ft1, ft0		# get the sign of the A
	flt.d	t2, ft2, ft0		# get the sign of the B
	bne	t1, t2, check_x1x2_1_1	# branch if signs different
check_x1x2_0:
	li	a0, 0			# load return value (A & B are correct)
check_x1x2_1_1:
	ret				# return


.global	calc_I_func
.include "lib_macros.asm"

# function:
#	Calculate the integral using Simpson's method
# locals area:
#	stack (+00) - n
#	stack (+04) - t1 (double)
#	stack (+12) - t2 (double)
# save area:
#	stack (+00) - register ra (return address)
#	stack (+04) - register s0
# arguments area (are obtained using s0):
#	stack (+00) - target function address (input)
#	stack (+04) - target function custom data address (input)
#	stack (+08) - x1 (double, input)
#	stack (+16) - x2 (double, input)
#	stack (+24) - E (double)
# register usage:
#	s0 - on-call stack position (arguments area)
# return:
#	fa0 - function result (register)

.text
calc_I_func:
	addi	sp, sp, -8		# obtain stack for save area
	sw	ra, +0(sp)		# save ra register
	sw	s0, +4(sp)		# save s0 register
	addi	s0, sp, 8		# set on-call stack position (arguments area)
	# initialize locals area
	addi	sp, sp, -20		# obtain stack for locals area
	li	t0, 1			# initialize n value
	sw	t0, +0(sp)		# store n value
	# t2 = simpsonIntegral(the_func, &target_func_data, x1, x2, n);
	lw	a1, +0(s0)		# load target function address
	lw	a2, +4(s0)		# load target function custom data address
	fld	fa1, +8(s0)		# load x1 value
	fld	fa2, +16(s0)		# load x2 value
	lw	a3, +0(sp)		# load n value
	funcS	(a1, a2, fa1, fa2, a3)	# call funcS_func
	fsd	fa0, +12(sp)		# store return value to t2
do:	# do {
	#  t1 = t2;
	fld	fa0, +12(sp)		# load t2 value
	fsd	fa0, +4(sp)		# store to t1
	#  n = 2 * n;
	lw	t0, +0(sp)		# load n
	slli	t0, t0, 1		# n *= 2
	sw	t0, +0(sp)		# store n
	#  t2 = simpsonIntegral(the_func, &target_func_data, x1, x2, n);
	lw	a1, +0(s0)		# load target function address
	lw	a2, +4(s0)		# load target function custom data address
	fld	fa1, +8(s0)		# load x1 value
	fld	fa2, +16(s0)		# load x2 value
	lw	a3, +0(sp)		# load n value
	funcS	(a1, a2, fa1, fa2, a3)	# call funcS_func
	fsd	fa0, +12(sp)		# store return value to t2
	# } while (fabs(t2 - t1) > eps);
	fld	fa1, +4(sp)		# load t1 value
	fld	fa2, +12(sp)		# load t2 value
	fsub.d	fa0, fa2, fa1		# fa0 = t2 - t1
	fabs.d	fa0, fa0			# fa0 = fabs(fa0)
	fld	fa1, +24(s0)		# load E value
	fgt.d	t0, fa0, fa1		# test "fabs(t2 - t1) > eps"
	bgt	t0, zero, do		# branch if "fabs(t2 - t1) > eps"
	# return
	fld	fa0, +12(sp)		# load return value
	addi	sp, sp, 20		# restore stack position to save area
	lw	ra, +0(sp)		# restore ra register
	lw	s0, +4(sp)		# restore s0 register
	addi	sp, sp, 8		# restore on-call stack position
	ret

#	C++ similar code:
#
#	t2 = simpsonIntegral(the_func, &target_func_data, x1, x2, n);
#	do {
#	  t1 = t2;
#	  n = 2 * n;
#	  t2 = simpsonIntegral(the_func, &target_func_data, x1, x2, n);
#	} while (fabs(t2 - t1) > eps);


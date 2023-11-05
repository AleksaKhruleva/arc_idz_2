.globl	_test_01
.include "lib_macros.asm"

# main program
.text
_test_01:
	coutT	(lit_tf)			# print info
	coutT	(lit_params)		# print parameters info
	
	la	t0, funcT_custom_data	# load target function custom data address
	fld	fa0, +0(t0)		# load A value
	coutD				# print it
	coutT	(lit_nl)			# new line
	
	la	t0, funcT_custom_data	# load target function custom data address
	fld	fa0, +8(t0)		# load B result
	coutD				# print it
	coutT	(lit_nl)			# new line
	
	fld	fa0, num_X1, t0		# load X1 value
	coutD				# print it
	coutT	(lit_nl)			# new line
	
	fld	fa0, num_X2 t0		# load X2 value
	coutD				# print it
	coutT	(lit_nl)			# new line
	
	coutT	(lit_expe)		# print info
	fld	fa0, num_R, t0		# load expected result
	coutD				# print it
	coutT	(lit_nl)			# new line
	
	coutT	(lit_res1)		# print info
	
	fld	fa1, num_X1, t0		# load X1 value
	fld	fa2, num_X2, t0		# load X2 value
	check_x1x2(fa1, fa2)		# validate X1 and X2 values
	beq	a0, zero, _calc_I		# branch if return 0
	
	coutT	(lit_ma_10)		# print text
	j	_end

_calc_I:
	la	a1, funcT_func		# load target function address
	la	a2, funcT_custom_data	# load target function custom data address
	fld	fa1, num_X1, t0		# load x1 value (left point)
	fld	fa2, num_X2, t0		# load x2 value (right point)
	fld	fa3, num_E, t0		# load e value (acuracy)
	calc_I	(a1, a2, fa1, fa2, fa3)	# call Simpson function
	fsd	fa0, num_I, t0		# store result
	coutD				# print result
	coutT	(lit_nl)			# new line

_end:
	done

.data
			.align	3
	num_I:		.double	-1			# integral function result
	num_E:		.double	0.0001			# accuracity
	num_X1:		.double	2			# left point integration
	num_X2:		.double	3			# rigth point integration
	num_R:		.double	1.1666675369055741	# expected ruslt
	funcT_custom_data:
			.double	1	# the A - item of target function
			.double	1	# the B - item of target function


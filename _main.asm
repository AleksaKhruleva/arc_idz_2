.globl	main
.include "lib_macros.asm"

# main program
.text
main:
	coutT	(lit_tf)			# print info
main_1:
	coutT	(lit_iad)		# print info
	la	a1, num_A		# load num A address
	inputD	(a1)			# input A

	coutT	(lit_ibd)		# print info
	la	a1, num_B		# load num B address
	inputD	(a1)			# input B

	la	a1, tfunc_custom_data	# load target function custom data address
	fld	fa1, num_A, t0		# load the A value
	fld	fa2, num_B, t0		# load the B value
	cnf_tfunc(a1, fa1, fa2)		# configure target function custom data

_input_x1x2:
	coutT	(lit_ix1d)		# print info
	la	a1, num_X1		# load num X1 address
	inputD	(a1)			# input X1

	coutT	(lit_ix2d)		# print info
	la	a1, num_X2		# load num X2 address
	inputD	(a1)			# input X2

	fld	fa1, num_X1, t0		# load X1 value
	fld	fa2, num_X2, t0		# load X2 value
	check_x1x2(fa1, fa2)		# validate X1 and X2 values
	beq	a0, zero, _calc_I		# branch if return value != 0
	
	coutT	(lit_ma_10)		# print text
	coutT	(lit_ri)			# print text
	j	_input_x1x2

_calc_I:
	la	a1, funcT_func		# load target function address
	la	a2, tfunc_custom_data	# load target function custom data address
	fld	fa1, num_X1, t0		# load x1 value (left point)
	fld	fa2, num_X2, t0		# load x2 value (right point)
	fld	fa3, num_E, t0		# load e value (accuracy)
	calc_I	(a1, a2, fa1, fa2, fa3)	# calculate integral
	coutT	(lit_nl)			# new line
	coutT	(lit_res0)		# print info
	coutD				# print result
	coutT	(lit_nl)			# new line

_repeat:
	ask_URC				# ask User to Repeat Calculation
	beq	a0, zero, main_1		# branch if YES choice

_end:
	done

.data
			.align	3
	num_E:		.double	0.0001	# accuracy
	num_X1:		.double	2	# left boundary of integration
	num_X2:		.double	3	# right boundary of integration
	num_A:		.double	-1	# user A value
	num_B:		.double	-1	# user B value
	tfunc_custom_data:
			.double	1	# the A - item of target function
			.double	1	# the B - item of target function
	user_ans:	.string


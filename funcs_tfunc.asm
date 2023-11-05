.global	cnf_tfunc_func
.global	funcT_func

# function:
#	Target function (fast call, registers only)
#	f(x) = a + b / (x * x)
# arguments:
#	a0  - target function custom data address (input)
#	fa0 - the X (input)
# return:
#	fa0 - function result
.text
funcT_func:
	fmv.d	ft0, fa0			# copy X to temp register
	fmul.d	ft0, ft0, ft0		# = X * X
	fld	fa0, +8(a0)		# load the B
	fdiv.d	fa0, fa0, ft0		# = B / (X * X)
	fld	ft0, +0(a0)		# load the A
	fadd.d	fa0, fa0, ft0		# = A + B / (X * X)
	ret				# return

# function:
#	Configure target function custom
# arguments:
#	stack (+00) - the A (input)
#	stack (+08) - the B (input)
.text
cnf_tfunc_func:
	lw	t0,  +0(sp)		# load custom data address 
	fld	ft0, +4(sp)		# load the A
	fsd	ft0, +0(t0)		# store the A
	fld	ft0, +12(sp)		# load the B
	fsd	ft0, +8(t0)		# store the B
	ret				# return


.global	funcS_func

# function:
#	Simpson's integral
# locals area:
#	stack(+00) - i	(word)
#	stack(+04) - d	(double)
#	stack(+12) - p1	(double)
#	stack(+20) - p2	(double)
#	stack(+28) - f1	(double)
#	stack(+36) - f2	(double)
#	stack(+44) - f3	(double)
#	stack(+52) - si	(double)
	.eqv	la_sz	60
# save area:
#	stack (+00) - register ra (return address)
#	stack (+04) - register s0
	.eqv	sa_sz	8
# arguments area:
#	stack (+00) - target function address (input)
#	stack (+04) - target function custom data address (input)
#	stack (+08) - x1 (double, input)
#	stack (+16) - x2 (double, input)
#	stack (+24) - N (input)
# register usage:
#	s0 - on-call stack position (arguments area)
# return:
#	fa0 - function result (register)
.text
funcS_func:
	addi	sp, sp, -sa_sz		# obtain stack for save area
	sw	ra, +0(sp)		# save ra register
	sw	s0, +4(sp)		# save s0 register
	addi	s0, sp, sa_sz		# set on-call stack position (arguments area)
	# initialize locals area
	addi	sp, sp, -la_sz		# obtain stack for locals area
	# double si = 0;
	fcvt.d.w	ft0, zero		# initialize double register to zero
	fsd	ft0, +52(sp)		# si = 0;
	# double d = (x2 - x1) / n;
	fld	ft1, +8(s0)		# load x1 value
	fld	ft2, +16(s0)		# load x2 value
	fsub.d	ft1, ft2, ft1		# d = x2 - x1
	lw	t0, +24(s0)		# load N value
	fcvt.d.w	ft0, t0			# convert N to double
	fdiv.d	ft1, ft1, ft0		# d = (x2 - x1) / N
	fsd	ft1, +4(sp)		# store value to d
	# for (int i = 0; i < n; i++) {
	mv	t0, zero			# i = 0
	sw	t0, +00(sp)		# store value to i
for:	lw	t0, +00(sp)		# load i value (word)
	lw	a3, +24(s0)		# load N value (word)
	bge	t0, a3, for_end		# i < N
	fcvt.d.w	ft0, t0			# load i value (double)
	fld	ft1, +4(sp)		# load d value
	fld	fa1, +8(s0)		# load x1 value
	#   double p1 = x1 + i * d;
	fmul.d	ft2, ft0, ft1		# p1 = i * d
	fadd.d	ft2, ft2, fa1		# p1 += x1
	fsd	ft2, +12(sp)		# store p1 value
	#   double p2 = x1 + i * d + d;
	fmul.d	ft3, ft0, ft1		# p2 = i * d
	fadd.d	ft3, ft3, fa1		# p2 += x1
	fadd.d	ft3, ft3, ft1		# p2 += d
	fsd	ft3, +20(sp)		# store p2 value
	#   double f1 = the_func(func_data, p1);
	lw	a0, +4(s0)		# load target function custom data address 
	fld	fa0, +12(sp)		# load p1 value
	lw	a1, +0(s0)		# load target function address
	jalr	a1			# the_func(func_data, p1)
	fsd	fa0, +28(sp)		# store f1 value
	#   double f2 = the_func(func_data, (p1 + p2) / 2.0);
	lw	a0, +4(s0)		# load target function custom data address 
	fld	ft1, +12(sp)		# load p1 value
	fld	ft2, +20(sp)		# load p2 value
	fadd.d	fa0, ft1, ft2		# x = (p1 + p2)
	li	t0, 2			# .
	fcvt.d.w	ft0, t0			# .
	fdiv.d	fa0, fa0, ft0		# x /= 2.0
	lw	a1, +0(s0)		# load target function address
	jalr	a1			# the_func(func_data, (p1 + p2) / 2.0)
	fsd	fa0, +36(sp)		# store f2 value
	#   double f3 = the_func(func_data, p2);
	lw	a0, +4(s0)		# load target function custom data address 
	fmv.d	fa0, ft3			# load target function argument
	lw	a1, +0(s0)		# load target function address
	jalr	a1			# the_func(func_data, p2)
	fsd	fa0, +44(sp)		# store f3 value
	#   si += (p2 - p1) / 6.0 * (f1 + 4.0 * f2 + f3);
	fld	ft1, +12(sp)		# load p1 value
	fld	ft2, +20(sp)		# load p2 value
	fsub.d	ft0, ft2, ft1		# ft0 = (p2 - p1)
	li	t1, 6			# .
	fcvt.d.w	ft1, t1			# .
	fdiv.d	ft0, ft0, ft1		# ft0 /= 6.0
	fld	ft10, +36(sp)		# load f2 value
	li	t1, 4			# .
	fcvt.d.w	ft1, t1			# .
	fmul.d	ft10, ft10, ft1		# ft10 *= 4.0
	fld	ft1, +28(sp)		# load f1 value
	fadd.d	ft10, ft10, ft1		# ft10 += f1
	fld	ft1, +44(sp)		# load f3 value
	fadd.d	ft10, ft10, ft1		# ft10 += f3
	fmul.d	ft10, ft10, ft0		# ft10 *= ft0
	fld	ft1, +52(sp)		# load si value
	fadd.d	ft1, ft1, ft10		# si += ft10
	fsd	ft1, +52(sp)		# store si value
	lw	t0, +0(sp)		# load i value (word)
	addi	t0, t0, 1		# i++
	sw	t0, +0(sp)		# store value to i
	j	for
for_end:	# }
	# return si
	fld	fa0, +52(sp)		# load si value to result register
	addi	sp, sp, la_sz		# restore stack position to save area
	lw	ra, +0(sp)		# restore ra register
	lw	s0, +4(sp)		# restore s0 register
	addi	sp, sp, sa_sz		# restore on-call stack position
	ret				# return

#	double simpsonIntegral(target_func_pointer the_func, void *func_data, double x1, double x2, int n) {
#	    double si = 0;
#	    double d = (x2 - x1) / n;
#	    for (int i = 0; i < n; i++) {
#	        double p1 = x1 + i * d;
#	        double p2 = x1 + i * d + d;
#	        double f1 = the_func(func_data, p1);
#	        double f2 = the_func(func_data, (p1 + p2) / 2.0);
#	        double f3 = the_func(func_data, p2);
#	        si += (p2 - p1) / 6.0 * (f1 + 4.0 * f2 + f3);
#	    }
#	    return si;
#	}


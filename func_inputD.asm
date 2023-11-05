.global	inputD_func
.include "lib_macros.asm"

# function:
#	Input double from console
# arguments:
#	stack (+00) - D (output)
.text
inputD_func:
	cinD				# input double
	lw	t0, +0(sp)		# load result address
	fsd	fa0, (t0)		# store D (result)
	ret				# return


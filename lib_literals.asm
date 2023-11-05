#
.global lit_nl
.global lit_tab
.global lit_iad
.global lit_ibd
.global lit_ix1d
.global lit_ix2d
.global lit_tf
.global lit_ri
.global lit_ma_10
.global lit_res0
.global lit_expe
.global lit_res1
.global lit_coi
.global lit_params

.data
lit_nl:		.asciz	"\n"
lit_tab:		.asciz	"\t"
lit_iad:		.asciz	"Input  A, function argument (double): "
lit_ibd:		.asciz	"Input  B, function argument (double): "
lit_ix1d:	.asciz	"Input X1, left  boundary of integration (double): "
lit_ix2d:	.asciz	"Input X2, right boundary of integration (double): "
lit_tf:		.asciz	"The target function is: f(x) = a + b / (x * x)\n\n"
lit_ri:		.asciz	"Repeat input.\n"
lit_ma_10:	.asciz	"Function is not defined at point 0 (zero).\n"
lit_res0:	.asciz	"Result: "
lit_expe:	.asciz	"Expected: "
lit_res1:	.asciz	"Result  : "
lit_coi:		.asciz	"\nCalculate another integral? (Y/n): "
lit_params:	.asciz	"Parameters (A, B, X1, X2):\n"


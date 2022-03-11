
__maxRow:	# ra gives the max value from a0+0, a0+1, a0+2, ..., a0+a1 back
	# a0 = Startadress
	# a1 = Number of values to compare
	addi ra, zero, -128
	again:
	loadB t0, 0(a0)
	addi a1, a1, -1
	blt t0, ra, notchange
	add ra, zero, t0
	notchange:
	blt zero, a1, again
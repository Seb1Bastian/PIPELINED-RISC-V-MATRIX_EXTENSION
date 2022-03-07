__matrixAddWithOutSize:
	# a0 = Position of the first matrix

	# a2 = Position of the second matrix

	# a4 = number of rows
	# a5 = number of colums
	# a6 = postion of the addition matirx
	
	addi t4, a4, 0
	addi t5, a5, 0
	addi t6, a6, 0
	
	again:
	loadB t0, 0(a0)
	loadB t1, 0(a2)
	addB t2, t1, t0
	storeB t2, 0(t6)
	
	addi t5, t5 ,-1
	addi a0, a0, 1
	addi a2, a2, 1
	addi a6, a6, 1
	beq t5, zero, rowsf
	j again
	rowsf:
	addi t4, t4, -1
	beq t4, zero, finished
	j again
	finished:


__matrixSplit:
	# a0 = Position of the matrix
	# a1 = Position of writing
	
	lw t0, 3(zero)	#size of accelator
	lw t1, 0(a0)	#rows
	lw t2, 4(a0)	#columns
	
	add t3, zero, zero	# set t3 to zero
	add t4, zero, zero
	
	rowsagain:
	blt t1, t0, rowsf
	sub t1, t1, t0
	addi t3, t3, 1
	j rowsagain
	
	rowsf:
	columnsagian:
	blt t2, t0, columnsf
	sub t2, t2, t0
	addi t4, t4, 1
	j columnsagian
	
	columnsf:
	sw t3, 0(a1)	#numbers of rows in the (big) matrix
	sw t4, 4(a1)	#numbers of columns in the (big) matrix
	addi a1, a1, 8
	
	
	add a2, zero, zero		# index row
	add a3, zero ,zero		# index colum
	
	again:
	add a4, zero, a0		# position of big matrix
	add a5, zero, a1		# position of small matrix
	
	sw a2, 0(sp)
	sw a3, -4(sp)
	addi sp, sp, -8
	
	call __putPartofOneMatrixAsSmallMatrixInBigMatrix
	
	lw a3, 4(sp)
	lw a2, 8(sp)
	addi sp, sp, 8
	addi a3, a3, 1			# increase colum index
	lw t3, -4(a1)
	beq t3, a3 oneRowComp
	j again
	
	oneRowComp:
	addi a2, a2, 1			# increase row index
	add a3, zero, zero		# set colum index to zero
	lw t4, -8(a1)
	beq a2, t4 allComp
	j again
	
	allComp:
	
	
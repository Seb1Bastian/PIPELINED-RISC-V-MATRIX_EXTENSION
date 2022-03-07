__bigMatrixMult:
	# a0 = Position of the first (big) matrix
	# a1 = Position of the second (big) matrix
	# a2 = postion of the result (big) matirx
	
	lw t0, 0(a0)	#rows matrix 1
	lw t1, 4(a0)	#colum matrix 1
	lw t2, 0(a1)	#rows matrix 2
	lw t3, 4(a1)	#colum matrix 2
	
	sw t0, 0(a2)	#sets size for result (big) matrix
	sw t3, 4(a2)
	
	addi a2, a2, 8
	
	add t4, zero, zero	#index row (for the result)
	add t5, zero, zero	#index colum
	
	
	
	sw a0, 0(sp)		# save parameters
	sw a1, -4(sp)
	sw a2, -8(sp)
	sw s0, -12(sp)		# save s0, s1
	sw s1, -16(sp)
	sw s2, -20(sp)		# save s0, s1, s2, s3
	sw s3, -24(sp)
	addi sp, sp, -28	
	lw s0, 4(zero) 		# size of accellerator
	lw s1, 4(zero)
	
	add s2, zero, zero	#index
	add s3, zero, zero

	again:
	add a3, zero, a2	#pointer to next matrix comes at adress 0(a2 old)
	addi a2, a2, 4	
	setZero:		# sets the first part Matrix to zero
	storeB zero, 0(a2)
	addi s1, s1, -1
	addi a2, a2, 1
	blt zero, s1, setZero
	addi s0, s0, -1
	lw s1, 4(zero)
	blt zero, s0, setZero
	
	addi ra, zero, -3
	and a2, a2, ra		# sets the last two digits to zero, xxxx becomes xx00
	sw a2, 0(a3)		# set adress to next (small) matrix
	addi a5, a2, 4
	
	add a0, zero, s2
	add a1, zero, s3
	lw a2, 28(sp)
	lw a3, 24(sp)
	lw a4, 20(sp)
	# a0 = row index of result
	# a1 = colum index of result
	# a2 = (big)matrix 1 adress
	# a3 = (big) matrix 2 adress
	# a4 = result matrix adress
	# a5 = next free adress
	call multSmallMatrix
	
	lw t0, 4(zero)
	addi s3, s3, 1
	lw a0, 28(sp)		#set back to old parameters
	lw a1, 24(sp)
	add a2, zero, ra
	lw a2, 20(sp)
	blt s3, t0, again
	add s3, zero, zero
	addi s2, s2, 1
	blt s2, t0, again
	
	
	lw s3, 4(sp)
	lw s2, 8(sp)
	lw s1, 12(sp)
	lw s0, 16(sp)
	addi sp, sp, 28

__multSmallMatrix:  #computes one small matrix in the (big) result matrix
	# a0 = row index of result
	# a1 = colum index of result
	# a2 = (big)matrix 1 adress
	# a3 = (big) matrix 2 adress
	# a4 = result matrix adress
	# a5 = next free adress
	
	sw s4, -0(sp)
	sw s7, -4(sp)
	addi sp, sp, -8
	
	add s4, zero, a0	#rows matrix (1)
	add s7, zero, a1	#colum matrix (2)
	
	add s1, zero, zero
	
	sw a0, 0(sp)
	sw a1, -4(sp)
	sw a2, -8(sp)
	sw a3, -12(sp)
	sw a4, -16(sp)
	sw a5, -20(sp)
	addi sp, sp, -24
	
	next:
	add a0, zero, a2
	add a1, zero, s4
	add a2, zero, s1
	call smallMatrixAdress
	add t0, zero, ra
	add a0, zero, a3
	add a1, zero, s1
	add a2, zero, s7
	call smallMatrixAdress
	add a0, zero, t0
	add a1, zero, ra
	add a2, zero, a5
	call matrixMult
	
	
	addi a0, a4, 8		# a4 and a5 did not get changed
	addi a6, a4, 8
	addi a2, a5, 8
	
	lw a4, 4(zero)		# size of Matrix is size of Acc
	lw a5, 4(zero)
	call matrixAddtion
	
	lw a0, 24(sp)
	lw a1, 20(sp)
	lw a2, 16(sp)			# a3 did not change
	lw a4, 8(sp)
	lw a5, 4(sp)
	
	lw t0, 4(zero)
	addi s1, s1, 1
	ble s1, t0, next
	
	addi sp, sp, 24			# set stackpointer to the start location
	lw s4, 8(sp)
	lw s7, 4(sp)
	addi sp, sp, 8

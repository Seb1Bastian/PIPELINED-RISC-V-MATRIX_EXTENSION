__maxPool:
	# a0 = Matrix address	
	# a1 = size of MaxPools (radius) (a1=1 => 3x3)
	# a3 = Speichern der neuen Matrix
	sw s0, 0(sp)
	sw s1, -4(sp)
	sw s2, -8(sp)
	sw s3, -12(sp)
	sw s4, -16(sp)
	sw s5, -20(sp)
	addi sp, sp, -24
	
	lw s0, 0(a0)	#number rows
	lw s1, 4(a0)	#number colum
	
	sw s0, 0(a3)
	sw s1, 4(a3)
	addi a3, a3, 8

	add s2, zero, zero	# row index
	add s3, zero, zero	# colum index
	
	
	add t5, a1, a1	#sets the length for maxRow (how many to compare)
	addi t5, t5, 1
	
	nextIndex:
	add s5, zero, zero	# how many rows compared
	addi s4, zero, -128	#Register for the maxValue
	sub t2, s2, a1		#which row we are in	(index)
	sub t3, s3, a1		#where the row starts	(index)
	add t4, s3, a1		#where the row ends	(index)
	again:
	blt t3, zero, changeColumIndex
	blt s1, t4, changeLength
	changedColumIndex:
	changedLength:
	blt t2, zero, setToMin
	blt s0, t2, setToMin


	sw a0, 0(sp)		# save parameters
	sw a1, -4(sp)
	sw a2, -8(sp)
	sw t2, -12(sp)
	sw t3, -16(sp)
	sw t4, -20(sp)
	addi sp, sp, -24
	
	add a1, zero, s2
	add a2, zero, t3
	call getPositionFromIndex
	add a0, zero, ra
	add a1, zero, t5
	# a0 = Startadress
	# a1 = Number of values to compare
	call maxRow
	setedToMin:
	
	blt ra, s4, changeValue
	add s4, zero, ra
	changeValue:
	lw a0, 24(sp)		#load old parameters
	lw a1, 20(sp)
	lw a2, 16(sp)
	lw t2, 12(sp)
	lw t3, 8(sp)
	lw t4, 4(sp)
	addi sp, sp, 24
	add t5, a1, a1		#sets the length for maxRow (how many to compare)
	addi t5, t5, 1
	addi s5, s5, 1
	addi t2, t2, -1		# one row deeper(to find the maxValue in the a1 area)
	blt s5, t5, again	#compares if all rows are compared to find the max value
	
	
	storeB s4, 0(a3)
	addi a3, a3, 1
	addi s3, s3, 1
	blt s3, s1, again
	add s3, zero, zero
	addi s2, s2, 1
	blt s2, s0, again
	j finished
	
	
	setToMin:
	addi ra, zero, -128
	j setedToMin
	
	changeColumIndex:
	add t3, zero, zero
	j changedColumIndex
	
	changeLength:
	sub t5, s1, t1
	j changedLength
	
	
	finished:
	lw s5, 4(sp)
	lw s4, 8(sp)
	lw s3, 12(sp)
	lw s2, 16(sp)
	lw s1, 20(sp)
	lw s0, 24(sp)
	addi sp, sp, 24
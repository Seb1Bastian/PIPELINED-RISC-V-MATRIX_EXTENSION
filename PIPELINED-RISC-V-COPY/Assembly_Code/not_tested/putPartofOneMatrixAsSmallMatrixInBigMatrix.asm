

__putPartofOneMatrixAsSmallMatrixInBigMatrix:
	# a0 = numbers of rows matrix		(not needed)
	# a1 = numbers of columns matrix	(not needed)
	# a2 = row index
	# a3 = colum index
	# a4 = Position of the matrix
	# a5 = Position of writing
	
	# return next free Adress
	
	addi t4, zero, 0 	#row postion small matrix	# vielleicht müsste der startwert 0 seien
	addi t5, zero, 0	#colum postion small matrix
	lw t0, 3(zero)		#size of accelator
	sw t0, 0(a5)
	sw t0, 4(a5)
	addi a5, a5, 8
	
	sw s0, 0(sp)
	sw s1, -4(sp)
	sw s2, -8(sp)
	sw s3, -12(sp)
	sw s4, -16(sp)
	sw s5, -20(sp)
	sw s6, -24(sp)
	addi sp, sp, -28
	
	addi s0, t0, 0		# ending postion (row)
	addi s1, t0, 0		# ending postion (colum)
	add s2, zero, zero	# zähler für zeilen
	
	lw t1, 0(a4)
	lw t2, 4(a4)
	addi a4, a4, 8
	
	add s3, zero, zero	# row index in big Matrix
	add s4, zero, zero	#colum inedex in big Matrix
	
	# startpostion berechnen
	columns:
	beq a3, zero, columnsComplet
	add a4, a4, t0
	add s4, s4, t0
	add s0, s0, t0
	addi a3, a3, -1
	j columns
	
	columnsComplet:
	
	rows:
	beq a2, zero, rowsComplet
	add s2, zero, zero	# zähler für zeilen
	oneColum:
	add a4, a4, t2		#one row deeper
	addi s2, s2, 1
	addi s3, s3, 1		
	blt  s2, t0 oneColum
	addi a2, a2, -1
	add s1, s1, t0
	j rows
	
	rowsComplet:
	
	
	add s5, zero, s3
	moveNewRow:
	add s6, zero, s4
	# moving process
	moverow:
	beq s4, t2, checkZeros	#has to do padding?
	beq s3, t1, checkZeros
	loadB t3, 0(a4)
	addi a4, a4, 1
	addi t5, t5, 1
	addi s4, s4, 1
	storeB t3, 0(a5)
	addi a5, a5, 1
	
	beq t5, t0, rowdone
	beq s4, t2, checkZeros	#has to do padding?
	j moverow
	
	checkZeros:
	storeB zero, 0(a5)
	addi a5, a5, 1
	addi t5, t5, 1
	beq t5, t0, rowdone
	j checkZeros
	
	rowdone:
	addi s3, s3, 1
	addi t4, t4, 1
	add a4, a4, t2
	beq t4, t0, completdone
	j moveNewRow

	
	completdone:
	addi ra, zero, -3
	and ra, ra, a5	#sets the last two digits to zero, xxxx becomes xx00
	addi ra, ra, 4
	
	sw s6, 4(sp)
	sw s5, 8(sp)
	sw s4, 12(sp)
	sw s3, 16(sp)
	sw s2, 20(sp)
	sw s1, 24(sp)
	sw s0, 28(sp)
	addi sp, sp, 28
	
	
	
	

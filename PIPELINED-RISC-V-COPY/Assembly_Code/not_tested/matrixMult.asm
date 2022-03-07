matrixMult:
	#a0 = Adresse Matrix1
	#a1 = Adresse Matrix2
	#a2 = Speicheradresse von Ergebnis Matrix
	
	lw t0, 0(a0)	# get size of matrix
	lw t1, 4(a0)
	lw t2, 0(a1)
	lw t3, 4(a1)
	
	slli t4, t0, 24
	slli t4, t1, 16
	slli t4, t2, 8
	add t4, t4, t3
	sw t4, 0(a2)
	toAcc 0(a2)	# send size of matrizen to the accelerator
	
	sw t0, 0(a2)	# set size of result matrix
	sw t3, 4(a2)	
	
	addi a0, a0, 8	#set adress in a0 to the data beginning
	add t6, zero, t1
	startRowMone:
	beq t1, zero, rowCompletedMone
	toAccB 0(a0)
	addi a0, a0, 1
	addi t1, t1, -1
	j startRowMone
		
	rowCompleted:
	addi t0, t0, -1
	add t6, zero, t1
	beq t0, zero matrixOneComplet
	j startRowMone
	matrixOneComplet:
	
	addi a1, a1, 8	#set adress in a1 to the data beginning
	add t6, zero, t3
	startRowMtwo:
	beq t3, zero, rowCompletedMtwo
	toAccB 0(a1)
	addi a1, a1, 1
	addi t3, t3, -1
	j startRowMtwo
		
	rowCompletedMtwo:
	addi t2, t2, -1 
	add t6, zero, t3
	beq t2, zero matrixTwoComplet
	j startRowMtwo
	matrixTwoComplet:
	
	
	lw t0, 0(a2)
	lw t1, 4(a2)
	addi a2, a2, 8	#set adress in a2 to the data beginning
	add t6, zero, t1
	startReadRow:
	beq t1, zero, rowReadCompleted
	fromAccB 0(a2)
	addi a2, a2, 1
	addi t1, t1, -1
	j startReadRow
		
	rowReadCompleted:
	addi t0, t0, -1
	add t6, zero, t1
	beq t0, zero readComplet
	j startReadRow
	readComplet:
	
	addi ra, zero, -3
	and ra, ra, a2	#sets the last two digits to zero, xxxx becomes xx00
	addi ra, ra, 4
	
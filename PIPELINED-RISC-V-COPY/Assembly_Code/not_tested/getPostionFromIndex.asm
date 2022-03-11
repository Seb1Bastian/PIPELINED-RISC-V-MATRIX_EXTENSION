
__getPositionFromIndex: # ra gives back the adresse for the value at postion(a1,a2)
	# a0 = postition of the matrix	
	# a1 = row-index
	# a2 = colum-index
	
	lw t0, 0(a0)
	lw t1, 4(a0)
	lw t2, 4(a0)
	addi a0, a0, 8
	columCheck:
	beq t1, zero columCompleted
	addi a0, a0, 1
	addi t1, t1, -1
	j columCheck
	columCompleted:
	
	rowCheck:
	beq zero, a1, rowCompleted
	addi a1, a1, -1
	add  a0, a0, t2
	j rowCheck
	rowCompleted:
	add ra, zero, a0
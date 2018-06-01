	.data
queueBegin:	.word	0x10011000
queueEnd:	.word	0x10011050
screen:		.word 	0x10010000
green:		.word	0x0000FF00

	.text
	.globl main
	
main:

	lw $t0, green

	lw $s0, queueBegin
	lw $s1, queueEnd
	li $s2, 0x10011000	# Logic Begin of the Queue
	li $s3, 0x10011004	# Logic End of the Queue
	li $s4, 3		# x_pos
	li $s5, 1		# y_pos
	li $t1, 0x10010084
	sw $t1, ($s2)		# Stores the tail's position on the screen
	
	li $t1, 0x10010088
	sw $t1, ($s3)
	
drawHead:
	# Computing Address of (x, y) on the screen
	sll $t1, $s5, 5
	add $t1, $t1, $s4
	sll $t1, $t1, 2
	li $t2, 0x10010000	# Start address on the screen
	add $t1, $t1, $t2
	sw $t0, ($t1)
	bne $s3, $s1, drawHead_if
	add $s3, $s0, $zero	# <- else reset
	j drawHead_fi
drawHead_if:	
	addi $s3, $s3, 4	# Pointer arithmetic
drawHead_fi:
	sw $t1, ($s3)		# Stores the new head address in the queue
	
eraseTail:
	lw $t1, ($s2)		# deferencing $s2 (eq in C to *pointer)
	sw $zero, ($t1)		# Clear the tail on the screen
	
	bne $s2, $s1, eraseTail_if
	add $s2, $s0, $zero	# <- else reset
	j wait
eraseTail_if:
	addi $s2, $s2, 4	# Pointer arithmetic
	
wait:
	li $a0, 100		#
	li $v0, 32		# Pause for 100 milisec
	syscall			#
	
	lw $s1, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $s1, 0x00000077, moveUp 	# w key is pressed
	beq $s1, 0x00000073, moveDown	# s key is pressed
	beq $s1, 0x00000061, moveLeft	# a key is pressed
	beq $s1, 0x00000064, moveRight	# d key is pressed
	beq $s1, 0x00000071, quit	# q key is pressed
	j moveRight
moveUp:
	subi, $s5, $s5, 1
	beq $s5, -1, quit
	j drawHead
moveDown:
	addi, $s5, $s5, 1
	beq $s5, 32, quit
	j drawHead
moveLeft:
	subi, $s4, $s4, 1
	beq $s4, -1, quit
	j drawHead
moveRight:
	addi, $s4, $s4, 1
	beq $s4, 32, quit
	j drawHead

quit:
	li $v0, 10
	syscall

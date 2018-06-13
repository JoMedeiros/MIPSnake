#################################################################
# 	Display Configuration					#
#---------------------------------------------------------------#
#	Unit Width in pixels: 8					#
#	Unit Height in Pixels: 8				#
#	Display Width in Pixels: 256				#
#	Display Height in Piexels: 256				#
#---------------------------------------------------------------#
# Total units: (256/8) * (256/8) = 32 x 32 = 1024 pixels	#
#################################################################
	.data
# colors/ indicators
apple:		0xFFFF0000
snakeRight:	0x0000FFFF
snakeDown:	0x0100FF66
snakeLeft:	0x0200FF00
snakeUp:	0x03FFFF00
bg:		0x00005500

screen:		0x10010000	# Start address of the screen

	.text
############################################################################
# Here we use the first byte of the color word to store other informations
# 00 - moving Right | 01 - moving Down | 02 - moving Left | 03 moving Up
# these flags are useful to erase the tail
	lw $s0, snakeRight
	lw $s1, snakeDown
	lw $s2, snakeLeft
	lw $s3, snakeUp
	li $s4, 3		# Head x_pos
	li $s5, 1		# Head y_pos
	li $s6, 0x10010084	# Tracking the tail to erase
	lw $s7, snakeRight	# Current movement
	li $t0, 0x10010084	# Snake begin
	li $t1, 0x10010090	# Snake end --- total size: (end - begin)/4 
	lw $t3, screen
	li $t4, 0xFFFF0000	# Apple color
init:
	sw $s0, ($t0) 		# 
	addi $t0, $t0, 4 	# while SB < SE, fill the display with the snake body (size: 6/4??)
	blt $t0, $t1, init 	# initial size will be 2.

	jal generateApple
	addi $ra, $ra, 16	# jumps to the line after addi to avoid verification 
				# of self collision (the instruction: beq $t0, 0x0000FF00, quit)
	jr $ra
moveRight:
	move $s7, $s0
	jal drawHead
	addi $s4, $s4, 1
	
	li $a0, 100		#
	li $v0, 32		# Pause for 100 milisec
	syscall			#
	
	lw $t7, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $t7, 0x00000077, moveUp 	# w key is pressed
	beq $t7, 0x00000073, moveDown	# s key is pressed
	beq $t7, 0x00000071, quit	# q key is pressed
	j moveRight
moveDown:
	move $s7, $s1
	jal drawHead
	addi $s5, $s5, 1
	
	li $a0, 100		#
	li $v0, 32		# Pause for 100 milisec
	syscall			#
	
	lw $t7, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $t7, 0x00000061, moveLeft	# a key is pressed
	beq $t7, 0x00000064, moveRight	# d key is pressed
	beq $t7, 0x00000071, quit	# q key is pressed
	j moveDown
moveLeft:
	move $s7, $s2
	jal drawHead
	subi $s4, $s4, 1
	
	li $a0, 100		#
	li $v0, 32		# Pause for 100 milisec
	syscall			#
	
	lw $t7, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $t7, 0x00000077, moveUp 	# w key is pressed
	beq $t7, 0x00000073, moveDown	# s key is pressed
	beq $t7, 0x00000071, quit	# q key is pressed
	j moveLeft
moveUp:
	move $s7, $s3
	jal drawHead
	subi $s5, $s5, 1
	
	li $a0, 100		#
	li $v0, 32		# Pause for 100 milisec
	syscall			#
	
	lw $t7, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $t7, 0x00000061, moveLeft	# a key is pressed
	beq $t7, 0x00000064, moveRight	# d key is pressed
	beq $t7, 0x00000071, quit	# q key is pressed
	j moveUp
drawHead:
	# Computing Address of (x, y) on the screen
	sll $t1, $s5, 5 	
	add $t1, $t1, $s4
	sll $t1, $t1, 2
	li $t2, 0x10010000	# Start address on the screen
	add $t1, $t1, $t2	# Terminate couting address
	lw $t0, ($t1)
	and $t0, $t0, 0x0000FF00
	beq $t0, 0x0000FF00, quit
	sw $s7, ($t1)
	bne $t3, $s6, eraseTail
	j generateApple

eraseTail:
	lw $t6, ($s6)
	sw $zero, ($s6)		# Clear the tail on the screen
	beq $t6, $s0, eraseRight
	beq $t6, $s1, eraseDown
	beq $t6, $s2, eraseLeft
	beq $t6, $s3, eraseUp
	jr $ra
eraseRight:
	addi $s6, $s6, 4	# next pixel to erase
	jr $ra
eraseDown:
	addi $s6, $s6, 128
	jr $ra
eraseLeft:
	subi $s6, $s6, 4
	jr $ra
eraseUp:
	subi $s6, $s6, 128
	jr $ra
	
generateApple:
# Generate random number ---------------------------------
	li $a1, 102	# Here $a1 configures the max value wich is the number of units on display (0 til 1023).
    	li $v0, 42  	#generates the random number.
    	syscall
    	
    	li $v0, 1   #1 print integer
    	syscall
#---------------------------------------------------------    	
# Painting apple pixel
	move $t0, $a0
	sll $t0, $t0, 2
	add $t3, $t3, $t0 #!
	sw $t4, ($t3) #! t3 = screen. comparation with t3 to branch to erase tail
#---------------------------------------------------------
	jr $ra
	
quit:
	li $v0, 10
	syscall
	
# TODO Here may come the score or clear the screen...
	





#################################################################
# 	Display Configuration					#
#---------------------------------------------------------------#
#	Unit Width in pixels: 8					#
#	Unit Height in Pixels: 8				#
#	Display Width in Pixels: 256 - PREVIOUS			#
#	Display Width in Pixels: 512				#
#	Display Height in Piexels: 256				#
#---------------------------------------------------------------#
# Total units: (256/8) * (256/8) = 32 x 32 = 1024 pixels - PRV	#
# Total units: (512/8) * (256/8) = 64 x 32 = 2048 pixels	#
#################################################################

#########################################################################################
# Here we use the first byte of the color word to store other informations		#
# 00 - moving Right | 01 - moving Down | 02 - moving Left | 03 moving Up		#
# these flags are useful to erase the tail						#
	.data				#------------------------			#
				       	# FLAG    | R  | G  | B   			#
screenStart:	.word 0x10010200	#			#
apple:		.word 0xFFFF0000 	# FF (DM) | 00 | FF | 00  ----APPLE		#
snakeRight:	.word 0x0000FF00 	# 00      | 00 | FF | 00  --|			#
snakeDown:	.word 0x0100FF00	# 01      | 00 | FF | 00    |-MOVEMENT		#
snakeLeft:	.word 0x0200FF00	# 02      | 00 | FF | 00    |			#
snakeUp:	.word 0x0300FF00	# 03      | 00 | FF | 00  --|			#
arenaBG:	.word 0xBBBBFFFF	# BB      | B2 | 22 | 22  ----BACKGROUND COLOR	#
					#------------------------			#									#
#* DM = Dont matter									#
#########################################################################################

#################################################################################################
#	Macros:											#
#	       _____										#
	.macro Pause										#
		li $a0, 200	#								#
		li $v0, 32	# Pause for 100 milisec						#
		syscall		#								#
	.end_macro										#
												#	
#-----------------------------------------------------------------------------------------------#
#	       __________
	.macro PaintArena 
		li $t0, 128 #starting line index [halved line size]
		li $t1, 0 #starting pixel index
		lw $t3, screenStart # load starting address on s3		
		lw $t2, arenaBG #load bg color on s2	
	drawline:
		sw $t2, ($t3)		# paint pixel_address
		addi $t3, $t3, 4	# pixel_adress++
		addi $t1, $t1, 4	# pixel_i++
		blt $t1, $t0, drawline	# if pixel_index < (line_size/2), keep painting line
		addi $t3, $t3, 128	# 	else, jump pixel_adress to next beginning line.
		addi $t1, $t1, 128	# 	jump pixel_i to next beginning line.
		addi $t0, $t0, 256	# 	line_i++.
		ble  $t0, 7552, drawline# if not finished painting line, do it again
					# (29*line_size)+(line_size/2)=7552
	.end_macro

#---------------------------------------------------------------------------------------------#
	
#	.macro ChkIfInsideArena
#		li $a0, 100	#
#		li $v0, 32	# Pause for 100 milisec
#		syscall		#
#	.end_macro
#########################################################


######################################################################
	.text
	
	PaintArena		#Paint the arena
	
	Pause
	Pause
	Pause
	Pause
	Pause

	lw $s0, snakeRight
	lw $s1, snakeDown
	lw $s2, snakeLeft
	lw $s3, snakeUp
	li $s4, 3		# Head x_pos
	li $s5, 1		# Head y_pos
	li $s6, 0x10010404	# Tracking the tail to erase
	lw $s7, snakeRight	# Current movement
	li $t0, 0x10010404	# Snake begin
	li $t1, 0x10010410	# Snake end --- total size: (end - begin)/4 
	lw $t3, screenStart
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
	
	Pause
	
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
	
	Pause
	
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
	
	Pause
	
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
	
	Pause
	
	lw $t7, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $t7, 0x00000061, moveLeft	# a key is pressed
	beq $t7, 0x00000064, moveRight	# d key is pressed
	beq $t7, 0x00000071, quit	# q key is pressed
	j moveUp

#-------------------------------------------------------------------------------------------------------------#
drawHead:	#local reg: $t7, $t0

# Computing Address of (x, y) on the screen

	sll $t1, $s5, 6 	# t1 = s5 * (2^6) = s5 * 64		(computing y)
	add $t1, $t1, $s4	# t1 += s4				(computing x) 
	sll $t1, $t1, 2		# 					(coordenate -> address)
	lw $t2, screenStart	# Start address on the screen
	add $t1, $t1, $t2	# Terminate couting address of new head
	lw $t0, ($t1)		# Takes data stored at new head for comparation

	# switch
	beq $t0, 0xFFFF0000, okayHead	# if is new head is apple, jump bg verification; else
	bne $t0, 0xBBBBFFFF, quit	# if new head address is NOT on the arena, quit
okayHead: 
	sw $s7, ($t1)		# else, store it at $CurrentMovement register
	bne $t3, $s6, eraseTail #???????????????????
	j generateApple
	
#--------------------------------------------------------------------------------------------------------------#
eraseTail:	#local reg: $t7, $t6
	lw $t6, ($s6)		# save previous value of tail
	lw $t7, arenaBG		# load arenaBG color
	sw $t7, ($s6)		# Clear the tail on the screen (replace with arena color)
	beq $t6, $s0, eraseRight
	beq $t6, $s1, eraseDown
	beq $t6, $s2, eraseLeft
	beq $t6, $s3, eraseUp
	jr $ra
eraseRight:
	addi $s6, $s6, 4	# next pixel to erase
	jr $ra
eraseDown:
	addi $s6, $s6, 256
	jr $ra
eraseLeft:
	subi $s6, $s6, 4
	jr $ra
eraseUp:
	subi $s6, $s6, 256
	jr $ra
	
generateApple:
# Generate random number ---------------------------------
	li $a1, 102	# Here $a1 configures the max value wich is the number of units on display (0 til 1023).
    	li $v0, 42  	#generates the random number.
    	syscall
    	
    	li $v0, 1   #1 print integer
    	syscall
# Verify if it's inside the playabe area -----------------

# Painting apple pixel -----------------------------------
	move $t0, $a0
	sll $t0, $t0, 2
	add $t3, $t3, $t0
	sw $t4, ($t3)
#---------------------------------------------------------
	jr $ra

quit:
	li $v0, 10
	syscall
	
# TODO Here may come the score or clear the screen...
	

#################################################################
# 	Display Configuration					#
#---------------------------------------------------------------#
#	Unit Width in pixels: 8					#
#	Unit Height in Pixels: 8				#
#	Display Width in Pixels: 512				#
#	Display Height in Piexels: 256				#
#---------------------------------------------------------------#
# Total units: (512/8) * (256/8) = 64 x 32 = 2048 pixels	#
# Arena units: (256/8) * (216/8) = 32 x 27 = 864 pixels		#
#################################################################

#########################################################################################
# Here we use the first byte of the color word to store other informations		#
# 00 - moving Right | 01 - moving Down | 02 - moving Left | 03 moving Up		#
# these flags are useful to erase the tail						#
	.data				#------------------------
# Colors			       	# FLAG    | R  | G  | B   			#
scoreColor:	.word 0x00FFFF00       	# 00      | FF | FF | 00			#
arenaBG:	.word 0xBBBBFFFF	# BB      | B2 | 22 | 22  ----BACKGROUND COLOR	#
appleColor:	.word 0xFFFF0000 	# FF (DM) | FF | 00 | 00			#
snakeRight:	.word 0x0000FF00 	# 00      | 00 | FF | 00  --|			#
snakeDown:	.word 0x0100FF00	# 01      | 00 | FF | 00    |- MOVEMENT		#
snakeLeft:	.word 0x0200FF00	# 02      | 00 | FF | 00    |			#
snakeUp:	.word 0x0300FF00	# 03      | 00 | FF | 00  --|			#
					#------------------------			#									#
#* DM = Dont matter									#
# Addresses	------------------------------------------------------------------------
screenStart:	.word 0x10010500
add_end_flag:	.word 0x1fffff0f
# # # Numbers
dozen_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                      0x10011394, 0x10011398, 0x1001139C,
                      0x10011494, 0x10011498, 0x1001149C,
                      0x10011594, 0x10011598, 0x1001159C,
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f

dozen0_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                      0x10011394,             0x1001139C,
                      0x10011494,             0x1001149C,
                      0x10011594,             0x1001159C,
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f

dozen1_start:	.word                         0x1001129C,
                                              0x1001139C,
                                              0x1001149C,
                                              0x1001159C,
		                              0x1001169C, 0x1fffff0f

dozen2_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                                              0x1001139C,
                      0x10011494, 0x10011498, 0x1001149C,
                      0x10011594,             
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f
		      
dozen3_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                                              0x1001139C,
                      0x10011494, 0x10011498, 0x1001149C,
                                              0x1001159C,
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f
		      
dozen4_start:	.word 0x10011294,             0x1001129C,
                      0x10011394,             0x1001139C,
                      0x10011494, 0x10011498, 0x1001149C,
                                              0x1001159C,
                                              0x1001169C, 0x1fffff0f
		      
dozen5_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                      0x10011394,
                      0x10011494, 0x10011498, 0x1001149C,
                                              0x1001159C,
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f

dozen6_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                      0x10011394,
                      0x10011494, 0x10011498, 0x1001149C,
                      0x10011594,             0x1001159C,
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f

dozen7_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                                              0x1001139C,
                                              0x1001149C,
                                              0x1001159C,
		                              0x1001169C, 0x1fffff0f

dozen8_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                      0x10011394,             0x1001139C,
                      0x10011494, 0x10011498, 0x1001149C,
                      0x10011594,             0x1001159C,
		      0x10011694, 0x10011698, 0x1001169C, 0x1fffff0f
		      
dozen9_start:	.word 0x10011294, 0x10011298, 0x1001129C,
                      0x10011394,             0x1001139C,
                      0x10011494, 0x10011498, 0x1001149C,
                                              0x1001159C,
		                              0x1001169C, 0x1fffff0f

#################################################################################################

#################################################################################################
#	Macros:											
#	       _____										
	.macro Pause										
		li $a0, 100	#								
		li $v0, 32	# Pause for 80 milisec						
		syscall		#								
	.end_macro

	.macro MegaPause
		li $a0, 500	#								
		li $v0, 32	# Pause for 500 milisec						
		syscall		#								
	.end_macro											
													
#-----------------------------------------------------------------------------------------------#
#	       __________
	.macro PaintArena 
		li $t0, 128 #starting line index [halved line size]
		li $t1, 0 #starting pixel index
		lw $t3, screenStart # load starting address on t3		
		lw $t2, arenaBG #load bg color on t2	
	drawline:
		sw $t2, ($t3)		# paint pixel_address
		addi $t3, $t3, 4	# pixel_adress++
		addi $t1, $t1, 4	# pixel_i++
		blt $t1, $t0, drawline	# if pixel_index < (line_size/2), keep painting line
		addi $t3, $t3, 128	# 	else, jump pixel_adress to next beginning line.
		addi $t1, $t1, 128	# 	jump pixel_i to next beginning line.
		addi $t0, $t0, 256	# 	line_i++.
		ble  $t0, 6784, drawline# if not finished painting line, do it again
					# (27*line_size)+(line_size/2)=6784
	.end_macro
#-----------------------------------------------------------------------------------------------#
#	       _________
	.macro ScorePlusPlus
		addi $s0, $s0, 1
	.end_macro
	
#	       _________
	.macro SaveDispVal
		move $s1, $t4	# save current unit value
		move $s2, $t5	# save current dozen value
		move $s3, $t6	# save current unit value
	.end_macro

#################################################################################################


#################################################################################################
	.text
	
	PaintArena		#Paint the arena

	
	# Loading starting values...
	li $s0, 3		# load initial score (size of the initial snake)
	li $s4, 3		# Head x_pos
	li $s5, 2		# Head y_pos
	li $s6, 0x10010704	# Tracking the tail to erase
	lw $s7, snakeRight	# Current movement
	
	# for init
	li $t0, 0x10010704	# Snake begin
	li $t1, 0x10010710	# Snake end --- total size: (end - begin)/4
	li $t4, 0xFFFF0000	# Apple color
initialSnake:
	
	sw $s7, ($t0) 			#
	addi $t0, $t0, 4 		# while SB < SE, fill the display with the snake body (size: 6/4??)
	blt $t0, $t1, initialSnake 	# initial size will be 2.

	jal generateApple
	addi $ra, $ra, 20	# jumps to the line after addi to avoid verification 
				# of self collision (the instruction: beq $t0, 0x0000FF00, quit)
	jr $ra
moveRight:
	lw $s7, snakeRight
	jal drawHead
	addi $s4, $s4, 1
				#init line 89 will jump here
	Pause
	
	lw $t7, 0xFFFF0004		# Verifying which key is pressed
					# OBS: This value stays on the register until another key is pressed
	beq $t7, 0x00000077, moveUp 	# w key is pressed
	beq $t7, 0x00000073, moveDown	# s key is pressed
	beq $t7, 0x00000071, quit	# q key is pressed
	j moveRight
moveDown:
	lw $s7, snakeDown
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
	lw $s7, snakeLeft
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
	lw $s7, snakeUp
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
drawHead:	#local reg: t0, t1, t7

# Computing Address of (x, y) on the screen

	sll $t1, $s5, 6 	# t1 = s5 * (2^7) = s5 * 128		(computing y)
	add $t1, $t1, $s4	# t1 += s4				(computing x) 
	sll $t1, $t1, 2		# 					(coordenate -> address)
	lw $t2, screenStart	# Start address on the screen
	add $t1, $t1, $t2	# Terminate couting address of new head
	lw $t7, ($t1)		# Takes data stored at new head for comparation
	
	# checking if new head address is valid
	bne $t7, 0xFFFF0000, checkBG	# if next head add is not apple, check if it is BG
	sw $s7, ($t1)			# draw head on bitmap display
	
	move $t9, $ra
	j scoreUp
drawHead2:
	move $ra, $t9
	j generateApple			# skip tail erasure, and generate apple
	jr $ra
checkBG:
	bne $t7, 0xBBBBFFFF, quit
	sw $s7, ($t1)	#draw head on bitmap display
			# and proceed to erase tail
	
#--------------------------------------------------------------------------------------------------------------#

eraseTail:	#local reg: $t7, $t6, t3
	lw $t6, ($s6)		# save previous value of tail
	lw $t7, arenaBG		# load arenaBG color
	sw $t7, ($s6)		# Clear the tail on the screen (replace with arena color)
	lw $t3, snakeRight
	beq $t6, $t3, eraseRight
	lw $t3, snakeDown
	beq $t6, $t3, eraseDown
	lw $t3, snakeLeft
	beq $t6, $t3, eraseLeft
	lw $t3, snakeUp
	beq $t6, $t3, eraseUp
	jr $ra
eraseRight:
	addi $s6, $s6, 4	# next pixel to become the tail (x++)
	jr $ra
eraseDown:
	addi $s6, $s6, 256	# next pixel to become the tail (y++)
	jr $ra
eraseLeft:
	subi $s6, $s6, 4	# next pixel to become the tail (x--)
	jr $ra
eraseUp:
	subi $s6, $s6, 256 	# next pixel to become the tail (y--)
	jr $ra

#--------------------------------------------------------------------------------------------------------------#
	
generateApple:
# Generate random number ---------------------------------
	li $a1, 1112	# Here $a1 configures the max value wich is the number of units on display (0 til 1023).
    	li $v0, 42  	#generates the random number.
    	syscall
# Verify if it's inside the playabe area -----------------
	move $t0, $a0		# 
	sll $t0, $t0, 2		# Computing new apple address
	lw $t3, screenStart	#
	add $t3, $t3, $t0	#
	lw $t0, ($t3)		# get new add content
	bne $t0, 0xBBBBFFFF, generateApple	# if new apple address content is not arenaBG, try again
# Painting apple pixel -----------------------------------
	lw $t0, appleColor
	sw $t0, ($t3)
	
	jr $ra
#---------------------------------------------------------

################################################################################################################
#Calculate Score Units, Dozens and Hundreds --------------------------------------------------------------------
calcScoreDisp:	#args: t0. 
		#results: t4, t5, t6
	
	li $t1, 10
	li $t2, 100
	# Units
	div $t0, $t1 	# div score 10
	mfhi $t4	# print (score mod 10)

	# Dozens:
	mflo $t7 	# score/10
	div $t7, $t1	# div (score/10) 10
	mfhi $t5	# print ((score/10) mod 10)

	# Hundreds:
	div $t6, $t0, $t2 # print (score / 100)
	
	jr $ra

###############################################################################################

scoreUp:
	ScorePlusPlus		# score++
	move $t0, $s0		# move new score to calc Scores to be displayed
	jal calcScoreDisp
	beq $s0, 864, quitWin	# max score
	jal paintDisplay
	SaveDispVal		# save display numbers on s1 (units) , s2 (dozens) and s3 (hundreds).
	j drawHead2

# Paint Switch ---------------------------------------------------------------------------------------------------
paintDisplay:
	move $t8, $ra  # save link
	# prepare Units	------------------------------------------------------------
	li $t7, 1		# code 1: painting units
	jal paintBlack

	move $t2, $t4		# pass the number to be painted (t4 have the Units)		
	lw $t1, scoreColor		# Prepare to paint score color (load color)
	jal chooseNumber
	
	# prepare Dozens	------------------------------------------------------------
#	bne $t6, $s2, paintDoz
#	jr $t8			#only units changed, no need to paint anymore
paintDoz:
	li $t7, 2		# code 2: painting dozens
	jal paintBlack

	move $t2, $t5		# pass the number to be painted (t5 = Dozens)
	lw $t1, scoreColor	# Prepare to paint score color (load color)	
	jal chooseNumber

	# prepare Hundreds	------------------------------------------------------------
#	bne $t6, $s3, paintHun
#	jr $t8			# only changed till dozens, no need to paint anymore
paintHun:
	li $t7, 3		# code 3: painting hundreds	
	jal paintBlack
	
	move $t2, $t6		# pass the number to be painted (t6 = Hundred)
	lw $t1, scoreColor	# Prepare to paint score color (load color)	
	jal chooseNumber
	jr $t8			# finished painting display, go back.
	
	# decide what to paint: ------------------------------------------------------------
chooseNumber:	#arg: t2, number to be painted
	beq $t2, 0, paint0	
	beq $t2, 1, paint1
	beq $t2, 2, paint2
	beq $t2, 3, paint3
	beq $t2, 4, paint4
	beq $t2, 5, paint5
	beq $t2, 6, paint6
	beq $t2, 7, paint7
	beq $t2, 8, paint8
	j paint9
	jr $ra

# 		Paint Number --------------------------------------------------------------------------------------------
paint0:
	la $t0, dozen0_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint1:
	la $t0, dozen1_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint2:
	la $t0, dozen2_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint3:
	la $t0, dozen3_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint4:
	la $t0, dozen4_start	# load address from score array start
	j drawScore_compAdd
	jr $ra	
paint5:
	la $t0, dozen5_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint6:
	la $t0, dozen6_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint7:
	la $t0, dozen7_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint8:
	la $t0, dozen8_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
paint9:
	la $t0, dozen9_start	# load address from score array start
	j drawScore_compAdd
	jr $ra
	
# ------------------
paintBlack:
	la $t0, dozen_start
	li $t1, 0

# Display painting --------------------------------------------------------------------------------------------
drawScore_compAdd:	# args: (t0, t7, t1)	t0 = array_begin_add; t7 = draw_code [1,3]; t1 = color

	lw $t3, ($t0)			# load *array address on t3 
	beq $t3, 0x1fffff0f , draw_quit	# if t3 is end of array, quit
					# now modify adress (t3) if needed:
	beq $t7, 1, ds_Unt		# 	it's Untis. Then it's 4 pixels ahead (+16)
	beq $t7, 2, drawScore_paint	#	it's Dozens. Then maintin original address
	subi $t3, $t3, 16		# 	it's Hundreds. Then it's 4 pixels behind (-16)
	j drawScore_paint
ds_Unt:
	addi $t3, $t3, 16	
drawScore_paint:
	sw $t1, ($t3)			# paint pixel *t3
	addi $t0, $t0, 4		# advance @array
	j drawScore_compAdd
draw_quit:
	jr $ra

################################################################################################################
quitWin:
	# mensagem feliz
quit:
	add $a0, $zero, $s0	#
	li $v0, 1	# print score
    	syscall		#
    	
	li $v0, 10	# safe quit
	syscall		#

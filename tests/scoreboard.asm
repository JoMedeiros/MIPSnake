# -------------------------------
# scoreboard: draw dozens 0.
#---------------------------------------------------------------------------------------------
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
#---------------------------------------------------------------------------------
#	       _________
	.macro Terminate
		li $v0, 10
		syscall
	.end_macro

#	       _____
	.macro Pause										
		li $a0, 500	#								
		li $v0, 32	# Pause for 500 milisec						
		syscall		#								
	.end_macro
#---------------------------------------------------------------------------------
#	       _________
	.macro ScoreUp
		addi $s0, $s0, 1
	.end_macro
	
#	       _________
	.macro SaveDispVal
		move $s1, $t4	# save current unit value
		move $s2, $t5	# save current dozen value
		move $s3, $t6	# save current unit value
	.end_macro
#---------------------------------------------------------------------------------

################################################################################################
	.data
# Score
score: 		0	#initial score
# Colors
arenaBG:	.word 0xBBBB0000	# blue
scoreBG:	.word 0x00FFFF00	# yellow

# Addresses --------------------------
screenStart:	.word 0x10010500
score_add_end:	.word 0x1fffff0f
# # # Number
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

################################################################################################

################################################################################################
	.text
	PaintArena
	
	lw $s0, score
	move $t0, $s0	# move $0 to calc Scores to be displayed
	jal calcScoreDisp
	
	SaveDispVal	# Save current calculated display values	

	# for debbug purposes __________________________________________________________________
loop:
	ScoreUp		# update score

	move $t0, $s0	# move new score to calc Scores to be displayed
	jal calcScoreDisp
	beq $s0, 300, finishedPainting	#exit loop	
	jal paintDisplay
loop2:
	SaveDispVal
	Pause
	j loop
	
	# units always change. update units
	# compare dozens. if change,
	#	update dozens to new value
	#	compare hundreds. if change,
	#		update hundreds.
	#go back

# free reg: t0, t1, t2, t3, t7

# Paint Switch ---------------------------------------------------------------------------------------------------
paintDisplay:
	# prepare Units	------------------------------------------------------------
	li $t7, 1		# code 1: painting units
	jal paintBlack

	move $t2, $t4		# pass the number to be painted (t4 have the Units)		
	lw $t1, scoreBG		# Prepare to paint score color (load color)
	jal chooseNumber

	# prepare Dozens	------------------------------------------------------------
	beq $t5, $s2, loop2	# only units changed, no need to paint anymore

	li $t7, 2		# code 2: painting dozens
	jal paintBlack

	move $t2, $t5		# pass the number to be painted (t5 = Dozens)
	lw $t1, scoreBG		# Prepare to paint score color (load color)	
	jal chooseNumber

	# prepare Hundreds	------------------------------------------------------------
	beq $t6, $s3, loop2	# only changed till dozens, no need to paint anymore
	li $t7, 3		# code 3: painting hundreds	
	jal paintBlack
	lw $t1, scoreBG		# Prepare to paint score color (load color)	
	move $t2, $t6		# pass the number to be painted (t6 = Hundred)
	jal chooseNumber
	jr $ra
	
	# 	prepare Hundreds	------------------------------------------------------------
chooseNumber:	#arg: t2, number to be painted
	beq $t2, 0, paint0	# decide what to paint:
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

#----------------------------------------------------------------------------------------------------------------
quit:
	Terminate
	
finishedPainting:
	lw $a0, score
	li $v0, 1   # print integer
	syscall
	Terminate
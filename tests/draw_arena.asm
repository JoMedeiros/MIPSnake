# ------------------------------------------------------------------------
# 32 x 32 yellow display on 64 x 32 display				 #
#									 #
#	pixel_size = 4							 #
#	line_size = pixel_size * 64 = 256				 #
#	half line = 128							 #
# 	last yellow pixel will be at (31*line_size)+(line_size/2) = 8064 #
#									 #
# all calculations will be done using the base adress			 #
# ------------------------------------------------------------------------


#########################################################################################
# Here we use the first byte of the color word to store other informations		#
# 00 - moving Right | 01 - moving Down | 02 - moving Left | 03 moving Up		#
# these flags are useful to erase the tail						#
	.data				#------------------------			#
				       	# FLAG    | R  | G  | B   			#
screenStart:	.word 0x10010000	# 10      | 01 | 00 | 00 			#
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
		li $a0, 100	#								#
		li $v0, 32	# Pause for 100 milisec						#
		syscall		#								#
	.end_macro										#
												#	
#-----------------------------------------------------------------------------------------------#
#	       __________
	.macro PaintArena 
		li $s0, 128 #starting line index [halved line size]
		li $s1, 0 #starting pixel index
		
		lw $s2, arenaBG #load yellow color on s2
	
	paintline:
		sw $s2, screenStart($s1)		# paint pixel(address+t1)
		addi $s1, $s1, 4		# t1++ [pixel++]
		blt $s1, $s0, paintline		# if t1 < (line_size/2), keep painting line
		addi $s1, $s1, 128		# 	else, jump t1 to next line.
		addi $s0, $s0, 256		# 	line++.
		ble  $s0, 8064, paintline	# if not finished painting line, do it again
						# (31*line_size)+(line_size/2)=8064
	.end_macro

#---------------------------------------------------------------------------------------------#

# ------------------------------------------------------------------------
	.data
#	addres:	.word 0x00FFFF00	#base adress
	addres:	.word 0x10010000
	yellow:	.word 0x0000FF00	#color
	
	
	.macro Terminate
		li $v0, 10
		syscall
	.end_macro
	
	.macro DrawArena
		li $s0, 128 #starting line index [halved line size]
		li $s1, 0 #starting pixel index
		
		lw $s2, yellow #load yellow color on s2
	
	paintline:
		sw $s2, addres($s1)		# paint pixel(address+t1)
		addi $s1, $s1, 4		# t1++ [pixel++]
		blt $s1, $s0, paintline		# if t1 < (line_size/2), keep painting line
		addi $s1, $s1, 128		# 	else, jump t1 to next line.
		addi $s0, $s0, 256		# 	line++.
		ble  $s0, 8064, paintline	# if not finished painting line, do it again
						# (31*line_size)+(line_size/2)=8064
	.end_macro

	.text   
	DrawArena
quit:
	Terminate

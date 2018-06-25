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
	.macro Terminate
		li $v0, 10
		syscall
	.end_macro

# ------------------------------------------------------------------------
	.data
	addres:	.word 0x00FFFF00	#base adress
	yellow:	.word 0x00FFFF00	#color

	.text   
main:
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
quit:
	Terminate

# -------------------------------
# yellow blinking display
# -------------------------------
	.macro Terminate
		li $v0, 10
		syscall
	.end_macro

	.data
	addres:	.word 0x00FFFF00
	yellow:	.word 0x00FFFF00

	.text   
main:
	li $s0, 128 #line index
	li $s1, 0 #pixel index
		
	lw $s2, yellow #carrega a cor amarela em t4
	
paintline:
	sw $s2, addres($s1)		# paint pixel(address+t1)
	addi $s1, $s1, 4		# t1++ [pixel++]
	blt $s1, $s0, paintline		# if t1 < linesize, keep painting line
	addi $s1, $s1, 128		# 	else, jump t1 to next line.
	addi $s0, $s0, 256		# 	line++.
	ble  $s0, 8064, paintline	# if not finished painting line, do it again
quit:
	Terminate

# -------------------------------
# yellow blinking display
# -------------------------------
	.macro Terminate
		li $v0, 10
		syscall
	.end_macro

	.data
addres:	.word 0x00FFFF00, 0x00FFFF00, 0x00FFFF00, 0x00FFFF00
yellowline:	.word 0x00FFFF00, 0x00FFFF00, 0x00FFFF00, 0x00FFFF00
redline:	.word 0xFFFF0000, 0xFFFF0000, 0xFFFF0000, 0xFFFF0000

	.text   
main:
	li $t0, 0 #blinking times
	li $t7, 5 #max blinking times
	li $t1, 0
	li $t2, 4
	li $t3, 0x1000 #size of the display
#	li $t3, 0x8 #4 pixels
	
	lw $t4, yellowline($t1) 
	
yellow:
	sw $t4, addres($t1)
	addu $t1, $t1, $t2
	blt $t1, $t3, yellow
pause:
	li $t1, 0	#reset pixel counter

	li $a0, 500	#
	li $v0, 32	# Pause for 100 milisec
	syscall		#
	
	beq $t0, $t7, quit
	lw $t4, redline($t1) 
red:
	sw $t4, addres($t1)
	addu $t1, $t1, $t2
	blt $t1, $t3, red
	
	addi $t0, $t0, 1
	j pause
quit:
	Terminate
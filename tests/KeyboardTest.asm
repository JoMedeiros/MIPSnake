	.data
screen:		0x10010000
#keyboard:	0xFFFF0004
# colors
red:	0x00ff0000
bg:	0x00005500
	.text
	.globl main

main:
	lw $t0, bg
	li $s1, 0
	li $t1, 0
	li $t2, 0x800

#input:
#	lw $s1, keyboard
#	bne $s1, $s0 input
# trecho retirado do código:
# https://github.com/AndrewHamm/MIPS-Pong/blob/master/pong.asm
SelectMode:
	lw $s1, 0xFFFF0004		# check to see which key has been pressed
	beq $s1, 0x00000031, loop # 1 pressed
	#beq $s1, 0x00000032, SetTwoPlayerMode # 2 pressed
		
	li $a0, 250	#
	li $v0, 32	# pause for 250 milisec
	syscall		#
	
	j SelectMode    # Jump back to the top of the wait loop

loop:	
	sw $t0, screen($t1)
	addi $t1, $t1, 4
	
	#beq $s1, $s0, paint
	blt $t1, $t2, loop
	j terminate
	
paint:
	lw, $t0, red
	j loop
terminate:

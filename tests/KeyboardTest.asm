	.data
screen:		0x10010000
# colors
red:	0x00010000
green:	0x00000100
blue:	0x00000001
	.text
	.globl main

main:
	li $t0, 0	# Cor que vai ser pintada na tela
	li $s1, 0
	li $t1, 0
	li $t2, 0x800
	li $t3, 0x800
	li $t4, 0x1000
	lw $t5, red	# O somador da cor
	lw $t6, green
	lw $t7, blue

# trecho retirado do código:
# https://github.com/AndrewHamm/MIPS-Pong/blob/master/pong.asm
SelectMode:
	lw $s1, 0xFFFF0004		# Verifica qual tecla foi pressionada
					# OBS: esse valor fica no registrador até outra tecla ser pressionada
	beq $s1, 0x00000077, loopUp 	# w está pressionado
	beq $s1, 0x00000073, loopDown	# s está pressionado
	beq $s1, 0x00000061, loopLeft	# a está pressionado
	beq $s1, 0x00000064, loopRight	# d está pressionado
	beq $s1, 0x00000071, quit	# q está pressionado
		
	li $a0, 250	#
	li $v0, 32	# pause for 250 milisec
	syscall		#
	
	j SelectMode    # Jump back to the top of the wait loop

loopUp:	
	sw $t0, screen($t1)
	addi $t1, $t1, 4
	
	blt $t1, $t2, loopUp
	add $t0, $t0, $t5
	
	li $t1, 0
	li $s1, 0
	j SelectMode

loopDown:	
	sw $t0, screen($t3)
	addi $t3, $t3, 4
	
	blt $t3, $t4, loopDown
	add $t0, $t0, $t6
	
	li $t3, 0x800
	li $s1, 0
	j SelectMode

loopLeft:	
	sw $t0, screen($t3)
	addi $t3, $t3, 4
	
	blt $t3, $t4, loopLeft
	add $t0, $t0, $t5
	
	li $t3, 0x800
	li $s1, 0
	j SelectMode

loopRight:	
	sw $t0, screen($t3)
	addi $t3, $t3, 4
	
	blt $t3, $t4, loopRight
	add $t0, $t0, $t7
	
	li $t3, 0x800
	li $s1, 0
	j SelectMode

quit:

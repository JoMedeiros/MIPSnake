	.data
queueStart:	.word	0x10011000
queueEnd:	.word	0x10012000
screen:		.word 	0x10010000
green:		.word	0x0000FF00

	.text
	.globl main
	
main:

	lw $t0, green
	sw $t0, 0x10010084
	sw $t0, 0x10010088

	lw $s0, queueStart
	lw $s1, queueEnd
	li $s2, 0x10011000	# Início lógico da fila
	li $s3, 0x10011004	# Fim lógico da fila
	li $s4, 3		# x_pos
	li $s5, 1		# y_pos
	li $t1, 0x10010084
	sw $t1, ($s2)	# Armazena a posição da tail na tela
	
	li $t1, 0x10010088
	sw $t1, ($s3)
	
drawHead:
	# Computing adress of (x, y)
	sll $t1, $s5, 5
	add $t1, $t1, $s4
	sll $t1, $t1, 2
	li $t2, 0x10010000	# Primeiro endereço da tela
	add $t1, $t1, $t2
	sw $t0, ($t1)
	bne $s3, $s1, drawHead_if
	add $s3, $s0, $zero	# <- else reset
	j drawHead_fi
drawHead_if:	
	addi $s3, $s3, 4	# Aritmética de ponteiro
drawHead_fi:
	sw $t1, ($s3)		# Armazena o novo endereço da cabeça na fila
	
eraseTail:
	lw $t1, ($s2)		# Derrefenciando $s2 (eq en C à *pointer)
	sw $zero, ($t1)		# Apaga o inicio da fila
	
	bne $s2, $s1, eraseTail_if
	add $s2, $s0, $zero	# <- else reset
	j wait
eraseTail_if:
	addi $s2, $s2, 4	# Aritmética de ponteiro
			
wait:
	li $a0, 500		#
	li $v0, 32		# pause for 500 milisec
	syscall			#
	
	lw $s1, 0xFFFF0004		# Verifica qual tecla foi pressionada
					# OBS: esse valor fica no registrador até outra tecla ser pressionada
	beq $s1, 0x00000077, moveUp 	# w está pressionado
	beq $s1, 0x00000073, moveDown	# s está pressionado
	beq $s1, 0x00000061, moveLeft	# a está pressionado
	beq $s1, 0x00000064, moveRight	# d está pressionado
	beq $s1, 0x00000071, quit	# q está pressionado
	j moveRight
moveUp:
	subi, $s5, $s5, 1
	j drawHead
moveDown:
	addi, $s5, $s5, 1
	j drawHead
moveLeft:
	subi, $s4, $s4, 1
	j drawHead
moveRight:
	addi, $s4, $s4, 1
	j drawHead

quit:
	li $v0, 10
	syscall

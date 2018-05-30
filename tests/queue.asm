	.data
# Total de 1024 pixels
tela:		0x10010000
inicio_fila:	0x10011000 # Primeiro endereço fora da tela
final_fila:	0x10012000 # Final físico da fila

# OBS1: os registradores $ti são usados como variáveis temporárias

# colors
green:		0x0000ff00
	.text

main:
	lw $s0, inicio_fila 	# Ponteiro para o início físico da fila (NÃO PODE SER ALTERADO)
	li $s1, 0		# Índice do início lógico da fila
	lw $s2, final_fila	# Ponteiro para o final físico da fila (NÃO PODE SER ALTERADO)
	li $s3, 0		# Índice do final lógico da fila (inicia fila vazia)
	
	lw $s4, green
	lw $t2, tela
	
	addi $s3, $s3, 0x10	# Inicia a fila com 4 espaços (0x4 * 0x4 = 0x10)
	addi $t2, $t2, 0x110	# Local onde a snake vai ser desenhada
	
# Preenchendo a fila
	add $t0, $s0, $s1	# $t0 <- Inicio da fila
	add $t1, $s0, $s3	# $t1 <- Final da fila
initSnake:
	sw $t2, ($t0)
	#addi $t2, $t2, 0x80	# com 0x80 desenha a snake na vertical
	addi $t2, $t2, 0x04	# com 0x04 desenha a snake na horizontal
	addi $t0, $t0, 0x04	
	blt $t0, $t1, initSnake	
	
# Desenhar a Snake
	add $t0, $s0, $s1 # endereço de Início lógico + físico da fila
	add $t1, $s0, $s3 # endereço de Início físico + final lógico da fila
drawSnake:
	lw $t2, ($t0) # pega o valor apontado por $t0
	sw $s4, ($t2)
	addi $t0, $t0, 0x04
	
	li $a0, 750	#
	li $v0, 32	# pause for 750 milisec
	syscall		#

	blt $t0, $t1, drawSnake


	addi $t5, $t5, 0	# gambiarra
gameLoop:
# Mover a snake para direita:

	add $t0, $s0, $s1 # endereço de Início lógico + físico da fila
	add $t1, $s0, $s3 # endereço de Início físico + final lógico da fila
	
	addi $t5, $t5, 4	#Incrementando o valor do inicio
	
	lw $t2, ($t0) 	# pega o valor apontado por $t0
	sw $zero, ($t2)	# Apaga a cauda
	
	add $t2, $t2, $s3 	# pega o valor apontado por $t0
	sw $s4, ($t2)		# Desenha cabeça
	
	addi $s3, $s3, 4 	#Incrementando o valor do final
	
	li $a0, 750	#
	li $v0, 32	# pause for 750 milisec
	syscall		#

	j gameLoop
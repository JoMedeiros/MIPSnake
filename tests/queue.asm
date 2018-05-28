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
	
	addi $s3, $s3, 0x10	# Inicia a fila com 4 espaços (0x4 * 0x4 = 0x10)
	lw $s4, green
	lw $t2, tela
	addi $t2, $t2, 0x110
	
# Preenchendo a fila
	add $t0, $s0, $s1	# $t0 <- Inicio da fila
	add $t1, $s0, $s3	# $t1 <- Final da fila
initSnake:
	sw $t2, ($t0)
	addi $t2, $t2, 0x80	# com 0x80 desenha a snake na vertical
	# addi $t2, $t2, 0x04	# com 0x04 desenha a snake na vertical
	addi $t0, $t0, 0x04	
	blt $t0, $t1, initSnake	
	
# Desenhar a Snake
	add $t0, $s0, $s1 # enderesso de Inicio da fila
	add $t1, $s0, $s3 # enderesso de Inicio da fila
drawSnake:
	lw $t2, ($t0) # pega o valor apontado por $t0
	sw $s4, ($t2)
	addi $t0, $t0, 0x04
	blt $t0, $t1, drawSnake
	
	
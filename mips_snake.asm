#########################################
# 	Configurações do display	#
#---------------------------------------#
#	Unit Width in pixels: 8
#	Unit Height in Pixels: 8
#	Display Width in Pixels: 256
#	Display Height in Piexels: 256
# Total de unidades: (256/8) * (256/8)
	.data
# colors
red:	0xFFFF0000
bg:	0x00005500
screen:	0x10010000	# Primeiro endereço da tela
msg1:	.asciiz 	"\nvalor aleatório gerado: "
	.text
main:
# Gerar número aleatório ---------------------------------
	#Imprimir msg1
	li $v0, 4
	la $a0, msg1
	syscall
	
	li $a1, 1023	#Aqui $a1 configura o valor máximo que é a quantidade de unidades no display (0 até 1023).
    	li $v0, 42  #generates the random number.
    	syscall
    	#add $a0, $a0, 100  #Here you add the lowest bound
    	li $v0, 1   #1 print integer
    	syscall
#---------------------------------------------------------    	
# Pintar pixel
	move $t0, $a0
	sll $t0, $t0, 2
	lw $t1, red
	sw $t1, screen($t0)

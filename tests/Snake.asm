	.data

msg1:	.asciiz "valor aleatório gerado: "
msg2:	.asciiz "Saindo "
msg3:	.asciiz "O resultado é: "
what0:  .word 	0x00FFFF00, 0x00FFFF00, 0x00FFFF00, 0x00FFFF00

	.text
	.globl main
	
main:
	#Imprimir msg1
	li $v0, 4
	la $a0, msg1
	syscall
	
	# Gerar número aleatório
	li $v0, 41
	syscall
	#add $a0, $a0, 980412499
	li $v0, 1
	syscall
	
	li $t0, 0x10000100	# O Endereço do primeiro pixel
	li $a2, 0x00654EA3	# Carrega a cor roxa no registrador $a2
	li $s0, 0
	li $t6, 2000
	li $t1, 0
    	li $t2, 4
    	li $t3, 320
DrawPixel:
	blt $s0, $t6, exit # while the head isnt in the first limit (100) draws a pixel in (s0,s1)

	addi $s0, $s0, 1         #adds 1 to the X of the head
	li $t3, 0x10000100       #t3 = first Pixel of the screen

	addi   $t0, $t0, 4        #y = y * 512
	#addu  $t0, $t0, $s0      # (xy) t0 = x + y
	#sll   $t0, $t0, 2        # (xy) t0 = xy * 4
	#addu  $t0, $t3, $t0      # adds xy to the first pixel ( t3 )
	sw    $a2, ($t0)         # coloca a cor roxa ($a2) em $t0

	j DrawPixel
	
exit:
	#Imprimir msg1
	li $v0, 4
	la $a0, msg2
	syscall
	
    #### saindo ######
    li $v0, 10
    syscall
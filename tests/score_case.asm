	.macro print
	    	li $v0, 1   # print integer
    		syscall
	.end_macro
	
	
	.data
score: 654
	.text

	lw $s0, score
	li $s1, 10
	li $s2, 100
	# Unidade
	div $s0, $s1 	# div score 10
	mfhi $a0	# print (score mod 10)
	print
	#Dezena:
	mflo $t0 	# score/10
	div $t0, $s1	# div (score/10) 10
	mfhi $a0	# print ((score/10) mod 10)
	print
	#Centena:
	div $a0, $s0, $s2 # print (score / 100)
	print
	
quit:
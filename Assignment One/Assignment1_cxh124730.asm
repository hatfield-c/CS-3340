# A program that receives two integers from
# the user, and stores them in two memory
# locations. The program then adds the two
# numbers together, and displays their sum
# as an output in the console.

.text main:
	#output: Prints str_welcomeMsg
	la $a0, str_welcomeMsg
	li $v0, 4
	syscall

	#input: Get integer from user and stores it in $t1
	li $v0 5
	syscall
	sw $v0, A
	
	#output: Prints str_enterInt2
	la $a0, str_enterInt2
	li $v0, 4
	syscall
	
	#input: Get integer from user and stores it in $t2
	li $v0 5
	syscall
	sw $v0, B
	
	#method: Loads A & B into $1 & $t2
	lw $t1, A
	lw $t2, B
	
	#method: Adds $t1 and $t2, then stores it's value in S
	add $t0, $t1, $t2
	sw $t0, S
	
	#output: Prints the sum of A & B from S.
	la $a0, str_theSum
	li $v0, 4
	syscall
	
	lw $a0, S
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall

	#method: exits the program
	li $v0 10,
	syscall
		
.data
	str_welcomeMsg: 	.asciiz 	"Welcome! This program will calculate two integer values you enter.\nPlease enter integer one: "
	str_enterInt2: 		.asciiz 	"Pleanse enter integer two: "
	str_theSum: 		.asciiz 	"\nThe sum of A and B (A + B) is: "
	newLine:		.asciiz 	"\n"
	A:			.word		0
	B:			.word		0
	S:			.word		0
# A program that receives two integers from
# the user, and stores them in two memory
# locations. The program then adds the two
# numbers together, and displays their sum
# as an output in the console.

.text main:
	#method: Prints the welcome message onto the screen
	la $a0, str_welcomeMsg
	li $v0, 4
	syscall

	#method: Get first integer
	li $v0 5
	syscall
	move $t1, $v0
	
	#method: prints integer two message
	la $a0, str_enterInt2
	li $v0, 4
	syscall
	
	#method: Get second integer
	li $v0 5
	syscall
	move $t2, $v0
	
	#method: Add first and second integer
	add $t0, $t1, $t2
	
	#todo: Output final answer

	li $v0 10,
	syscall
		
.data
	str_welcomeMsg: .asciiz "Welcome! This program will calculate two integer values you enter.\nPlease enter integer one: "
	str_enterInt2: .asciiz "Pleanse enter integer two: "
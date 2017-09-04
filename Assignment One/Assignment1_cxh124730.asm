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

	#todo: Capture user input for two ints
	li $t1, 3
	li $t2, 5
	
	add $t0, $t1, $t2
	
	#todo: Output final answer

	li $v0 10,
	syscall
		
.data
	str_welcomeMsg: .asciiz "Welcome! This program will calculate two integer values you enter.\nPlease enter integer one: "
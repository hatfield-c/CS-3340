# A program that receives two integers from
# the user, and stores them in two memory
# locations. The program then adds the two
# numbers together, and displays their sum
# as an output in the console.

main:
	#todo: Output initial message to screen

	#todo: Capture user input for two ints
	li $t1, 3
	li $t2, 5
	
	add $t0, $t1, $t2
	
	#todo: Output final answer
# A program that gets an integer input
# from the user, and creates a word
# array with the size of the input
# and filled with index of each item.
# The array is then summed, and the o
# utput displayed.

.data
	
	str_wlcm:		.asciiz 	"Welcome! This program will get an integer from you, and output the summation of all integers between it and 0.\nPlease enter an integer: "
	str_sum_msg:		.asciiz		"The sum of 0 to N is "
	str_newline:		.asciiz		"\n"
	N:			.word		0
	int_NT:			.word		0
	int_sum:		.word		0
	int_arr:		.word		0:50

.text main:

	# output: Prints str_wlcm
	li $v0, 4
	la $a0, str_wlcm
	syscall

	# input: Gets integer from user and places it in N
	li $v0, 5
	syscall
	sw $v0, N
	
	# method: If 0, jump to the end
	lw $t0, N
	beq $t0, $zero, exit
	
	# calculate: Gets the total offset used in the array
	lw $t0, N
	addi $t0, $t0, 1
	sw $t0, int_NT
	
	# loop: loops through array to initialize each element to its index
	# $t0 is the number to store in the array, and the current iteration
	# $t1 is the max iterations
	# $s0 is the address of the array
	add $t0, $zero, $zero
	lw $t1, int_NT
	la $s0, int_arr
	
begin_initialize:
	beq $t0, $t1, end_initialize
	sw $t0, ($s0)
	addi $s0, $s0, 4
	addi $t0, $t0, 1
	j begin_initialize
end_initialize:

	# loop: loops through the array, adding every element together
	# $t0 is the number where the sum is stored
	# $t1 is the current iteration
	# $t2 is the max iterations
	# $t3 is the current number to add to the sum
	# $s0 is the address of the array
	add $t0, $zero, $zero
	add $t1, $zero, $zero
	add $t3, $zero, $zero
	lw $t2, int_NT
	la $s0, int_arr
	
begin_add:
	beq $t1, $t2, end_add
	lw $t3, ($s0)
	add $t0, $t0, $t3
	addi $s0, $s0, 4
	addi $t1, $t1, 1
	j begin_add
end_add:

	# output: output the end message and the total sum to the screen
	la $a0, str_sum_msg
	li $v0, 4
	syscall
	
	add $a0, $zero, $t0
	li $v0, 1
	syscall
	
exit:
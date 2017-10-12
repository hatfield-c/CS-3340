# A program that gets a zip code input
# from the user, stores it in memory,
# and sums up its digits via two different
# functions.

.data
	
	str_wlcm:		.asciiz 	"Welcome! This program will get a zip code from you, and output the sum of its digits.\nPlease enter a five digit zip code (or 0 to exit): "
	str_nr_msg:		.asciiz		"\nSum of digits (non-recursive): "
	str_r_msg:		.asciiz		"\nSum of digits (recursive)    : "
	str_newLine:		.asciiz		"\n"
	zip:			.word		1

.text main:

	jal clear_screen
	jal print_wlcm
	
	#input: Get the zip code and store it in zip
	la $a0, zip
	li $a1, 6
	li $v0, 8
	syscall
	
	#method: check if the zip is zero
	la $a0, zip
	jal funct_check_zip
	move $t0, $v0
	beq $t0, $zero, exit
	
	#method: sum up digits (nonrecursive)
	la $a0, zip
	jal funct_sum
	
	#output: output the nonrecursive sum
	move $t0, $v0
	
	la $a0, str_nr_msg # print the nonrecursive message
	li $v0, 4
	syscall
	
	move $a0, $t0 # print the sum
	li $v0, 1
	syscall
	
	#method: sum up digits (recursive)
	la $a0, zip
	li $a1, 0
	li $a2, 5
	jal funct_sum_R
	
	#output: output the recursive sum
	move $t0, $v0
	
	la $a0, str_r_msg # print the recursive message
	li $v0, 4
	syscall
	
	move $a0, $t0 #print the sum
	li $v0, 1
	syscall

	j exit
	
funct_check_zip:
	#init
	#  $t0 - current bit string
	#  $t1 - sentinel
	#  $t2 - max loop
	#  $t3 - buffer to store value of current digit
	#  $t4 - flag variable - greater than 0 if non-zero or non newline character detected
	#  $t5 - hex value of newline character
	li $t0, 0
	li $t1, 0
	li $t2, 4
	li $t3, 0
	li $t4, 0
	li $t5, 0xa
	
	#method: load the first bit string
	lw $t0, 0($a0)
	
	#loop: check each digit in the bit string to see if it is non-zero.
	check_loop_begin:
	beq $t1, $t2, check_loop_end
		andi $t3, $t0, 0xf
		slt $t4, $zero, $t3
		srl $t0, $t0, 8
		addi $t1, $t1, 1
		
		beq $t4, $zero, check_loop_begin
		bne $t3, $t5, check_complete
		li $t4, 0
	check_loop_end:
	
	#method: check the second bit string to see if it's sole character is non-zero
	lw $t0, 4($a0)
	andi $t3, $t0, 0xf
	slt $t4, $zero, $t3
	beq $t4, $zero, check_complete
	bne $t3, $t5, check_complete
	li $t4, 0
	
	#return: if all values in string are zero or newline, then return 0. Otherwise, return a value greter than 0.
	check_complete:
	move $v0, $t4
	
	jr $ra
	
funct_sum:
	#method: stores the necessary registers to the stack
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	#loop: add up the values of the digits
	#  $t0 - address of bit string
	#  $t1 - sentinel
	#  $t2 - the end flag
	#  $s0 - the current sum of the digits
	#  $s1 - bit string containing digits in ascii
	#  $s2 - buffer for digits to add
	move $t0, $a0
	li $t1, 0
	li $t2, 4
	li $s0, 0
	lw $s1, 0($t0)
	li $s2, 0
	
	#method: sum up the first four digits
	sum_loop_begin:
	beq $t1, $t2, sum_loop_end
		andi $s2, $s1, 0xf # gets the very last digit of the ascii string representing the zip code
		add $s0, $s0, $s2 # adds the last digit to the sum
		addi $t1, $t1, 1 # add 1 to the sentinel
		srl $s1, $s1, 8 # pop the last digit off the ascii string
		j sum_loop_begin
	sum_loop_end:
	
	#method: add the last digit to the sum
	lw $s2, 4($t0)
	andi $s2, 0xf
	add $s0, $s0, $s2
	
	#method: place the result in the return register $v0
	move $v0, $s0
	
	#method: resets stack and returns
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
funct_sum_R:
	#method: stores the necessary registers to the stack
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	
	#  $t0 - current address
	#  $t1 - current digit position out of n digits
	#  $t2 - number of digits to add
	#  $t3 - current bit string
	#  $t4 - buffer for bit strings
	#  $s0 - current digit
	
	#init: move info from $a registers to $t registers
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	#init: check if this is the first iteration, and initialize values if it is.
	bne $t1, 0, init_bitStr
		lw $t3, 0($t0)
		li $s0, 0
	init_bitStr:
	
	#method: if we have run out of digits at this address, update to the next address
	bne $t1, 4, address_offset
		add $t0, $t0, 4
		lw $t3, 0($t0)
	address_offset:
	
	#method: get the current digit in this position, 
	#        update the bit string, and update the digit position to the next one
	andi $s0, $t3, 0xf
	srl $t3, $t3, 8
	addi $t1, $t1, 1
	
	#method: check if this is the last digit. If so,
	#        end the function. If not, continue the
	#        recursive iteration
	beq $t1, $t2, sum_complete
		move $a0, $t0
		move $a1, $t1
		move $a2, $t2
		jal funct_sum_R
		add $s0, $v0, $s0 # add the return value of the next iteration to this one
	sum_complete:
	
	#method: set this current value to this iterations return value
	move $v0, $s0
	
	#method: resets stack and returns
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
	
print_wlcm:
	#method: prints the welcome message
	la $a0, str_wlcm
	li $v0, 4
	syscall
	jr $ra
	
print_newLine:
	#method: prints a newline into the console
	la $a0, str_newLine
	li $v0, 4
	syscall
	jr $ra
	
clear_screen:
	#method: clears the screen by printing several new lines into the console
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	jal print_newLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
exit:

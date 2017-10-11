# A program that gets a zip code input
# from the user, stores it in memory,
# and sums up its digits via two different
# functions.

.data
	
	str_wlcm:		.asciiz 	"Welcome! This program will get a zip code from you, and output the sum of its digits.\nPlease enter a zip code (or 0 to exit): "
	str_nr_msg:		.asciiz		"Sum of digits (non-recursive: "
	str_r_msg:		.asciiz		"Sum of digits (recursive)   : "
	str_newLine:		.asciiz		"\n"
	zip:			.word		0
	#buffer:			.space		8

.text main:

	jal clear_screen
	jal print_wlcm
	
	#input: Get the zip code and store it in zip
	la $a0, zip
	li $a1, 6
	li $v0, 8
	syscall
	
	#method: sum up digits (nonrecursive)
	la $a0, zip
	jal funct_sum
	
	#method: sum up digits (recursive)
	#la $a0, zip
	#jal funct_sum_R
	
	#la $a0, zip
	#li $v0, 4
	#syscall
	
	j exit
	
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
	
	# Sum up the first four digits
	sum_loop_begin:
	beq $t1, $t2, sum_loop_end
		andi $s2, $s1, 0xf # gets the very last digit of the ascii string representing the zip code
		add $s0, $s0, $s2 # adds the last digit to the sum
		addi $t1, $t1, 1 # add 1 to the sentinel
		srl $s1, $s1, 8 # pop the last digit off the ascii string
		j sum_loop_begin
	sum_loop_end:
	
	# Add the last digit to the sum
	lw $s2, 4($t0)
	andi $s2, 0xf
	add $s0, $s0, $s2
	
	#method: print the value of the temp register
	jal print_newLine
	move $a0, $s0
	li $v0, 1
	syscall
	
	#method: resets stack and returns
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
funct_sum_R:
	#method: stores the necessary registers to the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#  $t0 - current address
	#  $t1 - current digit
	#  $t2 - number of digits to add
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	add $t0, $t0, 
	
	#method: print the value of the temp register
	jal print_newLine
	move $a0, $t0
	li $v0, 4
	syscall
	
	#method: resets stack and returns
	lw $ra, 0($sp)
	addi $sp, $sp, 16
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

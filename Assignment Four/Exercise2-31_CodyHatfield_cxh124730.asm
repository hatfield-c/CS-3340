# A program that implements the fibonacci
# C code from exercise 2.31

.data
	
	str_wlcm:		.asciiz 	"Welcome! This program will output the sum of a fibonacci sequence.\nPlease enter an integer: "
	str_sum:		.asciiz		"\nThe fibonacci sum for this number is: "
	str_newLine:		.asciiz		"\n"

.text main:

	#init: initialization messages
	jal clear_screen
	jal print_wlcm
	
	#input: get fibonacci digit from user
	li $v0, 5
	syscall
	move $a0, $v0
	
	#method: calculate fibonacci sequence up to nth number
	jal fib
	move $t0, $v0

	#output: output the sum message and the fibonacci sequence to the console
	la $a0, str_sum
	addi $v0, $zero, 4
	syscall
	
	move $a0, $t0
	addi $v0, $zero, 1
	syscall

	j exit
	
fib:
	#init: save used registers to the stack
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	#init: move the argument value into saved register
	move $s0, $a0
	
	#method: check if the value passed in is zero
	bne $s0, $zero, one_check
		add $v0, $s0, $zero
		j end_fib
	#method: check if the value passed in is one
	one_check:
	addi $t1, $zero, 1
	bne $s0, $t1, recurse
		add $v0, $s0, $zero
		j end_fib
	#method: If the value is neither zero nor one, then calculate to the two previous terms
	recurse:
	#method: calculate the first previous term
	addi $a0, $s0, -1
	jal fib
	add $s1, $v0, $zero
	
	#method: calculate the second previous term
	addi $a0, $s0, -2
	jal fib
	add $s2, $v0, $zero
	
	#method: add the two previous terms together
	add $v0, $s1, $s2
	
	end_fib:
	
	#init: restore the used registers to the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
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

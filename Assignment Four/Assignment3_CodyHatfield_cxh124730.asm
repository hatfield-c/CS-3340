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
	buffer:			.space		8		

.text main:

	jal clear_screen
	jal print_wlcm
	
	#input: Get the zip code and store it in zip
	li $v0, 5
	syscall
	sw $v0, zip
	
	#method: sum up digits (nonrecursive)
	lw $a0, zip
	jal funct_sum
	
	#method: sum up digits (recursive)
	lw $a0, zip
	jal funct_sum_R
	
	j exit
	
funct_sum:
	#method: load argument into temp register
	move $t0, $a0
	#andi $t1, $t0, 0xf
	#li $t3, 0x0000000f
	
	#method: print the value of the temp register
	move $a0, $t0
	li $v0, 1
	syscall
	
	jr $ra
	
funct_sum_R:
	#method: stores the necessary registers to the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#method: load argument into temp register
	move $t0, $a0
	#andi $t1, $t0, 0xf
	
	#method: print the value of the temp register
	jal print_newLine
	move $a0, $t0
	li $v0, 1
	syscall
	
	#method: resets stack and returns
	lw $ra, 0($sp)
	addi $sp, $sp, 4
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

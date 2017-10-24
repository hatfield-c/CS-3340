# A program that gets a zip code input
# from the user, stores it in memory,
# and sums up its digits via two different
# functions.

.data
	
	str_hello:		.asciiz 	"Hello world!"
	str_newLine:		.asciiz		"\n"

.text main:

	la $a0, str_hello
	li $v0, 4
	syscall
	
	li $v0, 10
	syscall
	
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
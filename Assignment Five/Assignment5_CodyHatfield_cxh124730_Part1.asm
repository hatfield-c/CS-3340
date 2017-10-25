# A program that gets a zip code input
# from the user, stores it in memory,
# and sums up its digits via two different
# functions.

.data
	
	str_mainMenu:		.asciiz 	"---------- Main Menu ----------\nWelcome to the Hati YenUSD conversion calculator! Please choose one of the following options:\n"
	str_mainMenuOptions:	.asciiz		"1. Set Conversion Rate\n2. Convert USD to Yen\n3. Convert Yen to USD\n4. Exit Application\n"
	str_newLine:		.asciiz		"\n"

.text main:

	#method: Clear the command line screen
	jal clearScreen

	#method: Display the main menu and get the menu option from the user
	jal getMainMenu
	move $t0, $v0
	
	terminate_application:
	
	li $v0, 10
	syscall
	
getMainMenu:
	
	#output: Print the main menu title
	la $a0, str_mainMenu
	li $v0, 4
	syscall
	
	#output: Print the main menu options
	la $a0, str_mainMenuOptions
	li $v0, 4
	syscall
	
	#input: Get the selection from the user
	li $v0, 5
	syscall
	
	jr $ra
	
printNewLine:
	#method: prints a newline into the console
	la $a0, str_newLine
	li $v0, 4
	syscall
	jr $ra
	
clearScreen:
	#method: clears the screen by printing several new lines into the console
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	jal printNewLine
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

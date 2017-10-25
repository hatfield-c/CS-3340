# A program that gets a zip code input
# from the user, stores it in memory,
# and sums up its digits via two different
# functions.

.data
	
	str_mainMenu:		.asciiz 	"---------- Main Menu ----------\nWelcome to the Hati YenUSD conversion calculator! Please choose one of the following options:\n"
	str_mainMenuOptions:	.asciiz		"1. Set Conversion Rate\n2. Convert USD to Yen\n3. Convert Yen to USD\n4. Exit Application\n"
	str_newLine:		.asciiz		"\n"

.text 
main:

	#method: Clear the command line screen
	jal clearScreen

	#method: Display the main menu and get the menu option from the user
	jal getMainMenu
	move $t0, $v0
	
	#conditional: Branch to correct functionality based on input. If input invalid, restart application.
	beq $t0, 1, O1
	beq $t0, 2, O2
	beq $t0, 3, O3
	beq $t0, 4, terminate_application
	j main
	
	#Option 1: Set conversion rate
	O1:
		jal setRate
		j end_switch
	#Option 2: Convert Yen to USD
	O2:
		jal yenToUsd
		j end_switch
	#Option 1: Convert USD to Yen
	O3:
		jal usdToYen
		j end_switch
	
	end_switch:
	#method: Restart application
	j main
	
	#method: End the application
	terminate_application:
	
	li $v0, 10
	syscall
	
setRate:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
yenToUsd:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
usdToYen:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

#subroutine: Displays the main menu, and returns the user input selected from the main menu
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

#subroutine: Prints a newline character
printNewLine:
	#method: prints a newline into the console
	la $a0, str_newLine
	li $v0, 4
	syscall
	jr $ra

#subroutine: Clears the command line screen	
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

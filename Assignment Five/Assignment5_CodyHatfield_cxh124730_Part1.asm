# A program that gets a zip code input
# from the user, stores it in memory,
# and sums up its digits via two different
# functions.

.data
	
	str_mainMenu:		.asciiz 	"\n\n---------- Main Menu ----------\nWelcome to the Hati YenUSD conversion calculator! Please choose one of the following options:\n"
	str_mainMenuOptions:	.asciiz		"1. Set Conversion Rate\n2. Convert USD to Yen\n3. Convert Yen to USD\n4. Exit Application\n"
	str_conversionRate:	.asciiz		"Please enter the desired conversion rate: "
	str_UsdAmount:		.asciiz		"Please enter the amount of USD to convert to Yen: "
	str_UsdToYenConverted:	.asciiz		"The value in Yen of the entered USD amount is: "
	str_newLine:		.asciiz		"\n"
	int_conversionRate:	.word		115

.text 
main:
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
	#Option 2: Convert USD to Yen
	O2:
		jal usdToYen
		j end_switch
	#Option 3: Convert Yen to USD
	O3:
		jal yenToUsd
		j end_switch
	
	end_switch:
	#method: Restart application
	j main
	
	#method: End the application
	terminate_application:
	
	li $v0, 10
	syscall
	
#Subroutine: Get the new conversion rate from the user, and store it in int_conversionRate
setRate:
	#method: Store the return address in the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#method: Clear the command line screen
	jal clearScreen

	#output: Output the conversion rate message.
	la $a0, str_conversionRate
	li $v0, 4
	syscall
	
	#input: Get the conversion rate from the user
	li $v0, 5
	syscall
	
	#method: Store the conversion rate in memory
	sw $v0, int_conversionRate
	
	#method: Load the return address from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
usdToYen:
	#method: Store the return address in the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#output: Print the USD to Yen prompt
	la $a0, str_UsdAmount
	li $v0, 4
	syscall
	
	#input: Get the USD amount from the user
	li $v0, 5
	syscall
	move $t1, $v0
	
	#method: Convert the USD amount to Yen
	lw $t2, int_conversionRate
	mulo $t0, $t1, $t2
	
	#output: Print the converted amount message
	la $a0, str_UsdToYenConverted
	li $v0, 4
	syscall

	#output: Print the converted amount
	move $a0, $t0
	li $v0, 1
	syscall
	
	#method: Load the return address from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4

	jr $ra
	
yenToUsd:
	#method: Store the return address in the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#method: Load the return address from the stack
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

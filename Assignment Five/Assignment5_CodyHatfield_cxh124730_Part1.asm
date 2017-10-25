# A program that converts between
# Yen & USD

.data
	
	str_mainMenu:		.asciiz 	"\n\n---------- Main Menu ----------\nWelcome to the Hati YenUSD conversion calculator! Please choose one of the following options:\n"
	str_mainMenuOptions:	.asciiz		"1. Set Conversion Rate\n2. Convert USD to Yen\n3. Convert Yen to USD\n4. Exit Application\n"
	str_conversionRate:	.asciiz		"Please enter the desired conversion rate: "
	str_UsdAmount:		.asciiz		"Please enter the amount of USD to convert to Yen: "
	str_UsdToYenConverted:	.asciiz		"The value in Yen of the entered USD amount is: "
	str_YenAmount:		.asciiz		"Please enter the amount of Yen to convert to USD: "
	str_YenToUsdConverted:	.asciiz		"The value in USD of the entered Yen amount is: "
	str_YenChange:		.asciiz		"\nWith Yen change leftover of: "
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
	
	#method: Get the converted USD amount in Yen
	move $a0, $v0
	jal calculateUsdToYen
	move $t0, $v0
	
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
	
	#output: Print the Yen to USD prompt
	la $a0, str_YenAmount
	li $v0, 4
	syscall
	
	#input: Get the Yen amount from the user
	li $v0, 5
	syscall
	
	#method: Calculate the value in Yen of the USD amount
	move $a0, $v0
	jal calculateYenToUsd
	move $t0, $v0
	move $t1, $v1
	
	#output: Print the converted amount message
	la $a0, str_YenToUsdConverted
	li $v0, 4
	syscall
	
	#output: Print the converted amount
	move $a0, $t0
	li $v0, 1
	syscall
	
	#output: Print the change message
	la $a0, str_YenChange
	li $v0, 4
	syscall
	
	#output: Print the change
	move $a0, $t1
	li $v0, 1
	syscall
	
	#method: Load the return address from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

#subroutine: Calculate the value in USD for a Yen amount in $a0, return in $v0
calculateYenToUsd:
	#method: Store the return address in the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# $s0 : The amount in Yen
	# $s1 : The current conversion multiplier
	# $s2 : The change in Yen left over
	# $t0 : The current Yen in whole USD
	move $s0, $a0
	li $s1, 1
	li $s2, 0
	
	begin_conversion:
		#method: Get the current Yen in whole USD for this iteration
		lw $t0, int_conversionRate
		mulo $t0, $s1, $t0
	
		#condition: If the current Yen in whole USD is greater than the amount of Yen entered, exit the loop
		bgt $t0, $s0, end_conversion
		
		#method: Add 1 to the Yen to whole USD multiplier, and iterate
		addi $s1, $s1, 1
		j begin_conversion
	
	end_conversion:
	#method: Remove one from the Yen to whole USD multiplier, and calculate the whole USD amount
	addi $s1, $s1, -1
	lw $t0, int_conversionRate
	mulo $t0, $s1, $t0
	
	#method: Calculate the change based on the whole USD amount
	sub $s2, $s0, $t0
	
	#method: Prepare return values
	move $v0, $s1
	move $v1, $s2
	
	#method: Load the return address from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

#subroutine: Calculate the value in Yen for a USD amount in $a0, return in $v0
calculateUsdToYen:
	#method: Store the return address and saved registers in the stack
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	#method: Convert the USD amount to Yen
	lw $t1, int_conversionRate
	mulo $v0, $a0, $t1
	
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

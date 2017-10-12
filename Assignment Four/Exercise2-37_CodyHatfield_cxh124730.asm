# A program that takes numbers
# encoded in ascii in memory, and
# converts them into their actual
# numbers and places them into
# a register to be used for calculations

.data
	
	str_wlcm:		.asciiz 	"Welcome! This program takes a number encoded in ascii, and converts it so it can be placed in a register. \nConverting the number: "
	str_num:		.asciiz		"\nSuccess! The number placed in the register was: "
	str_newLine:		.asciiz		" \n"
	str_numbers:		.asciiz		"-253647"

.text main:

	#init: initialization messages
	jal clear_screen
	jal print_wlcm
	
	la $a0, str_numbers
	li $v0, 4
	syscall

	#method: pass the ascii number to the converter
	la $a0, str_numbers
	jal func_asciiToNum
	move $t0, $v0
	
	#output: print final output to user
	la $a0, str_num
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall

	j exit
	
func_asciiToNum:
	#init: save used registers to the stack
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	
	#  $s0 - current bit string
	#  $s1 - current ascii character
	#  $s2 - current address
	#  $s3 - address sentinel
	#  $s4 - multiplier
	#  $s5 - final data
	#  $s6 - is negative number (1 true, 0 false)
	#  $s7 - nth digit of number (from right(0) to left(n))
	lw $s0, 0($a0)
	li $s1, 0
	move $s2, $a0
	li $s3, 0
	li $s4, 1
	li $s5, 0
	li $s6, 0
	
	#init: find the number of ascii characters in the string
	move $a0, $s2
	jal func_getNumChar 
	move $s7, $v0
	
	begin_convert:
		# if the current bit string is empty, load the next one
		bne $s3, 4, empty_check
			li $s3, 0
			addi $s2, $s2, 4
			lw $s0, 0($s2)
		empty_check:
		
		# get the current ascii digit (2 hex digits) from the current bit string
		andi $s1, $s0, 0xff
		
		# pop the last ascii digit off the current bit string
		srl $s0, $s0, 8
		
		# null char check always comes first
		move $a0, $s1
		jal func_isNullTerm
		beq $v0, 1, end_convert
		
		# negative check (remove minus sign if positive, then flag as true, only valid on first iteration)
		bne $s4, 1, negative_check
			bne $s1, 0x2d, negative_sign_check
				li $s6, 1
				addi $s3, $s3, 1
				j begin_convert
			negative_sign_check:
		negative_check:
		
		# valid number char check
		move $a0, $s1
		jal func_isValidNumber
		beq $v0, 1, valid_check
			li $s5, -1
			j end_convert
		valid_check:
		
		# update values
		move $a0, $s7
		jal func_getMultiplier
		move $s4, $v0
		
		addi $s7, $s7, -1
		addi $s3, $s3, 1
		
		# calculate decimal value
		andi $s1, $s1, 0xf
		mulo $s1, $s1, $s4
		
		# add to holder
		add $s5, $s5, $s1
		
		#loop
		j begin_convert
	end_convert:
	
	# if negative, convert to negative number
	bne $s6, 1, to_negative
		nor $s5, $s5, $zero
		addi $s5, $s5, 1
	to_negative:
	
	# store in register
	move $v0, $s5
	
	#init: restore the used registers to the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	
	jr $ra

func_getMultiplier:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#  $t0 - exponent of 10
	#  $t1 - sentinel
	#  $t2 - store the result
	move $t0, $a0
	li $t1, 1
	li $t2, 1
	
	#method: multiply by 10 until desired multiplier reached
	begin_calc_multiplier:
		beq $t1, $t0, end_calc_multiplier
		mulo $t2, $t2, 10
		addi $t1, $t1, 1
		j begin_calc_multiplier
	end_calc_multiplier:
	
	move $v0, $t2
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# checks if the ascii code (hex) put into $a0 is a valid number (e.g. between 30 and 39 in hex)
func_isValidNumber:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0
	li $t1, 1
	
	#method: check if the ascii code is less than 0x30 (0 in decimal)
	bge $t0, 0x30, low_end_pass
		li $t1, 0
		j valid_check_complete
	low_end_pass:
	
	#method: check if the ascii code is greater than 0x39 (9 in decimal)
	ble $t0, 0x39, high_end_pass
		li $t1, 0
	high_end_pass:
	
	valid_check_complete:
	move $v0, $t1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
func_isNullTerm:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	move $t0, $a0
	li $t1, 1
	
	#method: check if the ascii code is equal to the null terminator
	beq $t0, $zero, null_check_complete 
		li $t1, 0
	null_check_complete:
	
	move $v0, $t1
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra

# get the total number of characters for the string
func_getNumChar:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	#  $t0 - current bit string
	#  $t1 - current ascii character
	#  $t2 - current address
	#  $t3 - address sentinel
	#  $t4 - number of digits
	lw $t0, 0($a0)
	li $t1, 0
	move $t2, $a0
	li $t3, 0
	li $t4, 0
	
	# loops through the characters of the string and adds them to a counter
	begin_digit_count:
		bne $t3, 4, address_check
			li $t3, 0
			addi $t2, $t2, 4
			lw $t0, 0($t2)
		address_check:
		
		andi $t1, $t0, 0xff		
		beq $t1, 0x2d, pop_negative_sign

		beq $t1, $zero, end_digit_count
		addi $t4, $t4, 1
		
		pop_negative_sign:
		srl $t0, $t0, 8
		addi $t3, $t3, 1
		j begin_digit_count
	end_digit_count:
	
	move $v0, $t4
	
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

# A program that gets the
# number of pizzas Joe sold,
# and output the total
# square footage of pizza
# sold from that number.

.data
	
	str_prompt:		.asciiz 	"Hey there Joe!\nGo ahead and enter the number of 8 inch pizzas you sold today: "
	str_totArea:		.asciiz		"You sold "
	str_sqrFt:		.asciiz		" square feet of pizza. Good job!"
	str_newLine:		.asciiz		"\n"
	int_numPizzas:		.word		0
	flt_diameter:		.float		8.0
	flt_pi:			.float		3.1415926536

.text main:
	#output: Print the prompt message
	la $a0, str_prompt
	li $v0, 4
	syscall
	
	#input: Get the number of pizzas sold
	li $v0, 5
	syscall
	sw $v0, int_numPizzas
	
	#method: Load number of pizzas into floating point register
	lw $t0, int_numPizzas
	mtc1 $t0, $f0
	cvt.s.w $f0, $f0
	
	#method: Load pi into floating point register
	la $t0, flt_pi
	lwc1 $f1, 0($t0)
	
	#method: Load diameter into floating point register
	la $t0, flt_diameter
	lwc1 $f2, 0($t0)
	
	#method: Set $f3 to 2 for later division
	li $t0, 2
	mtc1 $t0, $f3
	cvt.s.w $f3, $f3
	
	#method: Get the radius by dividing the diameter in half
	div.s $f2, $f2, $f3
	
	#method: Square the radius
	mul.s $f2, $f2, $f2
	
	#method: Get area of one pizza
	mul.s $f1, $f1, $f2
	
	#method: Get area of all pizzas
	mul.s $f0, $f0, $f1
	
	#output: Print total area message
	la $a0, str_totArea
	li $v0, 4
	syscall
	
	#output: Print the area of all pizzas
	mov.s $f12, $f0
	li $v0, 2
	syscall
	
	#output: Print square foot message
	la $a0, str_sqrFt
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

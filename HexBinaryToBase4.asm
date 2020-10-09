# Description: This program takes arguments in hex, of form 0xx, and binary of form 0bxxxxxxxx and outputs the sum in base 4.
####################################################################################
# Psuedocode: 
# Define ASCII prompts as needed for user input and output
# 	-load address and ask for user input
#	-Call Hexorbinary		
# Inputcheck:
# 	-Check if user input is not null for both registers containing each argument.
#	-call endif
# Hexorbinary:
# 	Identify each number as hex or binary by looking at â€œ0xâ€� prefix for hex and â€œ0bâ€� prefix for 2SC binary.
# 	- Call ASCIItoBinary if number is in binary.
#   - Call HextoBinary if number is in hex.
# BinaryPolarity:
# Check if number is positive or negative. Call ispositive or isnegative accordingly. 
# IsNegative: will convert all 0 to 1, and 1 to 0 as needed.
#	- will call hex after converting
#	- if isNegative returns false, call isPositive.
#	- Add each bit multiplied by 2^n constant beginning from the exponent at (n-1). 
#	- Perform n-1 on exponent on the left each time program moves down 1 bit. 
# 	- Perform addition on the arithmetic performed. 
#	- call output
# isPositive:
# 	- call Hex
#	- Assign a register to hold a running sum.
#	- Add each bit multiplied by 2^n constant beginning from the exponent at (n-1). 
#	- Perform n-1 on exponent on the left each time program moves down 1 bit. 
# 	- Perform addition on the arithmetic performed. 
#	- store result
# Hex to Binary:
#	- load register with data from argument into hex
#	- create a 32 bit number
#	- allocate register
#	- convert into nibbles
# 	- allocate proper reigsters
# 	- process each nibble
#	- store into register
#	- call adder
# Adder:
#   - Add both of the values in 32 twos complement.
#   - Call base4converter
# base4converter:
#   - Iterate through the result from left to right, load two bytes at a time 
#   - convert these two bytes to decimal. Save the values in a stack.
#   - this is the value in base4, continue till the address has been completely iterated through.
#   - Output the value in base 4 by outputing the stack. 
#   - Call Output
# Output:
# Load each ascii prompt that says what is being outputted
#	-call each register in stack containing the result
# Endif:
# End if program arguments are not sufficent.
# - Called by input check 
####################################################################################
# Register Usage: (changes but should be easy to understand thru comments).
# $s0: sum
# $s1: two 32-bit two’s complement integer
# $s2: two 32-bit two’s complement integer
# $t0: holdes bytes for conversion
# $t1: holds byte for checking hex/binary
# $t2: misc, counter
# $t3: misc, used for conversions
# $t4: used for conversions and holding remainde4r
# $t5: used for holding the sum of the two 32-bit two’s complement integers
# $t6: remainder
# $t7: quotient
# t8: remainder

####################################################################################
.data
	newline:	.asciiz "\n"
	input: 		.asciiz "You entered the numbers:\n"
	output: 	.asciiz "\nThe sum in base 4 is:\n"
	negsign: 	.asciiz 	"-"
  	error: 		.asciiz "error" 
  	extendinput:    .space 32
	hexprefix: 	.asciiz "0x"
	messageSpace: 	.asciiz " "
.text
##############################################################################################################################################
main:
      li $v0, 4
      la $a0, input			#user prompt
      syscall
      
      lw $a0, ($a1)			#print user arg 1
      syscall
        
       la $a0 messageSpace
       syscall
      
       lw $a0 4($a1)		        #print user arg 2
       syscall
        
       li $v0, 4			#print newline
       la $a0 newline
       syscall
b hexorbinary1
       
          

        
         
########################################################################################################################################################       
 hexorbinary1:
     lw $s0, ($a1) 		#store first argument into $t0
      
     lw $s1, 4($a1) 		#store second argument into $t1
      
      lb $t1, 1($s0)
   
      beq $t1,0x00000078,hexloop1
      beq $t1,0x00000062,binaryloop1
########################################################################################################################################################
hexloop1:
li $t2, 0			
li $t3, 1
li $t6, 16
lb $t0, 2($s0)			# Loads SECOND byte of program argument into $t0 
sub $t0, $t0, 48		# CONVERT TO ASCII
bgt $t0, 9, hexchartodec	# branch to converter if ascii value if of a letter
b hexdig1

########################################################################################################################################################
hexchartodec:			#check the ascii value of $t0 after subtracting 48 and assign the correct decimal value.

beq $t0, 17, aConv0
beq $t0, 18, bConv0
beq $t0, 19, cConv0
beq $t0, 20, dConv0
beq $t0, 21, eConv0
beq $t0, 22, fConv0
b hexdig1
aConv0:
li $t0, 10
b hexdig1
bConv0:
li $t0, 11
b hexdig1
cConv0:
li $t0, 12
b hexdig1
dConv0:
li $t0, 13
b hexdig1
eConv0:
li $t0, 14
b hexdig1
fConv0:
li $t0, 15
b hexdig1
########################################################################################################################################################
hexdig1:
addi $t2, $t2, 1
multu $t0, $t6
mflo $t4
beq $t2, $t3, hexdig2init
b hexdig1
########################################################################################################################################################
hexdig2init: 
li $t0, 0			#reset counters for hex conversion
li $t2, 0			
li $t3, 1
lb $t0, 3($s0)			# load byte 3 of $s0
sub $t0, $t0, 48		# conver tto ascii
bgt $t0, 9, hexchartodec2	# branch to converter if ascii value if of a letter
########################################################################################################################################################
hexchartodec2:				#check the ascii value of $t0 after subtracting 48 and assign the correct decimal value.

beq $t0, 17, aConv1
beq $t0, 18, bConv1
beq $t0, 19, cConv1
beq $t0, 20, dConv1
beq $t0, 21, eConv1
beq $t0, 22, fConv1
b hexdig2
aConv1:
li $t0, 10
b hexdig2
bConv1:
li $t0, 11
b hexdig2
cConv1:
li $t0, 12
b hexdig2
dConv1:
li $t0, 13
b hexdig2
eConv1:
li $t0, 14
b hexdig2
fConv1:
li $t0, 15
b hexdig2
hexdig2:
addi $t2, $t2, 1
multu $t0, $t3
mflo $t7
add $s2, $t7, $t4
beq $t2, $t3, hexorbinary2
########################################################################################################################################################
binaryloop1:	
						#Convert Argument 1 to ASCII
		li $t2, 0			
		li $t3, 2			
		li $t4, 0
	ASCII2Int1:
		lb 	$t0, 1($s0)		# Loads first byte of program argument into $t0 
		beqz 	$t0, signextend		# Breaks loop when it hits /0
		subi 	$t0, $t0, 48		# Subtract 48 to get to decimal
		multu   $t2, $t3		# Multiply by 2
		mflo 	$t4			# Load the lower result from the multu instruction using mflo
		add	$t4, $t4, $t0		# Adds the first byte of arguement with $t4
		move 	$t2, $t4		# Move result to $t2
		addi	$s0, $s0, 1		# increment over entire address
		b ASCII2Int1			# Branch to iterate over the entire address
	signextend:  	 
	
		sll $t4, $t4, 24              # shift logic left 24 bits
		sra $t4, $t4, 24              # shift right artihmetic for 24 bits
		move $s2, $t4 	              # store sign extended number inside $s0
	b hexorbinary2
########################################################################################################################################################
hexorbinary2:				      # check argument 2 to see if it is hex or binary
      li $t1, 0 			      # reset t1
      lb $t1, 1($s1)
      beq $t1,0x00000078,hexloop2
      beq $t1,0x00000062,binaryloop2
########################################################################################################################################################

hexloop2:
li $t0, 0				        #reset counters for accurate numbers
li $t2, 0			
li $t3, 1
li $t6, 16
lb $t0, 2($s1)					# Loads first byte of program argument into $t0 
sub $t0, $t0, 48				# Convert to ascii	
bgt $t0, 9, hexchartodec3			# check value for ascii letter
b hexdig3
########################################################################################################################################################
hexchartodec3:				#check the ascii value of $t0 after subtracting 48 and assign the correct decimal value.

beq $t0, 17, aConv2
beq $t0, 18, bConv2
beq $t0, 19, cConv2
beq $t0, 20, dConv2
beq $t0, 21, eConv2
beq $t0, 22, fConv2
b hexdig3
aConv2:
li $t0, 10
b hexdig3
bConv2:
li $t0, 11
b hexdig3
cConv2:
li $t0, 12
b hexdig3
dConv2:
li $t0, 13
b hexdig3
eConv2:
li $t0, 14
b hexdig3
fConv2:
li $t0, 15
b hexdig3
########################################################################################################################################################
hexdig3:
addi $t2, $t2, 1
multu $t0, $t6
mflo $t4
beq $t2, $t3, hexloop4
b hexdig3

########################################################################################################################################################
hexloop4: 
li $t0, 0
li $t2, 0			
li $t3, 1
lb $t0, 3($s1)				# Loads third byte of program argument into $t0 
sub $t0, $t0, 48
bgt $t0, 9, hexchartodec4
b hexdig4
hexchartodec4:
########################################################################################################################################################
beq $t0, 17, aConv3		#check the ascii value of $t0 after subtracting 48 and assign the correct decimal value.
beq $t0, 18, bConv3
beq $t0, 19, cConv3
beq $t0, 20, dConv3
beq $t0, 21, eConv3
beq $t0, 22, fConv3
b hexdig4
aConv3:	
li $t0, 10
b hexdig4
bConv3:
li $t0, 11
b hexdig4
cConv3:
li $t0, 12
b hexdig4
dConv3:
li $t0, 13
b hexdig4
eConv3:
li $t0, 14
b hexdig4
fConv3:
li $t0, 15
b hexdig4
########################################################################################################################################################
hexdig4:
addi $t2, $t2, 1
multu $t0, $t3
mflo $t7
addu $s3, $t7, $t4

beq $t2, $t3, adder
########################################################################################################################################################
binaryloop2:
						#Convert Argument 2 to ASCII
		li $t2, 0			
		li $t3, 2
		li $t4, 0		
	
	ASCII2Int2:
		lb 	$t0, 1($s1)		# Loads first byte of program argument into $t0 
		beqz 	$t0, signextend2	# Breaks loop when it hits /0
		subi 	$t0, $t0, 48		# Subtract 48 to get to decimal
		multu   $t2, $t3		# Multiply by 2
		mflo 	$t4			# Load the lower result from the multu instruction using mflo
		add	$t4, $t4, $t0		# Adds the first byte of arguement with $t4
		move 	$t2, $t4		# Move result to $t2
		addi	$s1, $s1, 1		# increment over entire address
		b ASCII2Int2			# Branch to iterate over the entire address
	signextend2:  	 
	
		sll $t4, $t4, 24                # shift logic left 24 bits
		sra $t4, $t4, 24                # shift right artihmetic for 24 bits
		move $s3, $t4 	                # store sign extended number inside $s0
	b adder
########################################################################################################################################################
adder:					        # add the values of both 

add  $t5, $s2, $s3			        # add the values of 
move $s0, $t5					# Move values to match lab requirements 
move $s1, $s2					# Move values to match lab requirements 
move $s2, $s3					# Move values to match lab requirements 


b base4convertbin1

########################################################################################################################################################
base4convertbin1:		             #perform four divsion since the number can only be of the size to perform 4.
li $t0, 4
li $t6, 0

	divu $t5, $t0          		      # divide string by 4
	mflo $t1	                      # quitient
	mfhi $t2	                      # remainder

base4convertbin2:
	divu $t1, $t0
	mflo $t3			      # qoutient 
	mfhi $t4	                      # remainder

	
base4convertbin3:	
	divu $t3, $t0
	mflo $t6			      #quotient
	mfhi $t7		              #remainder
	
base4convertbin4:	
	divu $t6, $t0
	mflo $t8			      #quotient
	mfhi $t9		              #remainder


b printer1
################################################################################################################################################################################################################################################################################################################



printer1:
li $v0, 4
la $a0 output
syscall
bltz $t5, printneg	                        # check for negative output and output neg sign
b printer2
printneg:
li $a0, '-'					# load negative sign
li $v0, 11   					# print_character
syscall
b printer2
printer2: 	
beqz $t9, printer3			     # check for leading zeros
addi $t9, $t9, 48			     # convert to ascii
li $v0, 11
la $a0, ($t9)				     # print
syscall
printer3:
addi $t7, $t7, 48			     # convert to ascii

li $v0, 11
la $a0, ($t7)				     # print
syscall

addi $t4, $t4, 48			     # convert to ascii

li $v0, 11				     
la $a0, ($t4)				     # print as string
syscall

addi $t2, $t2, 48		         # convert to ascii 
li $v0, 11
la $a0, ($t2)				     #print
syscall

b exit

########################################################################################################################################################
exit:
li $v0, 4
la $a0 newline
syscall
#end using syscall 10
li $v0, 10
syscall

 Description: This program performs operations to encrypts and decrypts strings using a user provided key and string.
# Notes:       This program is intended to be run from the MARS IDE. 

####################################################################################
#Comment Note:
# Comments for encryption and decryption are the same, special notes are made.
# register usage:
# $s0: user entry of decrypt or encrypt
# $s1: encryption key
# $s2: string to encrypt
# $s4: used to hold input and help in error checking, couldn't make it work without a saved register.
# $t0: holdes bytes for conversion
# $t1: holds byte for conversions
# $t2: misc, counter
# $t3: misc, used for conversions
# $t4: used for conversions and holding remainde4r
# $t5: used for holding the sum of the two 32-bit two’s complement integers
# $t6: used to hold the checksum value.
# $t8: incrementer for memory address


####################################################################################
.data
errormsg: .asciiz "Error, please try again with proper input."
buffer: .space 50
buffer2: .space 50
buffer3: .asciiz "                                 "
encryptstring: .asciiz "<Encrypted>" 
decryptstring: .asciiz "<Decrypted>"
finalprompt: .asciiz "Here is the encrypted and decrypted string \n"
newline:	.asciiz "\n"
.text
####################################################################################################################################################
give_prompt:

beq $a1, 0, give_prompt0		#check a1 for prompt value and branch accordingly.
beq $a1, 1, give_prompt1
beq $a1, 2, give_prompt2


			
give_prompt0:				#issue prompt 0
syscall
li $v0, 12				#issue prompt and collect user input
syscall	
move $s4, $v0				#load $v0 into $s4 to check if it is a valid input
blt $s4, 68, error
bge $s4, 70, errorcheck   
j give_promptfin			#if its a valid input, jump to the end of prompt printing.
errorcheck:
bne $s4, 88, error
j give_promptfin
give_prompt1:
li $v0, 4
syscall
li $v0, 8
la $a0, buffer2  			# load byte space into address
li $a1, 100      			# allot the byte space for string
syscall
move $v0, $a0


j give_promptfin


give_prompt2:	
li $v0, 4
syscall
li $v0, 8
la $a0, buffer  				# load byte space into address
li $a1, 100     				 # allot the byte space for string
syscall
move $v0, $a0
j give_promptfin

give_promptfin:
jr $ra	
####################################################################################################################################################
cipher:
b compute_checksum
compute_checksum:

move $t5, $s1
lb $t1, 0($s1)
lb $t2, 1($t5)

xor $t3, $t1, $t2
addi $t5, $t5, 1				 #increment address
addi $s1, $s1, 1 				#increment address 

b compute_checksum2

compute_checksum2:

lb $t2, 1($t5)
blt $t2, 47, checksummod 
xor $t3, $t3, $t2
addi $t5, $t5, 1 				#increment address 
bnez $t2, compute_checksum2

checksummod:
li $t0, 26
div $t3, $t0
mfhi $t6 					#  #checksum

move $s6, $s2

b encryptordecrypt

####################################################################################################################################################


encryptordecrypt:

beq $s0, 69, encrypt			#decide whether to encrypt or decrypt
beq $s0, 68, decrypt


checkascii:
					# load bytes of string
lb $t1, 0($t0)		
blt $t1, 64, asciinon			# check if non letter character
subi $t1, $t1, 64			# convert ascii 
ble $t1, 26, asciiupper			# act accordingly to case
ble $t1, 58, asciilower
asciiupper:
li $v0, 0
b checkasciifin
asciilower:
li $v0, 1
b checkasciifin
asciinon:
li $v0, -1
b checkasciifin


checkasciifin:
addi $t0, $t0, 1 #increment address
bnez $t1, checkascii
beqz $t1, encrypt

####################################################################################################################################################


encrypt:
 
addi $t8, $t8, 1			#counter for 4 bit word address
lb $t1, 0($s6)
addi $s6, $s6, 1             		 #increment address
beqz $t1, encryptfinish

li $t3, 0

blt $t1, 65, incrementer1		#decide whether the number is lower case or uppercase.
addi $t3, $t3, 1
bgt $t1, 90, incrementer1
addi $t3, $t3, 1

incrementer1:			         #encrypt upper case letter if it is upper case, if not, conitune to encrypt the lowercase.

beq $t3, 2, encryptupper

li $t3, 0
					#use the corresponding ascii values for uppercase and lowercase numbers.
blt $t1, 97, incrementer2
addi $t3, $t3, 1
bgt $t1, 122, incrementer2
addi $t3, $t3, 1

incrementer2:
beq $t3, 2, encryptlower
b symbol

encryptupper:
sub $t1, $t1, 65			#convert from ascii to regular
add $t1, $t1, $t6			#add the checksum
li $t4, 26				#perform mod 26
div $t1, $t4
mfhi $t1				#store the mod operation result
add $t1, $t1, 65			#convert back to ascii
move $s4, $t1				#store the entry into the string.
sb $s4, buffer3($t8)
li $s4, 0
b encrypt

encryptlower:
sub $t1, $t1, 97
add $t1, $t1, $t6
li $t4, 26
div $t1, $t4
mfhi $t1
add $t1, $t1, 97

move $s4, $t1
sb $s4, buffer3($t8)
li $s4, 0
b encrypt


symbol:
move $s4, $t1
sb $s4, buffer3($t8)
li $s4, 0
b encrypt

encryptfinish:

la $v0, buffer3
jr $ra
####################################################################################################################################################

decrypt:

addi $t8, $t8, 1		#counter for 4 bit word address
lb $t1, 0($s6)
addi $s6, $s6, 1		#increment address
beqz $t1, encryptfinish		#terminate when string is 0

li $t3, 0			#repeat the process of encryption but backwards, this time with subtraction using the corresponding ascii values
blt $t1, 65, incrementer3	# account for lowercase and uppercase.
addi $t3, $t3, 1
bgt $t1, 90, incrementer3
addi $t3, $t3, 1

incrementer3:
				
beq $t3, 2, decryptupper		# account for lowercase and uppercase.

li $t3, 0

blt $t1, 97, incrementer4		# account for lowercase and uppercase.
addi $t3, $t3, 1
bgt $t1, 122, incrementer4		# account for lowercase and uppercase.
addi $t3, $t3, 1

incrementer4:
beq $t3, 2, decryptlower		# account for lowercase and uppercase.
b dsymbol

decryptupper:
sub $t1, $t1, 65
sub $t1, $t1, $t6

bge $t1, 0, DUW
addi $t1, $t1, 26
DUW:				#while loop for decryption

add $t1, $t1, 65
move $s4, $t1
sb $s4, buffer3($t8)
li $s4, 0
b decrypt

decryptlower:
sub $t1, $t1, 97
sub $t1, $t1, $t6

bge $t1, 0, DLW
addi $t1, $t1, 26
DLW:				#while loop for decryption

add $t1, $t1, 97

move $s4, $t1
sb $s4, buffer3($t8)
li $s4, 0
b decrypt


dsymbol:
move $s4, $t1
sb $s4, buffer3($t8)
li $s4, 0
b decrypt

####################################################################################################################################################



	
print_strings:


				#a0 user input string address
				#a1 resulting string after cipher address
				#a2 Choice of E or D
move $s0, $a0			#free up a registers by saving into s registers
move $s1, $a1
move $s5, $a2



li $v0, 4
la $a0, finalprompt
syscall				#print the final prompt



la $a0, encryptstring      	#print the encryption string
syscall



beq $s5, 69, encprinter1	#decide which value to print in which order based upon whether there is decryption or encryption
beq $s5, 68, decprinter1

encprinter1: 
li $v0, 4
la $a0, ($s1)
syscall
b elseprint

decprinter1:			#print values
li $v0, 4
la $a0, ($s0)
syscall
b elseprint
				#print values
elseprint:

li $v0, 4
la $a0, decryptstring
syscall

beq $s5, 69, encprinter2	#decide which value to print in which order based upon whether there is decryption or encryption
beq $s5, 68, decprinter2

				#print values
encprinter2:
li $v0, 4
la $a0, ($s0)
syscall
b jumptodriver
decprinter2:
li $v0, 4
la $a0, ($s1)
syscall				#print values

la $a0, newline
syscall
b jumptodriver

jumptodriver:
jr $ra



####################################################################################################################################################

storeStack:
			# get stack space 
	addi $sp,$sp,-32

			#store registers to memory
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $s5, 20($sp)
	sw $s6, 24($sp)
	sw $s7, 28($sp)

	jr $ra	
			#pops stack back to register
popStack:

			# get registers from memory
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $s5, 20($sp)
	lw $s6, 24($sp)
	lw $s7, 28($sp)

			# deallocate stack space 
	addi $sp,$sp,32

	jr $ra
error:
li $v0, 4
la $a0, errormsg
syscall
li $v0, 10
syscall
####################################################################################################################################################

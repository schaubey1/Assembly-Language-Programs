# Description: This program collects two user inputs defining length of triangle legs and how many triangles to print.
#
# Notes: This program is intended to be run from the MARS IDE.
##############################################################################################################################################
.data
newline: .asciiz "\n"
prompt: .asciiz "Enter the length of one of the triangle legs: "
prompt2: .asciiz "Enter the number of triangles to print: "
##############################################################################################################################################
#Register Usage#

#t0, length of legs
#t1 amt of legs
#t2 iterator for printing spaces for forward slash
#t3, iterator for printing back slash
#t4, iterator for spacing for forward slash
#t5, iterator for forward slash
#t7, to print stuff
##############################################################################################################################################
.text
main:
li $v0, 4
la $a0, prompt
syscall

##############################################################################################################################################
li $v0, 5         	#readin user input for triangle legs
syscall
move $t1, $v0      	#save user input into $t0 containing amt of triangle legs.
###############################################################################################################################################

li $v0, 4
la $a0, prompt2    #ask user amount of triangles to create
syscall
li $v0, 5          #save user input 

syscall
move $t0, $v0      #save user input into $t1
li $t2, 0 	   #counter for printbackslashloop

##############################################################################################################################################

##############################################################################################################################################
                  		 # print back slash, top part of triangle
printbackslash:
li $t3, 0
addi $t2, $t2, 1
li $v0, 11
li $t7, 92
la $a0, ($t7)    		 #store back slash in register and print
syscall 
li $t7, 0
b fwdnewliner

fwdnewliner:
li $v0, 4
la $a0, newline 		#newline between outputs
syscall
beq $t2, $t1, backspacer

fwdspacer:

li $v0, 11
li $t7, 32
la $a0, ($t7)			#print space
syscall 
li $t7,0
addi $t3, $t3, 1		#iterate the counter
bne $t3, $t2, fwdspacer		#conditions for the counter that will decide how many spaces are to be printed.
beq $t3, $t2, printbackslash	#conditions for the counter that will decide how many spaces are to be printed.



########################################################################################################################################################

fwdslash:             #print fwd slash
li $v0, 11
li $t7, 47
la $a0, ($t7) 	      #store fwdslash slash in register and print
syscall
li $t7, 0
addi $t5, $t5, 1      #iterate the counter for how many slashes have been printed
beq $t5, $t0, command #call end loop if all triangles have been printed
subi $t2, $t2, 1      #decremeent value from $t2 in order to get the counter for backspacer.
li $t4,0              #reset backspacer counter.
b backnewliner

backnewliner: 
li $v0, 4
la $a0, newline       #newline between outputs
syscall
beq $t5, $s4, command #branch to print new triangle if all traingles have been printed.
########################################################################################################################################################
backspacer:

addi $t4, $t4, 1		#iterate the counter
sub $t6, $t2, 1			#subtract 1 from the amt. of back slashes printed to get the amount of spaces to be printed.
bgt $t4, $t6, fwdslash		#$t6 will be the uppper bound of this loop.
li $v0, 11
li $t7, 32
la $a0, ($t7)			#print space
syscall 
li $t7,0
blt $t4, $t6, backspacer	#conditions for the counter that will decide how many spaces are to be printed.
bgt $t4, $t6, fwdslash
beq $t4, $t6, fwdslash
########################################################################################################################################################
command:
addi $t8, $t8, 1 		           #iterator for the amt of triangles to be made.
blt  $t8, $t1, newtriangleline     #create a new triangle if all triangles have not been made.
beq  $t8, $t1, exit                #exit if all triangles have been made.

newtriangleline:
li $v0, 4
la $a0, newline 		         #newline between outputs
syscall 
li $t2, 0			             #reset registers for printing the next triangle.
li $t3, 0
li $t4, 0
li $t5, 0
li $t6, 0
li $t7, 0
b printbackslash                   #restart the process of printing 
########################################################################################################################################################
exit:
#end using syscall 10
li $v0, 10
syscall

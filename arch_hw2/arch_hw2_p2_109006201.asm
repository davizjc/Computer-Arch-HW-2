    .data

str1:		.asciiz "Please enter the range:\n"
str2:		.asciiz "The range is 0 to "
str3:		.asciiz "\n"
str4:		.asciiz "Round "
str5:		.asciiz " start...\n"
str6:		.asciiz "Please guess a number:\n"
str7:		.asciiz "You are out of range! Guess again! \n"
str8:		.asciiz "You win!\n"
str9:		.asciiz "You should guess from "
str10:		.asciiz " to "
str11:		.asciiz "You lose haha! The answer is "

.text

#########DONOT MODIFY HERE###########
#Setup initial 
addi $t0, $zero, 0	# minimun range
addi $t2, $zero, 0	# round
########################################## 

######How to generate random number?######## 
#addi $a1, $zero, 10	# int range [0, 10)
#addi $v0, $zero, 42	#syscall for generating random int into $a0
#syscall
#move $t3, $a0 
##########################################


#Game start!
main:

#Enter the range
_range:
	la $a0, str1	 # load address of string to print
	li $v0, 4	     # ready to print string , "Please enter the range:\n"
	syscall	         # print
	
	#scan the range
	li $v0, 5 	     #scanf
	syscall
	move $t1, $v0
	
	la $a0, str2	 # load address of string to print
	li $v0, 4	     # ready to print string , "The range is 0 to "
	syscall	         # print
	
	li $v0, 1        # ready to print int, t1 = max range 
	move $a0, $t1    # load int value to $a0 , in val 
	syscall	         # print
	
	la $a0, str3	 # load address of string to print
	li $v0, 4	     # ready to print string, prinf"\n"
	syscall	         # print
	
#Randomly generate the answer
_generate_answer:
	add $a1, $zero, $t1	# int range (0, $t1)
	addi $v0, $zero, 42	#syscall for generating random int into $a0
	syscall
	move $t3, $a0  		# move the random number to t3
	
	 	 	
_start_guess:
	la $a0, str4	    # load address of string to print 
	li $v0, 4		    # ready to print string, "Round "
	syscall	            # print 
	
	addi $s7, $t2, 1    #add 1 to t2 and store in print round + 1
	
	li $v0, 1        # ready to print int
	move $a0, $s7    # load int value to $a0   
	syscall	         # print
	
	la $a0, str5	 # load address of string to print
	li $v0, 4	 	 # ready to print string, " start...\n"
	syscall	         # print
	
	la $a0, str6	 # load address of string to print
	li $v0, 4	 	 # ready to print string "Please guess a number:\n"
	syscall	         # print
	
#enter the guess and then check the validation
_check_guess:
	#enter input
	
	li $v0, 5 	    #scanf  guess 
	syscall
	move $s1, $v0   #store guess in $s1
	 
	#check input
						
	bgt       $s1,$t1,_incorrectinput           # branch to label if (rs>rt) if guess > max
	blt       $s1,$t0,_incorrectinput           # branch to label if (rs<rt) if guess < min
	j _correctinput

#if the input is correct, continue the program and check the guess
#after that, jump to _fiveround to check the rounds 
_correctinput:
	#the player get the right answer,jump to _Win
	
	beq $s1, $t3, _Win		#branch to label if (rs==rt) , s1= guess , t3 = random number ( ans)
 
	#the player's answer is bigger/smaller than the range -> update the range
	
	bgt       $s1,$t3,_smaller_than_max		     # branch to label if (rs>rt) Guess > random number go the smaller than max
	blt       $s1,$t3,_bigger_than_min           # branch to label if (rs<rt) Guess < random number go the bigger than max


	
#update the range	
_bigger_than_min:
	add $t0,$s1,1				# min = guess + 1 
	j _fiveround

_smaller_than_max:					
	sub $t1,$s1,1 				# max = guess - 1 				
	j _fiveround

#if the player guess a invalid number, ask the player to retry	
_incorrectinput:
	la $a0, str7	    # pirnt str, "You are out of range! Guess again! \n"
	li $v0, 4
	syscall
	j _check_guess		# guess again
	
	
#if the player win, the program can exit
_Win:
	la $a0, str8	    # print str,  "You win!\n"
	li $v0, 4
	syscall
	j _Exit

#if the player is out of round, you lose the game and the program can exit
#if the player still have chance,jump to _nextround to start a new round(from _start_guess)
_fiveround:
	blt $t2,4,_nextround # if round < 4 go to nextround
	la $a0, str11	     # print str,"You lose haha! The answer is "
	li $v0, 4
	syscall

	li $v0, 1	         # print int max, t3 = ans
	move $a0, $t3        # load int value to $a0	
	syscall 
	j _Exit						
								
_nextround:
	la $a0, str9	     # print str,"You should guess from "
	li $v0, 4
	syscall	

	li $v0, 1	         # print int min  t0 = min
	move $a0, $t0	
	syscall

	la $a0, str10	     # print str,"to"
	li $v0, 4
	syscall	

	li $v0, 1	         # print int max, t1 = max
	move $a0, $t1        # load int value to $a0	
	syscall 

	la $a0, str3	     # load address of string to print
	li $v0, 4	         # ready to print string, prinf"\n"
	syscall	             # print

	add $t2, $t2, 1		 # round = round + 1 , round ++

	j _start_guess
			
#terminated	
_Exit:
	li $v0, 10
  	syscall

    

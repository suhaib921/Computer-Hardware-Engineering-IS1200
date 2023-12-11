  # timetemplate.asm
  # Written 2015 by F Lundevall
  # Copyright abandonded - this file is in the public domain.
  
  # implementerar en tidsmätning och skriver ut den i form av en sträng. 

.macro	PUSH (%reg) #sparar den som den pekar på till stacken
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

	.data
	.align 2
mytime:	.word 0x5957
timstr:	.ascii "text more text lots of text\0"
	.text
#"main" anropar flera underfunktioner: "delay", "tick", och "time2string". funktionen skriver ut
#funktionen "tick"uppdatera tiden
#"time2string" omvandlar tiden till en sträng 
#"delay" väntar en stund innan processen upprepas
main:
	# print timstr
	la	$a0,timstr #loads the memory address of "timstr" into the register "$a0"
	li	$v0,4 # loads the value 4 into the register "$v0", which is the system call code for printing a string.
	syscall
	nop
	# wait a little
	li	$a0,2 # loads the value 2 into the register "$a0".
	jal	delay #jumps to delay and stores the return address in the register "$ra".
	nop
	# call tick
	la	$a0,mytime #loads the memory address of the "mytime" label into the register "$a0"
	jal	tick #jumps to tick" and stores the return address in the register "$ra"
	nop
	
	# call your function time2string
	la	$a0,timstr #convert the time stored at "mytime" into a string format, which will then be stored at the memory location pointed to by "$a0"
	la	$t0,mytime #Loads the memory address of the label "mytime" into the register "$t0"
	lw	$a1,0($t0) #Loads the word stored at the memory location pointed to by "$t0" into the register "$a1"
	jal	time2string
	nop
	# print a newline
	li	$a0,10
	li	$v0,11
	syscall
	nop
	# go back and do it all again
	j	main
	nop
#keep track of time and make sure that the time value is in the correct format (hh:mm)
# tick: update time pointed to by $a0
tick:	lw	$t0,0($a0)	# get time #loads the words stored in memory location a0 to t0
	addiu	$t0,$t0,1	# increase
	andi	$t1,$t0,0xf	# check lowest digit
	sltiu	$t2,$t1,0xa	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x6	# adjust lowest digit
	andi	$t1,$t0,0xf0	# check next digit
	sltiu	$t2,$t1,0x60	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa0	# adjust digit
	andi	$t1,$t0,0xf00	# check minute digit
	sltiu	$t2,$t1,0xa00	# if digit < a, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0x600	# adjust digit
	andi	$t1,$t0,0xf000	# check last digit
	sltiu	$t2,$t1,0x6000	# if digit < 6, okay
	bnez	$t2,tiend
	nop
	addiu	$t0,$t0,0xa000	# adjust last digit
tiend:	sw	$t0,0($a0)	# save updated result #stores the contents of "$t0" at the memory location pointed to by "$a0". This saves the updated time value.
	jr	$ra		# return
	nop
hexasc:
   	andi	$a0,$a0,0xf	#only 4 least significant bits ignore other bits	
   	addi	$v0,$zero,0x30	#$v0 = 0x30 ('0')
   	addi	$t0,$zero,0x9	#t0 = 0x9
   	
   	ble	$a0,$t0,L1		#branch if a0 <= 0x9
   	nop
   	addi	$v0,$v0,0x7		#v0 = v0 +0x7
   	
   	
   L1:
   	add	$v0,$a0,$v0 	#v0 = V0 +a0
   	jr	$ra
   	nop

# New delay funtion (Task 4)
delay:
	#PUSH	($ra)				#Store the return address in the stack
	move 	$t1, $a0			# Store argument in temp so we can use it as the loop counter for while
	
	#how many 
	while:
		ble	$t1, $zero, exit_delay	# Check if ms(t1) >= 0 (jump to exit if not)
		nop
		sub	$t1, $t1, 1 		# ms(t1)--;
		
	li	$t2, 0				# int i	= 0		
	#millisecond
	for:
		bge	$t2, 35000, while	# Check if i(t2) < parameter (Can be changed for speed), then jump or continue
		nop
		addi	$t2, $t2, 1		# i++;
		j	for			# Go to next iteration of for loop
		nop
			
	exit_delay:				# End of subroutine
		#POP	($ra)			# Restore the return adress from the stack
		jr	$ra			# Jump back to caller(the return address)
		nop
  # you can write your code for subroutine "hexasc" below this line
  
  
# Converts time-info into a string of printable characters, with a null-byte as an end-of-string-marker
# $a0 contains the adress to the section of memory where we will store the result.
# $a1 conains the NBCD-encoded time info, where we only consider the 16 LSB.
time2string:
PUSH	($s0)
	PUSH	($s1)				# Save contents of s1 to restore it after the function ends
	PUSH	($ra)				# Save the return adress on the stack
	
	move	$s1, $a1			# Move contents of $a0 to $s1 so we can work with it
	move	$s0,$a0  			#timstr

	# First digit #Hämtar första nibble som är första i minuten. 1x:xx
	andi 	$t1, $s1, 0xf000		# Masking out bit from index 15 to 12
	srl 	$a0, $t1, 12			# Shifting the bits to lowest position and store it in $a0 for hexas
	jal	hexasc				# Calling the hexasc that will transform the decimal into hexadecimal
	nop
	sb 	$v0, 0($s0)		 	# Save the return value from hexasc in the first byte location $s1 
						# points to					

	# Second digit #Hämtar andra nibble som är första i minuten. x1:xx
	andi 	$t1, $s1, 0x0f00		# Masking out bit from index 11 to 8
	srl 	$a0, $t1, 8			# Shifting the bits to lowest position and store it in $a0 for hexasc
	jal	hexasc				# Calling the hexasc that will transform the decimal into hexadecimal
	nop
	sb 	$v0, 1($s0)		 	# Save the return value from hexasc in the second byte location $s1 
						# points to					

	# Adding the colon 
	li 	$t1, 0x3a			# Loading the ASCII code for colon
	sb 	$t1, 2($s0)		 	# Save the return value from hexasc in the third byte location $s1 
						# points to
	
	# Third digit #Hämtar tredje nibble som är första i sekunden. xx:1x 
	andi 	$t1, $s1, 0x00f0		# Masking out bit from index 7 to 4
	srl 	$a0, $t1, 4			# Shifting the bits to lowest position and store it in $a0 for hexasc
	jal	hexasc				# Calling the hexasc that will transform the decimal into hexadecimal
	nop
	sb 	$v0, 3($s0)		 	# Save the return value from hexasc in the fourth byte location $s1 
						# points to
										
	# Forth digit #Hämtar fjärde/sista nibble som är första i sekunden. xx:x1 
	andi 	$t1, $s1, 0x000f		# Masking out bit from index 3 to 0
	move 	$a0, $t1			# No need for shifting, just move it to the argument.
	jal	hexasc				# Calling the hexasc that will transform the decimal into hexadecimal
	nop
	sb 	$v0, 4($s0)		 	# Save the return value from hexasc in the fifth byte location $s1 
						# points to
	##suprised question
	
	andi 	$t1, $s1, 0x00ff		# Masking out bit from index 3 to 0
	beq	$t1, 0000, ding			#Om vill skriva ut word 0 så kan du antigen använda O(word 0) för att skriva 4 btyes eller kan du använda byte addressen
	
	# Adding the NUL byte
	li	$t1, 0x00			# Loading the ASCII code for NUL
	sb 	$t1, 5($s0)		 	# Save the return value from hexasc in the sixth byte location $s1 
	j	exit_time2string		# points to
	
ding:				# Sätter in X då tiden är xx:00, Resultat: xx:00X
	li $t1, 0x54		#Sätter ASCII värdet för G
	li $t2, 0x57 		#Sätter ASCII värdet för Null
	li $t3, 0x4f 		#Sätter ASCII värdet för Null
	li $t4, 0x0		#Sätter ASCII värdet för G
	
	
	
	sb $t1, 4($s0)		#och sparar detta i byte 5 av $s0
	sb $t2, 5($s0)		#och sparar detta i byte 5 av $s0
	sb $t3, 6($s0)		#och sparar detta i byte 5 av $s0
	sb $t4, 7($s0)		#och sparar detta i byte 5 av $s0	
	
	
	j	exit_time2string		# points to


	# End of subroutine. Restoring registers and jumping back to caller.
	exit_time2string:																																																																																										
		POP	($ra)
		POP	($s1)
		POP	($s0)	
 		jr 	$ra
 		nop	

 	# Subroutine to add an X in the output when a minute has passed		

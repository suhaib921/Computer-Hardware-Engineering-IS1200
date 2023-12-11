  # hexmain.asm
  # Written 2015-09-04 by F Lundevall
  # Copyright abandonded - this file is in the public domain.
  
  #30-39-->0-9  41-46-->A-F

	.text
main:
	li	$a0,17	# change this to test different values

	jal	hexasc		# call hexasc
	nop			# delay slot filler (just in case)	

	move	$a0,$v0		# copy return value to argument register

	li	$v0,11		# syscall with v0 = 11 will print out
	syscall			# one byte from a0 to the Run I/O window
	
stop:	j	stop		# stop after one run
	nop			# delay slot filler (just in case)

  # You can write your own code for hexasc here
  #30-39(48-57 decimal) load Ascci code for 1-9
  #65-70 load ASCII code for 'A-F'
  #With bitwise make 

hexasc:
	
   	andi	$a0,$a0,0xf	#only 4 least significant bits ignore other bits	
   	addi	$v0,$zero,0x30	#$v0 = 0x30 ('0')
   	addi	$t0,$zero,0x9	#t0 = 0x9
   	
   	ble	$a0,$t0,under		#branch if a0 <= 0x9
   	nop
   
   	
   	addi	$v0,$v0,0x7		#v0 = v0 +0x7
   	add	$v0,$v0,$a0	
   	jr $ra 				#Adds the value in $a0 to $v0 and returns to the caller via the return address ($ra) register.
   	
   under:
   	add	$v0,$v0,$a0	#v0 = V0 +a0
   	jr	$ra		#jump to register with the return value 
   	nop

#The code performs the following steps:
#Keeps only the 4 least significant bits of the $a0 register using the "andi" instruction.
#Initializes the $v0 register with the ASCII code for '0' (0x30).
#Initializes a temporary register $t0 with the value 0x9.
#Branches to label L1 if the value in $a0 is less than or equal to 0x9.
#Adds 0x7 to $v0 if the previous branch was not taken.
#Adds the value in $a0 to $v0 and returns to the caller via the return address ($ra) register.




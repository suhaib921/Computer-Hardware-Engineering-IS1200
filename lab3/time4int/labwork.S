  # labwork.S

.macro	PUSH reg
	addi	$sp,$sp,-4
	sw	\reg,0($sp)
.endm

.macro	POP reg
	lw	\reg,0($sp)
	addi	$sp,$sp,4
.endm
  #
  # Please add your own code below this line
  #
	.global delay
	.global time2string
	.global enable_interrupt

enable_interrupt:
	ei						#Instruktionen "ei" aktiverar globala avbrott i MIPS-processorn. S. 142 http://ww1.microchip.com/downloads/en/DeviceDoc/61143H.pdf
	jr $ra
	nop 


hexasc:
      andi  $a0,$a0,15        #0xf. Ta bara 4 lsb
      addi  $v0,$zero,48      #30.  $v0 = 0x30, alltså plats v0=48 motsvarar 0 i ASCII-tabellen
      addi  $t0,$zero,9       #t0 = 0x9
      
      ble   $a0,$t0,underTio  #hoppa om a0 <= 0x9
      nop
      addi  $v0,$v0,7         #Om över tio! 7. v0 = 48+7=55. Sedan läggs ursprunliga värdet från a till. 
      
   underTio:
      add   $v0,$a0,$v0	    #Om under 10. v0 = 48+9=57
      jr    $ra
      nop   

delay:
	PUSH	$ra
	#Behöver vi pusha något mer? Anpassa delay! För argument 0, -1??? Uppdatera innehåll i mcb32-versionen!!!
	
	move 	$t1, $a0			# lägg in det inpassade argumentet i temp så att vi kan använda det
	
	start:
		ble	$t1, $zero, avsluta_delay	# Hoppa om argumentet/temp är 0, alltså vi är klara. Vi kommer att köra for-loopen nedan 1000 gånger när delayen kallas
		nop
		sub	$t1, $t1, 1 		#subtrahera med 1
		li	$t4, 0				# ladda in 0 på temp2	
	for:
		bge	$t4, 225, start		# Hoppa till startloop om t2 har räknat till 225
		nop
		addi $t4, $t4, 1		# Öka t2
		j	for			# Kör loopen igen
		nop
			
	avsluta_delay:				
		POP	$ra			# lägg tillbaka ra
		jr	$ra
		nop


time2string:
	PUSH	$s0				#Varför sparas s0 och s1? a0 = timstr = "text more text lots of text\0". a1 = 5957
	PUSH	$s1				
	PUSH	$ra	
			
	move	$s0,$a0	
	move	$s1, $a1

	# Isolera ind 15-20, siffra 1, och skifta dit, gör om till ascii hexadecimal med hexasc, spara i returvärdet v0s första byte
	andi 	$t1, $s1, 0xf000		
	srl 	$a0, $t1, 12			
	jal	hexasc
	nop
	sb 	$v0, 0($s0)			
	# Isolera bit 11-8...
	andi 	$t1, $s1, 0x0f00		
	srl 	$a0, $t1, 8
	jal	hexasc				
	nop
	sb 	$v0, 1($s0)		 	

	li 	$t1, 0x3a			# Lägg :	
	sb 	$t1, 2($s0)		 		
	# Isolera bit 7-4
	andi 	$t1, $s1, 0x00f0		
	srl 	$a0, $t1, 4			
	jal	hexasc				
	nop
	sb 	$v0, 3($s0)		 			
	# Isolera bit 3-0
	andi 	$t1, $s1, 0x000f
	move 	$a0, $t1			# Ingen skiftning nödvändig
	jal	hexasc			
	nop
	sb 	$v0, 4($s0)		 	

	li	$t1, 0x00			# Null-byten laddas in!
	sb 	$t1, 5($s0)		 
	j	avsluta_time2string	
	
	avsluta_time2string:																																																																																										
		POP	$ra
		POP	$s1
		POP	$s0	
 		jr 	$ra
 		nop				
.text
	addi    $a0, $zero, 0		
	add     $a1, $a0, $zero		
	add	$a2, $a0, $zero
	add	$a3, $a0, $zero
	beq	$a0, $zero, Noll	#ifall att input �r 0
	beq	$a0, 1, Noll		#ifall att input �r 1
	addi	$v0, $zero, 1		#Ist�llet f�r att b�rja p� a0 s�tts v0 till 1 i b�rjan
	
#5!	
#15
#25
#125
#625
#390625
	

YttreSlinga:
	addi	$a1, $a1, -1 # a1--
	beq	$a1, 1, Stop	 # om a1=1  ->  till stop
	add	$a2, $a1, $zero	 # a2=a1
	add	$a3, $v0, $zero	 #a3 = v0 varje g�ng!
	InreSlinga:
		mul	$v0, $v0, $a3	#v0=v0*a3. Mul ist�llet f�r add
		addi	$a2, $a2, -1 #a2--
		beq	$a2, 1, YttreSlinga #om a2 har n�tt 1 -> l�mna for loop
		beq	$zero, $zero, InreSlinga 
		

Stop:
	beq	$0, $0, Stop
	nop

Noll:
	addi	$v0, $zero, 1	
	

.text
	addi    $a0, $zero, 0		
	add     $a1, $a0, $zero		
	add	$a2, $a0, $zero
	add	$a3, $a0, $zero
	beq	$a0, $zero, Noll	#ifall att input är 0
	beq	$a0, 1, Noll		#ifall att input är 1
	addi	$v0, $zero, 1		#Istället för att börja på a0 sätts v0 till 1 i början
	
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
	add	$a3, $v0, $zero	 #a3 = v0 varje gång!
	InreSlinga:
		mul	$v0, $v0, $a3	#v0=v0*a3. Mul istället för add
		addi	$a2, $a2, -1 #a2--
		beq	$a2, 1, YttreSlinga #om a2 har nått 1 -> lämna for loop
		beq	$zero, $zero, InreSlinga 
		

Stop:
	beq	$0, $0, Stop
	nop

Noll:
	addi	$v0, $zero, 1	
	

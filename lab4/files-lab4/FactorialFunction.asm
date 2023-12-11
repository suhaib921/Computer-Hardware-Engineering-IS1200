.text
	addi    $a0, $zero, 1		
	add     $a1, $a0, $zero		
	add	$a2, $a0, $zero
	add	$a3, $a0, $zero
	beq	$a0, $zero, Noll	#ifall att input är 0
	beq	$a0, 1, Noll		#ifall att input är 1
	add	$v0, $a0, $zero

#5! = 120
#v0: 5
#a3: 5
#v0: 20
#a3: 20
#v0: 60
#a3: 60
#v0: 120
#a3: 120


#3! = 6
#v0: 3
#v0: 6

YttreSlinga:

	addi	$a1, $a1, -1 # a1--
	beq	$a1, 1, Stop	 # om a1=1  ->  till stop
	add	$a2, $a1, $zero	 # a2=a1
	add	$a3, $v0, $zero	 #a3 = v0
	InreSlinga:
		add	$v0, $v0, $a3	#v0=v0+a3
		addi	$a2, $a2, -1 #a2--
		beq	$a2, 1, YttreSlinga #om a2 har nått 1 -> lämna for loop
		beq	$zero, $zero, InreSlinga 
		

Stop:
	beq	$0, $0, Stop
	nop

Noll:
	addi	$v0, $zero, 1




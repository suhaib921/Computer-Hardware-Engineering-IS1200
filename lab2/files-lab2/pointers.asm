
        # pointers.asm
# By David Broman, 2015-09-14
# This file is in the public domain


.macro	PUSH (%reg)
	addi	$sp,$sp,-4
	sw	%reg,0($sp)
.end_macro

.macro	POP (%reg)
	lw	%reg,0($sp)
	addi	$sp,$sp,4
.end_macro

.data


text1: 	  .asciiz "This is a string."
text2:	  .asciiz "Yet another thing."

.align 2
list1: 	.space 80
list2: 	.space 80
count:	.word  0

.text
main:
	jal	work
stop:	j	stop

# function work() 
work:
	PUSH	($ra)	// push return value to stack
	la 	$a0,text1 //load text address to register a0
	la	$a1,list1 // load list memory address  to register a1
	la	$a2,count // load count memory address to register a2
	jal	copycodes
	
	la 	$a0,text2
	la	$a1,list2
	la	$a2,count
	jal	copycodes
	POP	($ra)	// pop return value from the stack
	
	
# function copycodes()
copycodes:
loop:
	lb	$t0,0($a0)	// load a byte from text1 0(a0) into register t0
	beq	$t0,$0,done	// check if the load byte is null. if it is done
	sw	$t0,0($a1)	// store the content of register t0 into memory destination a1

	addi	$a0,$a0,1	// incremet the pointer to next byte
	addi	$a1,$a1,4	// increment by 4 of the memory destination 
	
	lw	$t1,0($a2)	// load the count of the count memory space into register
	addi	$t1,$t1,1	// increment the count
	sw	$t1,0($a2)	// store the increment register back into the count memory.
	j	loop
done:
	jr	$ra
		




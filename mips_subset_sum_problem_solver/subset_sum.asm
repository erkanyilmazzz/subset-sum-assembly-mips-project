.data
please_enter_size_arr: .asciiz "please enter sizof array"
please_enter_sum :	.asciiz "please enter sum"

posible:	.asciiz "posible\n"
not_posible:	.asciiz "not posible\n"

space : .asciiz " "
newline : .asciiz "\n"


.text

main:

	#create an array with numbers user entered
	#array adres in $s0
	#v0 is size of array
	#v1 is sum 
	jal create_arr
	
	move $t0,$v0	#t0 is size of array
	move $t1,$v1	#t1 is sum
	

	move $v0,$t0
	#jal print_arr
	
	
	
	
	move $a0,$t0
	move $a1,$t1
	
	#s0 is array
	#a0 is size of array
	#a1 is sum
	#v0 is 1 if sum true
	#v0 is 0 if sum false
	jal Check_sum_posibility
	
	
	move $t0,$v0
	li $t1,1
	beq $t0,$zero,print_not_posible
	beq $t0,$t1 ,print_posible
	
	j exit

print_posible:
	li $v0,4
	la $a0,posible
	syscall
	j exit
print_not_posible:
	li $v0,4
	la $a0,not_posible
	syscall
	j exit
		



#termiante program
exit:
li $v0,10
syscall


#########################################
##create a array and stor it in $s0	#
## return v0 size of array		#
##return  v1 sum			#
########################################
create_arr:

	#pirnt message to enter size of array
	li $v0,4
	la $a0,please_enter_size_arr
	syscall

	#geting size of arr $v0 will cantain integer
	li $v0,5
	syscall

	#$t0 size of arr
	move $t0,$v0								#t0 is size of array


	
	#bir word 4 byte
	li $t1,4
	#kaç byte ayýracaðýmý hesaplýyorum .t1=kaç bytelýkyer açýlacak 	 
	mul $t1,$t0,$t1								#calculating  how much memory alocated
	#4*sizeof arr($t0)==$t1 byte need
	move $a0,$t1
	li $v0,9								#allocating memory
	syscall #16 byte yer ayýr $v0 a adresini yaz
	#arr is in s0
	move $s0,$v0
									#array is in $s0

	#pirnt message to enter size of array
	li $v0,4
	la $a0,please_enter_sum
	syscall

			#geting sum $v0 will cantain integer
	li $v0,5
	syscall
	move $t7,$v0

add $t1,$zero,$zero	#i=0;
addi $t0,$t0,-1		##t0=size-1
begin_loop:
	bgt $t1,$t0,exit_loop	#will i<arraysize -1	
	sll $t3,$t1,2
	addu $t3,$t3,$s0
	
	li $v0,5
	syscall
	move $t4,$v0
	
	
	sw $t4,0($t3)
	
	
addi $t1,$t1,1		#i++

j begin_loop

exit_loop:

addi $t0,$t0,1		#t0++
move $v0,$t0		#return $t0 sizeof array
move $v1,$t7		#return sum
#end of funtion
jr $ra
########################################################################################################################



#################################
#use array in s0		#
#use array size in v0		#
#print it in terminal		#
################################
print_arr:
	move $t0,$v0	#t0 is size of array


	add $t1,$zero,$zero	#i=0;
	addi $t0,$t0,-1	##t0=size-1
	print_begin_loop:
		bgt $t1,$t0,exit_loop	#will i<arraysize -1	
		sll $t3,$t1,2
		addu $t3,$t3,$s0

		lw $t4,0($t3)	
		move $a0,$t4
		li $v0,1
		syscall
	

	
	
		addi $t1,$t1,1		#i++

		li $v0,4
		la $a0,space
		syscall
		
		j print_begin_loop

	print_exit_loop:

	#end of funtion
	jr $ra
########################################################################################################################


#########################################
#@param s0 is array			#
#@param a0 is size of array		#
#@param  a1 is sum			#
#@retun v0 is 1 if sum true		#
#@return v0 is 0 if sum false		#
#s1 use for array size 			#
#s2 use for  sum 			#
#s3 use for or result 			#
#s4 use for iteration			#
########################################
Check_sum_posibility:
        addiu	$sp, $sp, -24
	sw	$ra, 0($sp)
	sw	$s1, 4($sp)	#for array size
	sw	$s2, 8($sp)	#for sum
	sw 	$s3, 12($sp)	#for or result temp
	sw	$s4, 16($sp)	#for iterator 
	sw	$s5, 20($sp)	
	
	move $s1,$a0		#s1 is aray size
	move $s2,$a1		#s2 is sum
	
	####debug
#	li $v0,4
#	la $a0 newline 
#	syscall
#	li  $v0,1
#	move $a0,$s1
#	syscall
#	li $v0,4
#	la $a0 space 
#	syscall
#	li  $v0,1
#	move $a0,$s2
#	syscall
	#debug end
	
	
	li $v0,1
	beq $s2,$zero,finish	#if (sum==0) => return 1

	li $v0,0
	beq $s1,$zero,finish	#if(array_size==0)=> return 0
	
	
	
	#sum is same
	addi $s1,$s1,-1	#arrya size = array size -1
	move $a0,$s1
	move $a1,$s2
	jal Check_sum_posibility	#v0=Check_sum_posibility(sum,array_size -1)
	move $s3,$v0			#s3=Check_sum_posibility(sum,array_size -1)
	
	
	#sum is same 
	#array size =array size -1
	sll $s4,$s1,2	#s4=4*arraysize-1
	add $s4,$s4,$s0	#s4=arr[arraysize-1]
	lw  $s5,0($s4)
	sub $s2,$s2,$s5 #sum=sum-arr[arrasize-1]##############################eksi olma durumu
	
	move $a0,$s1
	move $a1,$s2
	jal Check_sum_posibility #v0=Check_sum_posibilty(sum-arr[arraysize-1],array_size -1)
	or $v0,$s3,$v0

	j finish		
finish: 

	lw	$s5, 20($sp)
	lw	$s4, 16($sp)
	lw	$s3, 12($sp)
        lw	$s2, 8($sp)
	lw	$s1, 4($sp)
	lw	$ra, 0($sp)
	addiu	$sp, $sp, 24
	jr	$ra

							
	

##冒泡排序##
.data
	input_buff:.space 512

.text
	la $t5,input_buff		#这是我自己给的一组数，没有经过文件读写操作
	li $t6,2			#保存的数为2 7 0 9
	sw $t6,0($t5)
	li $t6,7
	sw $t6,4($t5)
	li $t6,0
	sw $t6,8($t5)
	li $t6,9
	sw $t6,12($t5)


	la $a0,input_buff
	li $a1,4
	jal sort
	j finish

sort:
	addi $sp,$sp,-20		#保存原来的值，在完成之后恢复之前的值
	sw $ra,16($sp)
	sw $s3,12($sp)
	sw $s2,8($sp)
	sw $s1,4($sp)
	sw $s0,0($sp)
	
	move $s0,$zero			#给循环变量赋值，s0为i
loopbody1:
	bge $s0,$a1,exit1		#如果s0>a1，则跳转出循环
	
	addi $s1,$s0,-1			#s0为j,在内存循环开始之前，赋初值i-1
loopbody2:
	blt $s1,$zero,exit2		#如果j<0则跳转
	sll $t1,$s1,2
	add $t2,$a0,$t1
	lw $t3,0($t2)			#读取两个元素值
	lw $t4,4($t2)
	ble $t3,$t4,exit2		#进行比较
	
	move $s2,$a0
	move $s3,$a1
	move $a0,$s2
	move $a1,$s1 
	jal swap			#调用交换函数
	
	addi $s1,$s1,-1
	j loopbody2
exit2:	
	addi $s0,$s0,1
	j loopbody1
exit1:
	lw $ra,16($sp)			#恢复在函数调用之前的这些值
	lw $s3,12($sp)
	lw $s2,8($sp)
	lw $s1,4($sp)
	lw $s0,0($sp)
	addi $sp,$sp,20
	jr $ra				#返回到主函数

swap:					#交换函数
	sll $t1,$a1,2
	add $t1,$a0,$t1
	lw $t0,0($t1)
	lw $t2,4($t1)
	sw $t2,0($t1)
	sw $t0,4($t1)
	jr $ra
	
finish:					#进行结果输出
	la $t5,input_buff
	lw $a0,0($t5)
	li $v0,1
	syscall
	lw $a0,4($t5)
	li $v0,1
	syscall
	lw $a0,8($t5)
	li $v0,1
	syscall
	lw $a0,12($t5)
	li $v0,1
	syscall
	
	

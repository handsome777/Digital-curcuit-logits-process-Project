##msort##
.data
	in_buff: .space 512
	out_buff: .space 512
	record :.space 1024
	input_file: .asciiz"E:/a.in"
	output_file:.asciiz"E:/a.out"
	
.text 
	la $k1,record
	la $a0,input_file	#input_file是一个字符串
	li $a1,0
	li $a2,0
	li $v0,13
	syscall
	
	move $a0,$v0
	la $a1,in_buff
	li $a2,4
	li $v0,14
	syscall
	
	lw $t1,in_buff	   #读取第一个数
	mul $t2,$t1,4	   #把第一个数乘4，然后把剩下的数全部读出来
	addi,$a1,$a1,4	   #把in_buff的地址+4
	move $a2,$t2	   #把要读的字节数保存在a2中
	li $v0,14	   #14，读取文件
	syscall
	
	li $v0,16	   #16，关闭文件
	syscall
	
##################################################
#下面构建链表
##################################################

	addi $a0,$zero,8	#申请八比特的空间
	addi $v0,$zero,9	#9，申请空间编号
	syscall			
	move $s0,$v0		#记录头结点指针
	move $t2,$s0		#记录当前节点指针
	move $t0,$zero		#循环变量
	
	la $a1,in_buff
	addi $a1,$a1,4
	
	addi $t1,$t1,-1

new:
	addi $a0,$zero,8	#申请八比特的空间
	addi $v0,$zero,9
	syscall
	mul $t3,$t0,4		#循环变量乘4
	add $a3,$a1,$t3		
	lw $t4,0($a3)		#把新节点接入到原来的链表上
	sw $t4,0($v0)
	sw $zero,4($v0)
	sw $v0,4($t2)
	move $t2,$v0
	addi $t0,$t0,1
	ble $t0,$t1,new		#t1里面保存的是数的个数
	
	lw $t2,4($s0)		#t2重新指向头结点的后继
	
	move $v1,$t2
	
######################################################
#t2指向的是头结点的后继
#t1保存的是一共的元素个数（从0开始）
######################################################
#以下两行相当于主函数
	jal c1			
	j finish
	
c1:
	addi $sp,$sp,-8		#进行压栈操作，把head和当前的ra保存在栈里面
	sw $t2,4($sp)
	sw $ra,0($sp)
	move $t4,$t2
	jal msort
	

#a3是msort返回的head
msort:				#归并主函数
	lw $t3,4($t4)
	bne $t3,$zero,c_msort	#如果为空，那么返回
	move $a3,$t4		#如果为空，那么进行出栈操作
	lw $ra,0($sp)
	addi $sp,$sp,8
	jr $ra
	
c_msort:
	move $t5,$t4		#$t5=strike_2_pointer
	move $t6,$t4		#$t6=stride_1_pointer
	
loop1:				#找中点
	lw $t3,4($t5)
	beq $t3,$zero,c2_msort
	lw $t5,4($t5)
	lw $t3,4($t5)
	beq $t3,$zero,c2_msort
	lw $t5,4($t5)
	lw $t6,4($t6)
	j loop1

c2_msort:			#分为两个链表，并且把右边的链表头压栈
	lw $t5,4($t6)
	sw $zero,4($t6)
	addi $sp,$sp,-4
	sw $t5,0($sp)
	
#s1是l_head,s2是r_head
	jal l_head
	move $s1,$a3		#把返回的结果保存在函数调用栈里面，（本程序中有两个栈，此栈是自己开的——record）
	addi $k1,$k1,4
	sw $s1,0($k1)
	
	jal r_right
	move $s2,$a3		#把返回的结果保存在一个栈里面
	addi $k1,$k1,4
	sw $s2,0($k1)
	
	j merge		
	
c3_msort:
	lw $ra,0($sp)		#返回，出栈	
	addi $sp,$sp,8	
	jr $ra
	
l_head:
	addi $sp,$sp,-8		#左链表压栈操作
	sw $t4,4($sp)
	sw $ra,0($sp)
	jal msort
	
r_right:
	lw $t4,0($sp)		#右链表压栈操作
	addi $sp,$sp,4
	addi $sp,$sp,-8
	sw $t4,4($sp)
	sw $ra,0($sp)
	jal msort


#s1是l_head,s2是r_head,s3是head
#s4是p_left,s5是p_right
merge:
	lw $s1,-4($k1)
	lw $s2,0($k1)
	addi $k1,$k1,-8
	
	addi $a0,$zero,8	#申请八比特的空间
	addi $v0,$zero,9
	syscall
	move $s3,$v0
	sw $s1,4($s3)
	move $s4,$s3
	move $s5,$s2
	
loop2:
	loop3:				#寻找左链中的插入位子
		lw $t7,4($s4)
		beq $t7,$zero,c_loop2
		lw $t9,0($t7)
		lw $v1,0($s5)
		sub $v0,$t9,$v1
		bgtz $v0,c_loop2
		lw $s4,4($s4)
		j loop3
	c_loop2:			#如果达到左链尾部，右链直接接上
		lw $t7,4($s4)
		bne $t7,$zero,c_merge
		sw $s5,4($s4)
		j c3_merge

#s6是p_right_temp
c_merge:
	move $s6,$s5
loop4:					#寻找右链待插入片段
	lw $t7,4($s6)
	beq $t7,$zero,c2_merge
	lw $t9,0($t7)
	lw $t8,4($s4)
	lw $v1,0($t8)
	sub $v0,$t9,$v1
	bgtz $v0,c2_merge
	lw $s6,4($s6)
	j loop4
	
#s7是temp_right_pointer_next
c2_merge:				#完成插入操作
	lw $s7,4($s6)
	lw $k0,4($s4)
	sw $k0,4($s6)
	sw $s5,4($s4)
	move $s4,$s6
	move $s5,$s7
	beq $s5,$zero,c3_merge
	j loop2
	
c3_merge:
	lw $a3,4($s3)
	j c3_msort
	

finish:
	la $s1,out_buff
	li $t0,0
save:
	mul $t2,$t0,4
	add $t3,$s1,$t2
	lw $t7,0($a3)
	sw $t7,0($t3)
	lw $a3,4($a3)
	addi $t0,$t0,1
	sub $s2,$t0,$t1
	bgtz $s2,out
	j save
	
out:					#保存在二进制文件中
	la $a0,output_file
	li $a1,1
	li $a2,0
	li $v0,13
	syscall
	
	addi $t2,$t2,4
	move $a0,$v0
	la $a1,out_buff
	move $a2,$t2
	li $v0,15
	syscall
	
	li $v0,16
	syscall	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

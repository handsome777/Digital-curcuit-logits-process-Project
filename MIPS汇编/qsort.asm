##qsort##
.data
	in_buff: .space 512
	output_buff: .space 512
	input_file: .asciiz "E:/a.in"
	out_file: .asciiz"E:/a.out"
	
##########################
.text
	la $a0,input_file   #input_file 是一个字符串
	li $a1,0	    #0 为写入
	li $a2,0	    #只读
	li $v0,13	    #13, 打开文件
	syscall
	
	move $a0,$v0	   #把文件描述符载入到$a0中
	la $a1,in_buff	   #in_buff为数据缓存区
	li $a2,4	   #读取四个字节
	li $v0,14	   #14, 读取文件
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
#################################################
	addi $a0,$zero,8	#申请八比特的空间
	addi $v0,$zero,9	#9，申请空间编号
	syscall			
	move $s0,$v0		#记录头结点指针
	move $t2,$s0		#记录当前节点指针
	move $t0,$zero		#循环变量赋初值为0
	la $a1,in_buff		#把in_buff的地址保存到a1中
	addi $a1,$a1,4		#a1的地址加四
	addi $t1,$t1,-1		#t1保存的是一共有多少个数（从0开始）

new:
	addi $a0,$zero,8	#申请八比特的空间
	addi $v0,$zero,9
	syscall
	mul $t3,$t0,4		#循环变量乘4
	add $a3,$a1,$t3		#把地址调整到要保存的那个数的地址
	lw $t4,0($a3)		#把要保存的数读出来
	sw $t4,0($v0)		#把它保存到结点的前四字里面
	sw $zero,4($v0)		#把结点的后四字保存为0，代表链表尾
	sw $v0,4($t2)		#把新节点加到原有链表上
	move $t2,$v0		#把链表指针移到新加的结点
	addi $t0,$t0,1		#循环变量+1
	ble $t0,$t1,new		#t1里面保存的是数的个数
	lw $t2,4($s0)		#t2重新指向头结点的后继
	
######################################################
#t2指向的是头结点的后继
#t1保存的是一共的元素个数（从0开始）
######################################################
	li,$t5,0		#t5为left
	move $t6,$t1		#t6为right
	addi $sp,$sp,-12	#压栈
	sw $t5,4($sp)		#把left压栈
	sw $t6,0($sp)		#把right压栈
	jal quickSort1		#转到quickSort1函数
	j write			#在quickSort函数结束之后，进行保存文件函数
	
quickSort1:
	sw $ra,8($sp)		#把调用该函数的$ra压栈
quickSort:
	lw $t5,4($sp)		
	lw $t6,0($sp)		
	move $a1,$t5		#a1相当于i，从left开始
	move $a2,$t6		#a1相当于j，从right开
	add $t3,$a1,$a2		
	srl $t3,$t3,1		#t3为mid的标号
	move $v1,$t3
	jal search		#搜寻中间值mid
	lw $s1,0($t7)		#s1保存中间值
	
L1:	
	sub $s2,$a2,$a1		#如果i<=j，则继续
	bltz $s2,continue
L2:	
	move $t3,$a1		#寻找第i个数
	jal search
	lw $s3,0($t7)
	sub $s4,$s1,$s3		#比较它和mid的大小关系
	addi $a1,$a1,1		#i++
	bgtz $s4,L2		#如果第i个数小于mid，则继续循环
	addi $a1,$a1,-1
	
L3:	
	move $t3,$a2		#寻找第j项
	jal search
	lw $s5,0($t7)
	sub $s4,$s1,$s5		#判断与mid的大小关系
	addi $a2,$a2,-1		#如果第j个数大于mid，则继续循环
	bltz $s4,L3
	addi $a2,$a2,1
	
	sub $s4,$a2,$a1		#如果i<=j，则交换两个数，并在链表中更新
	bltz $s4,L1
	
	move $t3,$a1		
	jal search		#search函数是找到第i个元素
	
	lw $s3,0($t7)
	move $t3,$a2
	jal search		#search函数是找到第j个元素
	
	lw $s5,0($t7)		#下面交换两个数
	move $s6,$s3
	move $s3,$s5
	move $s5,$s6
	move $t3,$a1		#把这两个数保存回去
	jal search
	sw $s3,0($t7)
	move $t3,$a2
	jal search
	sw $s5,0($t7)
	addi $a1,$a1,1
	addi $a2,$a2,-1
	lw $t2,4($s0)
	j L1			#进入L1的循环

continue:			#继续递归操作
	sub $s4,$a2,$t5
	bgtz $s4,left		#对左边进行递归
	sub $s4,$t6,$a1
	bgtz $s4,right		#对右边进行递归
	lw $ra,8($sp)
	addi $sp,$sp,12		#在递归完成后，出栈操作
	jr $ra
	
left:
	addi $sp,$sp,-12	#在递归之前，进行压栈	
	sw $ra,8($sp)
	sw $t5,4($sp)
	sw $a2,0($sp)
	j quickSort
	
right:
	addi $sp,$sp,-12	#在递归之前，进行压栈
	sw $ra,8($sp)
	sw $a1,4($sp)
	sw $t6,0($sp)
	j quickSort
	
search:				#搜寻第t3个数
	li $t4,0
	lw $t7,4($s0)
Loop1:	beq $t4,$t3,return		#如果相同就返回
	lw $a0,4($t7)
	beq $a0,$zero,return
	lw $t7,4($t7)		#转到下一个结点
	addi $t4,$t4,1
	j Loop1
	
return:
	jr $ra			#在整个quickSort函数结束之后，返回主函数
	
	
write:
	li $t0,0
	la $s1,output_buff
	move $s0,$t2
save:				#把排序了的保存在out_buff中
	mul $t2,$t0,4
	add $t3,$s1,$t2
	lw $t7,0($s0)
	sw $t7,0($t3)
	lw $s0,4($s0)
	addi $t0,$t0,1
	sub $s2,$t0,$t1
	bgtz $s2,out
	j save
	
out:				#输送到二进制文件中去
	la $a0,out_file
	li $a1,1
	li $a2,0
	li $v0,13
	syscall
	
	addi $t2,$t2,4
	move $a0,$v0
	la $a1,output_buff
	move $a2,$t2
	li $v0,15
	syscall
	
	li $v0,16
	syscall	
	
	
	
	
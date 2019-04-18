##msort##
.data
	in_buff: .space 512
	out_buff: .space 512
	record :.space 1024
	input_file: .asciiz"E:/a.in"
	output_file:.asciiz"E:/a.out"
	
.text 
	la $k1,record
	la $a0,input_file	#input_file��һ���ַ���
	li $a1,0
	li $a2,0
	li $v0,13
	syscall
	
	move $a0,$v0
	la $a1,in_buff
	li $a2,4
	li $v0,14
	syscall
	
	lw $t1,in_buff	   #��ȡ��һ����
	mul $t2,$t1,4	   #�ѵ�һ������4��Ȼ���ʣ�µ���ȫ��������
	addi,$a1,$a1,4	   #��in_buff�ĵ�ַ+4
	move $a2,$t2	   #��Ҫ�����ֽ���������a2��
	li $v0,14	   #14����ȡ�ļ�
	syscall
	
	li $v0,16	   #16���ر��ļ�
	syscall
	
##################################################
#���湹������
##################################################

	addi $a0,$zero,8	#����˱��صĿռ�
	addi $v0,$zero,9	#9������ռ���
	syscall			
	move $s0,$v0		#��¼ͷ���ָ��
	move $t2,$s0		#��¼��ǰ�ڵ�ָ��
	move $t0,$zero		#ѭ������
	
	la $a1,in_buff
	addi $a1,$a1,4
	
	addi $t1,$t1,-1

new:
	addi $a0,$zero,8	#����˱��صĿռ�
	addi $v0,$zero,9
	syscall
	mul $t3,$t0,4		#ѭ��������4
	add $a3,$a1,$t3		
	lw $t4,0($a3)		#���½ڵ���뵽ԭ����������
	sw $t4,0($v0)
	sw $zero,4($v0)
	sw $v0,4($t2)
	move $t2,$v0
	addi $t0,$t0,1
	ble $t0,$t1,new		#t1���汣��������ĸ���
	
	lw $t2,4($s0)		#t2����ָ��ͷ���ĺ��
	
	move $v1,$t2
	
######################################################
#t2ָ�����ͷ���ĺ��
#t1�������һ����Ԫ�ظ�������0��ʼ��
######################################################
#���������൱��������
	jal c1			
	j finish
	
c1:
	addi $sp,$sp,-8		#����ѹջ��������head�͵�ǰ��ra������ջ����
	sw $t2,4($sp)
	sw $ra,0($sp)
	move $t4,$t2
	jal msort
	

#a3��msort���ص�head
msort:				#�鲢������
	lw $t3,4($t4)
	bne $t3,$zero,c_msort	#���Ϊ�գ���ô����
	move $a3,$t4		#���Ϊ�գ���ô���г�ջ����
	lw $ra,0($sp)
	addi $sp,$sp,8
	jr $ra
	
c_msort:
	move $t5,$t4		#$t5=strike_2_pointer
	move $t6,$t4		#$t6=stride_1_pointer
	
loop1:				#���е�
	lw $t3,4($t5)
	beq $t3,$zero,c2_msort
	lw $t5,4($t5)
	lw $t3,4($t5)
	beq $t3,$zero,c2_msort
	lw $t5,4($t5)
	lw $t6,4($t6)
	j loop1

c2_msort:			#��Ϊ�����������Ұ��ұߵ�����ͷѹջ
	lw $t5,4($t6)
	sw $zero,4($t6)
	addi $sp,$sp,-4
	sw $t5,0($sp)
	
#s1��l_head,s2��r_head
	jal l_head
	move $s1,$a3		#�ѷ��صĽ�������ں�������ջ���棬����������������ջ����ջ���Լ����ġ���record��
	addi $k1,$k1,4
	sw $s1,0($k1)
	
	jal r_right
	move $s2,$a3		#�ѷ��صĽ��������һ��ջ����
	addi $k1,$k1,4
	sw $s2,0($k1)
	
	j merge		
	
c3_msort:
	lw $ra,0($sp)		#���أ���ջ	
	addi $sp,$sp,8	
	jr $ra
	
l_head:
	addi $sp,$sp,-8		#������ѹջ����
	sw $t4,4($sp)
	sw $ra,0($sp)
	jal msort
	
r_right:
	lw $t4,0($sp)		#������ѹջ����
	addi $sp,$sp,4
	addi $sp,$sp,-8
	sw $t4,4($sp)
	sw $ra,0($sp)
	jal msort


#s1��l_head,s2��r_head,s3��head
#s4��p_left,s5��p_right
merge:
	lw $s1,-4($k1)
	lw $s2,0($k1)
	addi $k1,$k1,-8
	
	addi $a0,$zero,8	#����˱��صĿռ�
	addi $v0,$zero,9
	syscall
	move $s3,$v0
	sw $s1,4($s3)
	move $s4,$s3
	move $s5,$s2
	
loop2:
	loop3:				#Ѱ�������еĲ���λ��
		lw $t7,4($s4)
		beq $t7,$zero,c_loop2
		lw $t9,0($t7)
		lw $v1,0($s5)
		sub $v0,$t9,$v1
		bgtz $v0,c_loop2
		lw $s4,4($s4)
		j loop3
	c_loop2:			#����ﵽ����β��������ֱ�ӽ���
		lw $t7,4($s4)
		bne $t7,$zero,c_merge
		sw $s5,4($s4)
		j c3_merge

#s6��p_right_temp
c_merge:
	move $s6,$s5
loop4:					#Ѱ������������Ƭ��
	lw $t7,4($s6)
	beq $t7,$zero,c2_merge
	lw $t9,0($t7)
	lw $t8,4($s4)
	lw $v1,0($t8)
	sub $v0,$t9,$v1
	bgtz $v0,c2_merge
	lw $s6,4($s6)
	j loop4
	
#s7��temp_right_pointer_next
c2_merge:				#��ɲ������
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
	
out:					#�����ڶ������ļ���
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

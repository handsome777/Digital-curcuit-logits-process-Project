##ð������##
.data
	input_buff:.space 512

.text
	la $t5,input_buff		#�������Լ�����һ������û�о����ļ���д����
	li $t6,2			#�������Ϊ2 7 0 9
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
	addi $sp,$sp,-20		#����ԭ����ֵ�������֮��ָ�֮ǰ��ֵ
	sw $ra,16($sp)
	sw $s3,12($sp)
	sw $s2,8($sp)
	sw $s1,4($sp)
	sw $s0,0($sp)
	
	move $s0,$zero			#��ѭ��������ֵ��s0Ϊi
loopbody1:
	bge $s0,$a1,exit1		#���s0>a1������ת��ѭ��
	
	addi $s1,$s0,-1			#s0Ϊj,���ڴ�ѭ����ʼ֮ǰ������ֵi-1
loopbody2:
	blt $s1,$zero,exit2		#���j<0����ת
	sll $t1,$s1,2
	add $t2,$a0,$t1
	lw $t3,0($t2)			#��ȡ����Ԫ��ֵ
	lw $t4,4($t2)
	ble $t3,$t4,exit2		#���бȽ�
	
	move $s2,$a0
	move $s3,$a1
	move $a0,$s2
	move $a1,$s1 
	jal swap			#���ý�������
	
	addi $s1,$s1,-1
	j loopbody2
exit2:	
	addi $s0,$s0,1
	j loopbody1
exit1:
	lw $ra,16($sp)			#�ָ��ں�������֮ǰ����Щֵ
	lw $s3,12($sp)
	lw $s2,8($sp)
	lw $s1,4($sp)
	lw $s0,0($sp)
	addi $sp,$sp,20
	jr $ra				#���ص�������

swap:					#��������
	sll $t1,$a1,2
	add $t1,$a0,$t1
	lw $t0,0($t1)
	lw $t2,4($t1)
	sw $t2,0($t1)
	sw $t0,4($t1)
	jr $ra
	
finish:					#���н�����
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
	
	

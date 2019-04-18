##qsort##
.data
	in_buff: .space 512
	output_buff: .space 512
	input_file: .asciiz "E:/a.in"
	out_file: .asciiz"E:/a.out"
	
##########################
.text
	la $a0,input_file   #input_file ��һ���ַ���
	li $a1,0	    #0 Ϊд��
	li $a2,0	    #ֻ��
	li $v0,13	    #13, ���ļ�
	syscall
	
	move $a0,$v0	   #���ļ����������뵽$a0��
	la $a1,in_buff	   #in_buffΪ���ݻ�����
	li $a2,4	   #��ȡ�ĸ��ֽ�
	li $v0,14	   #14, ��ȡ�ļ�
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
#################################################
	addi $a0,$zero,8	#����˱��صĿռ�
	addi $v0,$zero,9	#9������ռ���
	syscall			
	move $s0,$v0		#��¼ͷ���ָ��
	move $t2,$s0		#��¼��ǰ�ڵ�ָ��
	move $t0,$zero		#ѭ����������ֵΪ0
	la $a1,in_buff		#��in_buff�ĵ�ַ���浽a1��
	addi $a1,$a1,4		#a1�ĵ�ַ����
	addi $t1,$t1,-1		#t1�������һ���ж��ٸ�������0��ʼ��

new:
	addi $a0,$zero,8	#����˱��صĿռ�
	addi $v0,$zero,9
	syscall
	mul $t3,$t0,4		#ѭ��������4
	add $a3,$a1,$t3		#�ѵ�ַ������Ҫ������Ǹ����ĵ�ַ
	lw $t4,0($a3)		#��Ҫ�������������
	sw $t4,0($v0)		#�������浽����ǰ��������
	sw $zero,4($v0)		#�ѽ��ĺ����ֱ���Ϊ0����������β
	sw $v0,4($t2)		#���½ڵ�ӵ�ԭ��������
	move $t2,$v0		#������ָ���Ƶ��¼ӵĽ��
	addi $t0,$t0,1		#ѭ������+1
	ble $t0,$t1,new		#t1���汣��������ĸ���
	lw $t2,4($s0)		#t2����ָ��ͷ���ĺ��
	
######################################################
#t2ָ�����ͷ���ĺ��
#t1�������һ����Ԫ�ظ�������0��ʼ��
######################################################
	li,$t5,0		#t5Ϊleft
	move $t6,$t1		#t6Ϊright
	addi $sp,$sp,-12	#ѹջ
	sw $t5,4($sp)		#��leftѹջ
	sw $t6,0($sp)		#��rightѹջ
	jal quickSort1		#ת��quickSort1����
	j write			#��quickSort��������֮�󣬽��б����ļ�����
	
quickSort1:
	sw $ra,8($sp)		#�ѵ��øú�����$raѹջ
quickSort:
	lw $t5,4($sp)		
	lw $t6,0($sp)		
	move $a1,$t5		#a1�൱��i����left��ʼ
	move $a2,$t6		#a1�൱��j����right��
	add $t3,$a1,$a2		
	srl $t3,$t3,1		#t3Ϊmid�ı��
	move $v1,$t3
	jal search		#��Ѱ�м�ֵmid
	lw $s1,0($t7)		#s1�����м�ֵ
	
L1:	
	sub $s2,$a2,$a1		#���i<=j�������
	bltz $s2,continue
L2:	
	move $t3,$a1		#Ѱ�ҵ�i����
	jal search
	lw $s3,0($t7)
	sub $s4,$s1,$s3		#�Ƚ�����mid�Ĵ�С��ϵ
	addi $a1,$a1,1		#i++
	bgtz $s4,L2		#�����i����С��mid�������ѭ��
	addi $a1,$a1,-1
	
L3:	
	move $t3,$a2		#Ѱ�ҵ�j��
	jal search
	lw $s5,0($t7)
	sub $s4,$s1,$s5		#�ж���mid�Ĵ�С��ϵ
	addi $a2,$a2,-1		#�����j��������mid�������ѭ��
	bltz $s4,L3
	addi $a2,$a2,1
	
	sub $s4,$a2,$a1		#���i<=j���򽻻������������������и���
	bltz $s4,L1
	
	move $t3,$a1		
	jal search		#search�������ҵ���i��Ԫ��
	
	lw $s3,0($t7)
	move $t3,$a2
	jal search		#search�������ҵ���j��Ԫ��
	
	lw $s5,0($t7)		#���潻��������
	move $s6,$s3
	move $s3,$s5
	move $s5,$s6
	move $t3,$a1		#���������������ȥ
	jal search
	sw $s3,0($t7)
	move $t3,$a2
	jal search
	sw $s5,0($t7)
	addi $a1,$a1,1
	addi $a2,$a2,-1
	lw $t2,4($s0)
	j L1			#����L1��ѭ��

continue:			#�����ݹ����
	sub $s4,$a2,$t5
	bgtz $s4,left		#����߽��еݹ�
	sub $s4,$t6,$a1
	bgtz $s4,right		#���ұ߽��еݹ�
	lw $ra,8($sp)
	addi $sp,$sp,12		#�ڵݹ���ɺ󣬳�ջ����
	jr $ra
	
left:
	addi $sp,$sp,-12	#�ڵݹ�֮ǰ������ѹջ	
	sw $ra,8($sp)
	sw $t5,4($sp)
	sw $a2,0($sp)
	j quickSort
	
right:
	addi $sp,$sp,-12	#�ڵݹ�֮ǰ������ѹջ
	sw $ra,8($sp)
	sw $a1,4($sp)
	sw $t6,0($sp)
	j quickSort
	
search:				#��Ѱ��t3����
	li $t4,0
	lw $t7,4($s0)
Loop1:	beq $t4,$t3,return		#�����ͬ�ͷ���
	lw $a0,4($t7)
	beq $a0,$zero,return
	lw $t7,4($t7)		#ת����һ�����
	addi $t4,$t4,1
	j Loop1
	
return:
	jr $ra			#������quickSort��������֮�󣬷���������
	
	
write:
	li $t0,0
	la $s1,output_buff
	move $s0,$t2
save:				#�������˵ı�����out_buff��
	mul $t2,$t0,4
	add $t3,$s1,$t2
	lw $t7,0($s0)
	sw $t7,0($t3)
	lw $s0,4($s0)
	addi $t0,$t0,1
	sub $s2,$t0,$t1
	bgtz $s2,out
	j save
	
out:				#���͵��������ļ���ȥ
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
	
	
	
	
#IEEE 754��׼�еķǹ����,�����NaN(����)�����(�쳣)����,��˶��ڷ�0�ĸ�����,��ָ����ΧΪ1-254
#��ӡ������ʱ,����ӡβ��ĩ�˵�ȫ0����
.data
	#�˵�:��ѡ������Ҫ���еĲ����������Ӧ�Ĳ�����:	1.����������(Floating Calculation)	2.�˳�(Exit)
	msg_menu:.ascii "Please input the number of your next need:\n1.Floating Calculation\n2.Exit\n>>>\0"
	#�˳�
	msg_exit:.ascii "Exited\n\0"
	#�������������
	msg_complete:.ascii "--------------------------------------------------Mission Completed\n\0"
	#����Ĳ��������Ϸ�,��������������Ҫ�Ĳ���
	msg_invalid_input:.ascii "Invalid Input! Please re-enter your need\n\0"
	#����Ĳ��������Ϸ�
	msg_invalid_operation:.ascii "Invalid operation!\n\0"
	#�������һ��������
	msg_operand1:.ascii "Please input the first floating operand:\n>>>\0"
	#������ڶ���������
	msg_operand2:.ascii "Please input the second floating operand:\n>>>\0"
	#�������������Ӧ�Ĳ�����:	1.+	2.-	3.*	4./
	msg_operation:.ascii "Please input the operation:\n1.+	2.-	3.*	4./\n>>>\0"
	#��ӡ����������
	msg_result:.ascii "The calculation result is as follows:\n\0"
	#����
	msg_overflow:.ascii "Error: Overflow!\n\0"
	#����
	msg_underflow:.ascii "Error: Underflow!\n\0"
	#������Ϊ0
	msg_dividend0:.ascii "Error: The dividend could not be zero!\n\0"
	#���������
	msg_binary:.ascii "Result in binary: \0"
	#ʮ���������
	msg_hex:.ascii "Result in hex: \0"
	#ʮ������ǰ׺
	msg_hex_h:.ascii "0x\0"
	#�س�
	msg_return:.ascii "\n\0"
	#����
	msg_negative:.ascii "-\0"
	#С����
	msg_point:.ascii ".\0"
	#"1."
	msg_one_point:.ascii "1.\0"
	#"*2^"
	msg_binary_exp:.ascii "*2^\0"
	#"*16^"
	msg_hex_exp:.ascii "*16^\0"
	#ʮ�����Ʊ�
	hex_table:.ascii "0123456789ABCDEF\0"
.text
#����˵�������1��ʼ��������㣬����2��������
Menu:
	#��ӡ�˵���
	li $v0,4
	la $a0,msg_menu
	syscall
	#�����û�����:	1.����������	2.�˳�
	li $v0,5
	syscall
	#������Ϊ2���˳�
	beq $v0,2,Exit
	#�����������Ϊ1��2���ӡ������Ϣ
	bne $v0,1,Invalid_input
	#��������������
	jal Input_operands
	#���������
	j Input_operation

#��������������
Input_operands:
	#���淵��ֵ��ַ
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_operand1
	syscall
	#�����һ��������
	li $v0,6
	syscall
	#������һ������������ʱ�Ĵ���
	mfc1 $t0,$f0
	#��¼��һ���������ķ���(��31λ)
	srl $s0,$t0,31
	#��¼��һ����������ָ��(��23λ-30λ)
	sll $s1,$t0,1
	srl $s1,$s1,24
	#��¼��һ����������β��(��0λ-22λ)
	sll $s2,$t0,9
	srl $s2,$s2,9
	#�ָ�����λ(��23λ)
	addi $s2,$s2,0x00800000

	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_operand2
	syscall
	#����ڶ���������
	li $v0,6
	syscall
	#�����ڶ�������������ʱ�Ĵ���
	mfc1 $t0,$f0
	#��¼�ڶ����������ķ���(��31λ)
	srl $s3,$t0,31
	#��¼�ڶ�����������ָ��(��23λ-30λ)
	sll $s4,$t0,1
	srl $s4,$s4,24
	#��¼�ڶ�����������β��(��0λ-22λ)
	sll $s5,$t0,9
	srl $s5,$s5,9
	#�ָ�����λ(��23λ)
	addi $s5,$s5,0x00800000
	#ȡ�ط���ֵ��ַ
	lw $ra,0($sp)
	addi $sp,$sp,4
	#���ص��ô�
	jr $ra

#���������
Input_operation:
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_operation
	syscall
	#�����������Ӧ���:	1.+	2.-	3.*	4./
	li $v0,5
	syscall
	#����Ϊ1����ת���ӷ�,�������ķ�����,ָ����β���ֱ����$t0,$t1,$t2��
	beq $v0,1,Add
	#����Ϊ2����ת������,�������Ĵ��淽ʽͬ��
	beq $v0,2,Sub
	#����Ϊ3����ת���˷�,�������Ĵ��淽ʽͬ��
	beq $v0,3,Mul
	#����Ϊ4����ת������,�������Ĵ��淽ʽͬ��
	beq $v0,4,Div
	#������������벻�Ϸ�,��ӡ������Ϣ	
	li $v0,4
	la $a0,msg_invalid_operation
	syscall
	#���¶��������
	j Input_operation
	
#ִ�мӷ�����	
Add:
	#�Ƚ���������ָ��,���ƥ������ת��β�����
	beq $s1,$s4,Add_mantissa
	#�Ƚ�������������ָ��
	slt $t0,$s1,$s4
	#�����һ����������ָ�����ڵڶ���������,��Եڶ�����������������
	beq $t0,$zero,Add_srl_so
	#����Ե�һ����������������
	j Add_srl_fo
	
#�Ե�һ������������һ������
Add_srl_fo:
	#��һ����������β������1λ
	srl $s2,$s2,1
	#��һ����������ָ������1
	addi $s1,$s1,1
	#�����һ����������ָ��Ϊ255,����Ϊ����������
	beq $s1,255,Overflow
	#�Ƚ���������ָ��,���ƥ������ת��β�����
	beq $s1,$s4,Add_mantissa
	#��������Ե�һ����������������
	j Add_srl_fo

#�Եڶ�������������һ������
Add_srl_so:
	#�ڶ�����������β������1λ
	srl $s5,$s5,1
	#�ڶ�����������ָ������1
	addi $s4,$s4,1
	#����ڶ�����������ָ��Ϊ255,����Ϊ����������
	beq $s1,255,Overflow
	#�Ƚ���������ָ��,���ƥ������ת��β�����
	beq $s1,$s4,Add_mantissa
	#��������Եڶ�����������������
	j Add_srl_so	
	
#β�����
Add_mantissa:
	#�Ƚ������������ķ���
	xor $t0,$s0,$s3
	#���������ͬ,����ת����ͬ���żӷ�
	beq $t0,$zero,Add_same_sign
	#����ִ����żӷ�
	j Add_differ_sign

#��żӷ�
Add_differ_sign:
	#��¼�����ָ��
	add $t1,$s1,$zero
	#β�����
	sub $t2,$s2,$s5
	#������Ϊ0,���ӡ���0
	beq $t2,$zero,Print_result0
	#�������������
	slt $t3,$t2,$zero
	#������Ϊ��,���һ��β���ľ���ֵС�ڵڶ���β��
	beq $t3,$zero,Add_foml
	#�����һ��β���ľ���ֵ���ڵڶ���β��
	j Add_soml

#��һ��β���ľ���ֵ���ڵڶ���β��(first operand mantissa larger)
Add_foml:
	#����ķ��ź͵�һ��������һ��
	add $t0,$s0,$zero
	#���β���Ƿ���
	j Add_normalize

#��һ��β���ľ���ֵС�ڵڶ���β��(second operand mantissa larger)
Add_soml:
	#����ķ��ź͵ڶ���������һ��
	add $t0,$s3,$zero
	#���¼���β��,��֤��Ϊ����
	sub $t2,$s5,$s2
	#���β���Ƿ���
	j Add_normalize

#���β�������й��
Add_normalize:
	#������С�������ָ���Ĵ���
	li $t3,0x00080000
	#�ȽϽ����β��������������Ĵ�С
	slt $t4,$t2,$t3
	#��������β�����ڵ������������,��ת�������ӡ,�����β�����й��
	beq $t4,$zero,Print_binary
	#��β������һ������
	sll $t2,$t2,1
	#ָ������1
	addi $t1,$t1,-1
	#�������
	beq $t1,$zero,Underflow
	#�ٴμ��β���Ƿ���
	j Add_normalize

#ͬ�żӷ�
Add_same_sign:		
	#��¼����ķ���
	add $t0,$s0,$zero
	#��¼�����ָ��
	add $t1,$s1,$zero
	#β�����
	add $t2,$s2,$s5
	#ȡ����ĵ�24λ
	srl $t3,$t2,24
	#�����24λΪ0,�����ǹ��������ת�������ӡ
	beq $t3,$zero,Print_binary
	#����Խ�����й��,β������1λ
	srl $t2,$t2,1
	#�����ָ������1
	addi $t1,$t1,1
	#�����񻯺��ָ��Ϊ255,����Ϊ����������
	beq $t1,255,Overflow
	#�����ӡ���
	j Print_binary

#ִ�м�������
Sub:
	#�Եڶ����������ķ���λȡ��
	xori $s3,$s3,1
	#ִ�е�Ч�ӷ�
	j Add
	
#ִ�г˷�����
Mul:
	#����һ����������ָ���Ƿ�Ϊ0
	beqz $s1,Mul_feez
	#���ڶ�����������ָ���Ƿ�Ϊ0
	beqz $s4,Mul_seez
	#��������������Ϊ0,��ִ�г���˷�
	j Mul_simply

#��һ����������ָ��Ϊ0(first exponent equal to zero)
Mul_feez:
	#��һ����������ָ��Ϊ0ʱ,���β��ֻ������λ1,��ֱ�Ӵ�ӡ���0
	beq $s2,0x00800000,Print_result0
	#������ڶ�����������ָ���Ƿ�Ϊ0
	beqz $s4,Mul_seez
	#��������������Ϊ0,��ִ�г���˷�
	j Mul_simply

#�ڶ�����������ָ��Ϊ0(second exponent equal to zero)
Mul_seez:
	#�ڶ�����������ָ��Ϊ0ʱ,���β��ֻ������λ1,��ֱ�Ӵ�ӡ���0
	beq $s5,0x00800000,Print_result0
	#������������������0,ִ�г���˷�
	j Mul_simply

#����˷�
Mul_simply:
	#����ƫ��ָ�����
	add $t1,$s1,$s4
	#��ȥƫ��ֵ�õ��µ�ƫ��ָ��
	addi $t1,$t1,-127
	#β�����,Hi�ĵ�16λ�д洢��β����˽����2λ����λ��14λС��λ,Lo�д洢��32λС��λ
	mult $s2,$s5
	#ȡ���˷�����ĸ�32λ
	mfhi $t2
	#ȡ���˷�����ĵ�32λ
	mflo $t3
	#��Hi�е�2λ����λ��14λС��λ����9λ
	sll $t2,$t2,9
	#����Lo�еĸ�9λ,������23λ
	srl $t3,$t3,23
	#ƴ��Ϊ�µ�β��(2λ����λ+23λС��λ)
	or $t2,$t2,$t3
	#��¼β���ĵ�25λ
	andi $t3,$t2,0x01000000
	#�����25λΪ0���������
	beqz $t3,Mul_skip
	#���ҹ��
	srl $t2,$t2,1
	#ָ������1
	addi $t1,$t1,1
#�������
Mul_skip:
	#�������
	bgt $t1,254,Overflow
	#�������
	blt $t1,1,Underflow
	#ͬ��Ϊ��,���Ϊ��
	xor $t0,$s0,$s3
	#��ӡ�����Ƽ�����
	j Print_binary

#ִ�г�������	
Div:
	#��������ָ���Ƿ�Ϊ0
	bnez $s4,Div_iszero
	#��������β���Ƿ�ֻ������λ��0
	bne $s5,0x00800000,Div_iszero 
	#���߶�Ϊ0,�����Ϊ0,��ӡ������Ϣ
	j Dividend0
	
#��鱻�����Ƿ�Ϊ0
Div_iszero:
	#��鱻������ָ���Ƿ�Ϊ0
	bnez $s1,Div_simply
	#��鱻������β���Ƿ�ֻ������λ��0
	bne $s2,0x00800000,Div_simply
	#���߶�Ϊ0,�򱻳���Ϊ0,��ӡ���0
	j Print_result0

#�������
Div_simply:
	#����ƫ��ָ�����
	sub $t1,$s1,$s4
	#����ƫ��ֵ�õ��µ�ƫ��ָ��
	addi $t1,$t1,127
	#β�����
	div $s2,$s5
	#ȡ����
	mflo $t2
	#ȡ������
	mfhi $t3
	#������ֻ����Ϊ0��1,����β���ĵ�0λ���ǵ�23λ,��˶�ָ��������Ӧ����
	addi $t1,$t1,23
#ѭ������β��
Div_mantissa_loop:
	#��������1λ
	sll $t3,$t3,1
	#ָ������1
	addi $t1,$t1,-1
	#������1λ
	sll $t2,$t2,1
	#����µ������ͳ����Ĵ�С��ϵ
	sge $t4,$t3,$s5
	#�����µ��̵����λ
	add $t2,$t2,$t4
	#����µ�����С�ڳ���,�����������ȥ����
	beqz $t4,Div_skip
	#��������������������ȥ����
	sub $t3,$t3,$s5
#���������ȥ����
Div_skip:
	#����̵ĵ�24λ
	andi $t4,$t2,0x00800000
	#���Ϊ0,���������β��
	beqz $t4,Div_mantissa_loop
	#����β���������,�������
	bgt $t1,254,Overflow
	#�������
	blt $t1,1,Underflow
	#ͬ��Ϊ��,���Ϊ��
	xor $t0,$s0,$s3
	#��ӡ�����Ƽ�����
	j Print_binary

#��ӡ�����Ƽ�����
Print_binary:
	#��ӡ��ʾ��Ϣ:������
	li $v0,4
	la $a0,msg_result
	syscall
	#��ӡ��ʾ��Ϣ
	jal Print_binary_note
	#����������򲻴�ӡ����
	beq $t0,$zero,Print_binary_skip
	#��ӡ����
	li $v0,4
	la $a0,msg_negative
	syscall
	
#�����ƴ�ӡʱ��������λ
Print_binary_skip:
	#��ӡ"1."
	li $v0,4
	la $a0,msg_one_point
	syscall
	#��β��������λ��0����Ϊ����
	sll $a1,$t2,9
	#��ӡС�����Ķ�����β��
	jal Print_binary_mantissa
	#��ӡ"*2^"
	li $v0,4
	la $a0,msg_binary_exp
	syscall
	#��ӡָ��
	li $v0,1
	#������ת��Ϊԭ��
	addi $a0,$t1,-127
	syscall
	#��ӡ�س�
	jal Print_return
	#��ת����ӡʮ�����Ƽ�����
	j Print_hex

#��ӡʮ�����Ƽ�����
Print_hex:
	#��ӡ��ʾ��Ϣ
	jal Print_hex_note	
	#����������򲻴�ӡ����
	beq $t0,$zero,Print_hex_skip
	#��ӡ����
	li $v0,4
	la $a0,msg_negative
	syscall
	
#ʮ�����ƴ�ӡʱ��������λ
Print_hex_skip:
	#��ӡʮ������ǰ׺
	li $v0,4
	la $a0,msg_hex_h
	syscall
	#����ָ����ֵ
	addi $t3,$t1,-127
	#����ָ����ֵ�������Էֱ���
	bltz $t3,Print_negative_exp
	#����ָ������
	move $s6,$zero
	#ָ����ֵΪ��ʱ,����ָ����4ȡģ�Ľ��
	andi $t4,$t3,3
	#�����������Ի��ʮ��������С����ǰ����
	li $t5,23
	sub $t5,$t5,$t4
	#����ʮ��������С����ǰ����
	srlv $a1,$t2,$t5
	#�����������Ի��ʮ��������С��������
	addi $t5,$t4,9
	#����ʮ��������С��������
	sllv $a2,$t2,$t5
	#��ָ��תΪʮ������
	srl $t3,$t3,2	
	#��ӡ������ʮ��������
	j Print_hex_continue
	
#ʮ������ָ��Ϊ����
Print_negative_exp:	
	#����ָ�����෴��
	li $t3,127
	sub $t3,$t3,$t1
	#����������
	li $t5,0
#ͨ��ѭ��������ָ�����෴��ת��Ϊ������ĵ�һ��4�ı���
Print_negative_loop:	
	#����ָ���෴����4ȡģ�Ľ��
	andi $t4,$t3,3
	#������Ϊ0������ѭ��������ӡ
	beqz $t4,Print_negative_hex_exp
	#ʮ������β������������1
	addi $t5,$t5,1
	#ָ���෴������1
	addi $t3,$t3,1
	#ѭ������
	j Print_negative_loop
	
#��ָ�����෴��תΪʮ�����Ʋ�������ӡ
Print_negative_hex_exp:
	#�����������Ի��ʮ��������С����ǰ����
	li $t6,23
	sub $t6,$t6,$t5
	#����ʮ��������С����ǰ����
	srlv $a1,$t2,$t6
	#�����������Ի��ʮ��������С��������
	addi $t6,$t5,9
	#����ʮ��������С��������
	sllv $a2,$t2,$t6
	#��ָ��תΪʮ������
	srl $t3,$t3,2
	#����ָ������
	li $s6,1
	#��ӡ������ʮ��������
	j Print_hex_continue
	
#����ʮ�����ƴ�ӡ
Print_hex_continue:	
	#��ӡʮ������β��
	jal Print_hex_mantissa
	#��ӡ"*16^"
	li $v0,4
	la $a0,msg_hex_exp
	syscall
	#���ָ��Ϊ��
	beqz $s6,Print_hexp_exp_skip
	#���ӡ����
	li $v0,4
	la $a0,msg_negative
	syscall
#����ָ�����Ŵ�ӡ
Print_hexp_exp_skip:
	#��ӡָ��
	li $v0,1
	move $a0,$t3
	syscall
	#��ӡ�س�
	jal Print_return
	#��ӡ�������������Ϣ
	li $v0,4
	la $a0,msg_complete
	syscall
	#��ӡ����,���ز˵�ҳ��
	j Menu

#��ӡʮ������β��(a1Ϊβ��С����ǰ����,a2Ϊβ��С��������)
Print_hex_mantissa:
	#���淵��ֵ��ַ
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#��ӡС����ǰ��β��
	li $v0,11
	lb $a0,hex_table($a1)
	syscall
	#��ӡС����
	li $v0,4
	la $a0,msg_point
	syscall
#ѭ����ӡС������β��
Print_hex_mantissa_loop:
	#����С�����β�������4λ
	srl $t4,$a2,28
	#��ӡ��Ӧ��ʮ��������
	li $v0,11
	lb $a0,hex_table($t4)
	syscall
	#ͨ�������������4λ
	sll $a2,$a2,4
	#����µ�β��Ϊ0�������ӡ
	beqz $a2,Print_hex_mantissa_back
	#���������ӡ�µ�β��
	j Print_hex_mantissa_loop			
#ʮ������β����ӡ����
Print_hex_mantissa_back:
	#ȡ�ط���ֵ��ַ
	lw $ra,0($sp)
	addi $sp,$sp,4
	#���غ������ô�
	jr $ra

#��ӡ������β��(����a1ΪС������β��)
Print_binary_mantissa:
	#���淵��ֵ��ַ
	addi $sp,$sp,-4
	sw $ra,0($sp)
#ѭ����ӡС������β��
Print_binary_mantissa_loop:
	#����β�������λ
	srl $t3,$a1,31
	li $v0,1
	#��ӡ���λ
	move $a0,$t3
	syscall
	#ͨ���߼������������λ
	sll $a1,$a1,1
	#����µ�β��Ϊ0,�������ӡ
	beq $a1,$zero,Print_binary_back
	#����µ�β����Ϊ0,�������ӡ��һλ
	j Print_binary_mantissa_loop
Print_binary_back:
	#ȡ�ط���ֵ��ַ
	lw $ra,0($sp)
	addi $sp,$sp,4
	#���غ������ô�
	jr $ra
	
#��ӡ���0
Print_result0:
	#��ӡ��ʾ��Ϣ:������
	li $v0,4
	la $a0,msg_result
	syscall
	#��ӡ��ʾ��Ϣ:���������
	jal Print_binary_note
	#��ӡ����
	li $v0,1
	#���ò���Ϊ0
	add $a0,$zero,$zero
	syscall
	#��ӡ�س���
	jal Print_return
	#��ӡ��ʾ��Ϣ:ʮ���������
	jal Print_hex_note
	#��ӡʮ������ǰ׺
	li $v0,4
	la $a0,msg_hex_h
	syscall
	#��ӡ����
	li $v0,1
	#���ò���Ϊ0
	move $a0,$zero
	syscall
	#��ӡ�س���
	jal Print_return
	#��ӡ�������������Ϣ
	li $v0,4
	la $a0,msg_complete
	syscall
	#���ز˵�ҳ��
	j Menu

#��ӡ�����������ʾ
Print_binary_note:
	#���淵��ֵ��ַ
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_binary
	syscall
	#ȡ�ط���ֵ��ַ
	lw $ra,0($sp)
	addi $sp,$sp,4
	#���ص��ô�
	jr $ra

#��ӡʮ�����������ʾ
Print_hex_note:
	#���淵��ֵ��ַ
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_hex
	syscall
	#ȡ�ط���ֵ��ַ
	lw $ra,0($sp)
	addi $sp,$sp,4
	#���ص��ô�
	jr $ra

#��ӡ�س�
Print_return:
	#���淵��ֵ��ַ
	addi $sp,$sp,-4	
	sw $ra,0($sp)
	#��ӡ�س���
	li $v0,4
	la $a0,msg_return
	syscall
	#ȡ�ط���ֵ��ַ
	lw $ra,0($sp)
	addi $sp,$sp,4	
	#���ص��ô�
	jr $ra

#����Ϊ0
Dividend0:
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_dividend0
	syscall
	#���ز˵�ҳ��
	j Menu

#����
Overflow:
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_overflow
	syscall
	#���ز˵�ҳ��
	j Menu

#����
Underflow:
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_underflow
	syscall
	#���ز˵�ҳ��
	j Menu

#���벻�Ϸ�	
Invalid_input:
	#��ӡ��ʾ��Ϣ
	li $v0,4
	la $a0,msg_invalid_input
	syscall
	#���ز˵�ҳ��
	j Menu	

#��������
Exit:
	#��ӡ��ʾ��Ϣ
	li $v0 4
	la $a0,msg_exit
	syscall
	#ִ��ϵͳ�˳�
	li $v0,10
	syscall

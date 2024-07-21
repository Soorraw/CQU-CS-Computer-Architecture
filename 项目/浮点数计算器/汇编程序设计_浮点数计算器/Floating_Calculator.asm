#IEEE 754标准中的非规格化数,无穷和NaN(非数)作溢出(异常)处理,因此对于非0的浮点数,其指数范围为1-254
#打印计算结果时,不打印尾数末端的全0部分
.data
	#菜单:请选择您需要进行的操作，输入对应的操作数:	1.浮点数运算(Floating Calculation)	2.退出(Exit)
	msg_menu:.ascii "Please input the number of your next need:\n1.Floating Calculation\n2.Exit\n>>>\0"
	#退出
	msg_exit:.ascii "Exited\n\0"
	#浮点数运算完成
	msg_complete:.ascii "--------------------------------------------------Mission Completed\n\0"
	#输入的操作数不合法,请重新输入您需要的操作
	msg_invalid_input:.ascii "Invalid Input! Please re-enter your need\n\0"
	#输入的操作符不合法
	msg_invalid_operation:.ascii "Invalid operation!\n\0"
	#请输入第一个浮点数
	msg_operand1:.ascii "Please input the first floating operand:\n>>>\0"
	#请输入第二个浮点数
	msg_operand2:.ascii "Please input the second floating operand:\n>>>\0"
	#请输入操作符对应的操作数:	1.+	2.-	3.*	4./
	msg_operation:.ascii "Please input the operation:\n1.+	2.-	3.*	4./\n>>>\0"
	#打印浮点运算结果
	msg_result:.ascii "The calculation result is as follows:\n\0"
	#上溢
	msg_overflow:.ascii "Error: Overflow!\n\0"
	#下溢
	msg_underflow:.ascii "Error: Underflow!\n\0"
	#被除数为0
	msg_dividend0:.ascii "Error: The dividend could not be zero!\n\0"
	#二进制输出
	msg_binary:.ascii "Result in binary: \0"
	#十六进制输出
	msg_hex:.ascii "Result in hex: \0"
	#十六进制前缀
	msg_hex_h:.ascii "0x\0"
	#回车
	msg_return:.ascii "\n\0"
	#负号
	msg_negative:.ascii "-\0"
	#小数点
	msg_point:.ascii ".\0"
	#"1."
	msg_one_point:.ascii "1.\0"
	#"*2^"
	msg_binary_exp:.ascii "*2^\0"
	#"*16^"
	msg_hex_exp:.ascii "*16^\0"
	#十六进制表
	hex_table:.ascii "0123456789ABCDEF\0"
.text
#载入菜单，输入1开始或继续计算，输入2结束计算
Menu:
	#打印菜单栏
	li $v0,4
	la $a0,msg_menu
	syscall
	#读入用户需求:	1.浮点数运算	2.退出
	li $v0,5
	syscall
	#操作数为2则退出
	beq $v0,2,Exit
	#如果操作数不为1或2则打印错误信息
	bne $v0,1,Invalid_input
	#读入两个浮点数
	jal Input_operands
	#读入运算符
	j Input_operation

#读入两个操作数
Input_operands:
	#储存返回值地址
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#打印提示信息
	li $v0,4
	la $a0,msg_operand1
	syscall
	#读入第一个浮点数
	li $v0,6
	syscall
	#读出第一个浮点数到临时寄存器
	mfc1 $t0,$f0
	#记录第一个浮点数的符号(第31位)
	srl $s0,$t0,31
	#记录第一个浮点数的指数(第23位-30位)
	sll $s1,$t0,1
	srl $s1,$s1,24
	#记录第一个浮点数的尾数(第0位-22位)
	sll $s2,$t0,9
	srl $s2,$s2,9
	#恢复隐藏位(第23位)
	addi $s2,$s2,0x00800000

	#打印提示信息
	li $v0,4
	la $a0,msg_operand2
	syscall
	#读入第二个浮点数
	li $v0,6
	syscall
	#读出第二个浮点数到临时寄存器
	mfc1 $t0,$f0
	#记录第二个浮点数的符号(第31位)
	srl $s3,$t0,31
	#记录第二个浮点数的指数(第23位-30位)
	sll $s4,$t0,1
	srl $s4,$s4,24
	#记录第二个浮点数的尾数(第0位-22位)
	sll $s5,$t0,9
	srl $s5,$s5,9
	#恢复隐藏位(第23位)
	addi $s5,$s5,0x00800000
	#取回返回值地址
	lw $ra,0($sp)
	addi $sp,$sp,4
	#返回调用处
	jr $ra

#读入操作符
Input_operation:
	#打印提示信息
	li $v0,4
	la $a0,msg_operation
	syscall
	#输入操作符对应编号:	1.+	2.-	3.*	4./
	li $v0,5
	syscall
	#输入为1则跳转至加法,计算结果的符号数,指数和尾数分别存在$t0,$t1,$t2中
	beq $v0,1,Add
	#输入为2则跳转至减法,计算结果的储存方式同上
	beq $v0,2,Sub
	#输入为3则跳转至乘法,计算结果的储存方式同上
	beq $v0,3,Mul
	#输入为4则跳转至除法,计算结果的储存方式同上
	beq $v0,4,Div
	#否则操作符输入不合法,打印错误信息	
	li $v0,4
	la $a0,msg_invalid_operation
	syscall
	#重新读入操作符
	j Input_operation
	
#执行加法操作	
Add:
	#比较两个数的指数,如果匹配则跳转至尾数相加
	beq $s1,$s4,Add_mantissa
	#比较两个操作数的指数
	slt $t0,$s1,$s4
	#如果第一个操作数的指数大于第二个操作数,则对第二个操作数进行右移
	beq $t0,$zero,Add_srl_so
	#否则对第一个操作数进行右移
	j Add_srl_fo
	
#对第一个操作数进行一次右移
Add_srl_fo:
	#第一个操作数的尾数右移1位
	srl $s2,$s2,1
	#第一个操作数的指数增加1
	addi $s1,$s1,1
	#如果第一个操作数的指数为255,则认为发生了上溢
	beq $s1,255,Overflow
	#比较两个数的指数,如果匹配则跳转至尾数相加
	beq $s1,$s4,Add_mantissa
	#否则继续对第一个操作数进行右移
	j Add_srl_fo

#对第二个操作数进行一次右移
Add_srl_so:
	#第二个操作数的尾数右移1位
	srl $s5,$s5,1
	#第二个操作数的指数增加1
	addi $s4,$s4,1
	#如果第二个操作数的指数为255,则认为发生了上溢
	beq $s1,255,Overflow
	#比较两个数的指数,如果匹配则跳转至尾数相加
	beq $s1,$s4,Add_mantissa
	#否则继续对第二个操作数进行右移
	j Add_srl_so	
	
#尾数相加
Add_mantissa:
	#比较两个操作数的符号
	xor $t0,$s0,$s3
	#如果符号相同,则跳转至相同符号加法
	beq $t0,$zero,Add_same_sign
	#否则执行异号加法
	j Add_differ_sign

#异号加法
Add_differ_sign:
	#记录结果的指数
	add $t1,$s1,$zero
	#尾数相减
	sub $t2,$s2,$s5
	#如果结果为0,则打印结果0
	beq $t2,$zero,Print_result0
	#检查结果的正负性
	slt $t3,$t2,$zero
	#如果结果为负,则第一个尾数的绝对值小于第二个尾数
	beq $t3,$zero,Add_foml
	#否则第一个尾数的绝对值大于第二个尾数
	j Add_soml

#第一个尾数的绝对值大于第二个尾数(first operand mantissa larger)
Add_foml:
	#结果的符号和第一个操作数一致
	add $t0,$s0,$zero
	#检查尾数是否规格化
	j Add_normalize

#第一个尾数的绝对值小于第二个尾数(second operand mantissa larger)
Add_soml:
	#结果的符号和第二个操作数一致
	add $t0,$s3,$zero
	#重新计算尾数,保证其为正数
	sub $t2,$s5,$s2
	#检查尾数是否规格化
	j Add_normalize

#检查尾数并进行规格化
Add_normalize:
	#加载最小规格化数到指定寄存器
	li $t3,0x00080000
	#比较结果的尾数和上述规格化数的大小
	slt $t4,$t2,$t3
	#如果结果的尾数大于等于上述规格化数,跳转至结果打印,否则对尾数进行规格化
	beq $t4,$zero,Print_binary
	#对尾数进行一次左移
	sll $t2,$t2,1
	#指数减少1
	addi $t1,$t1,-1
	#检查下溢
	beq $t1,$zero,Underflow
	#再次检查尾数是否规格化
	j Add_normalize

#同号加法
Add_same_sign:		
	#记录结果的符号
	add $t0,$s0,$zero
	#记录结果的指数
	add $t1,$s1,$zero
	#尾数相加
	add $t2,$s2,$s5
	#取结果的第24位
	srl $t3,$t2,24
	#如果第24位为0,则结果是规格化数，跳转至结果打印
	beq $t3,$zero,Print_binary
	#否则对结果进行规格化,尾数右移1位
	srl $t2,$t2,1
	#结果的指数增加1
	addi $t1,$t1,1
	#如果规格化后的指数为255,则认为发生了上溢
	beq $t1,255,Overflow
	#否则打印结果
	j Print_binary

#执行减法操作
Sub:
	#对第二个操作数的符号位取反
	xori $s3,$s3,1
	#执行等效加法
	j Add
	
#执行乘法操作
Mul:
	#检查第一个浮点数的指数是否为0
	beqz $s1,Mul_feez
	#检查第二个浮点数的指数是否为0
	beqz $s4,Mul_seez
	#两个浮点数都不为0,则执行常规乘法
	j Mul_simply

#第一个浮点数的指数为0(first exponent equal to zero)
Mul_feez:
	#第一个浮点数的指数为0时,如果尾数只含隐藏位1,则直接打印结果0
	beq $s2,0x00800000,Print_result0
	#否则检查第二个浮点数的指数是否为0
	beqz $s4,Mul_seez
	#两个浮点数都不为0,则执行常规乘法
	j Mul_simply

#第二个浮点数的指数为0(second exponent equal to zero)
Mul_seez:
	#第二个浮点数的指数为0时,如果尾数只含隐藏位1,则直接打印结果0
	beq $s5,0x00800000,Print_result0
	#否则两个浮点数都不0,执行常规乘法
	j Mul_simply

#常规乘法
Mul_simply:
	#两个偏阶指数相加
	add $t1,$s1,$s4
	#减去偏阶值得到新的偏阶指数
	addi $t1,$t1,-127
	#尾数相乘,Hi的低16位中存储有尾数相乘结果的2位整数位和14位小数位,Lo中存储有32位小数位
	mult $s2,$s5
	#取出乘法结果的高32位
	mfhi $t2
	#取出乘法结果的低32位
	mflo $t3
	#将Hi中的2位整数位和14位小数位左移9位
	sll $t2,$t2,9
	#保留Lo中的高9位,舍弃低23位
	srl $t3,$t3,23
	#拼接为新的尾数(2位整数位+23位小数位)
	or $t2,$t2,$t3
	#记录尾数的第25位
	andi $t3,$t2,0x01000000
	#如果第25位为0则跳过规格化
	beqz $t3,Mul_skip
	#向右规格化
	srl $t2,$t2,1
	#指数增加1
	addi $t1,$t1,1
#跳过规格化
Mul_skip:
	#检查上溢
	bgt $t1,254,Overflow
	#检查下溢
	blt $t1,1,Underflow
	#同号为正,异号为负
	xor $t0,$s0,$s3
	#打印二进制计算结果
	j Print_binary

#执行除法操作	
Div:
	#检查除数的指数是否为0
	bnez $s4,Div_iszero
	#检查除数的尾数是否只有隐藏位非0
	bne $s5,0x00800000,Div_iszero 
	#两者都为0,则除数为0,打印错误信息
	j Dividend0
	
#检查被除数是否为0
Div_iszero:
	#检查被除数的指数是否为0
	bnez $s1,Div_simply
	#检查被除数的尾数是否只有隐藏位非0
	bne $s2,0x00800000,Div_simply
	#两者都为0,则被除数为0,打印结果0
	j Print_result0

#常规除法
Div_simply:
	#两个偏阶指数相减
	sub $t1,$s1,$s4
	#加上偏阶值得到新的偏阶指数
	addi $t1,$t1,127
	#尾数相除
	div $s2,$s5
	#取出商
	mflo $t2
	#取出余数
	mfhi $t3
	#由于商只可能为0或1,且在尾数的第0位而非第23位,因此对指数进行相应调整
	addi $t1,$t1,23
#循环计算尾数
Div_mantissa_loop:
	#余数左移1位
	sll $t3,$t3,1
	#指数减少1
	addi $t1,$t1,-1
	#商左移1位
	sll $t2,$t2,1
	#检查新的余数和除数的大小关系
	sge $t4,$t3,$s5
	#计算新的商的最低位
	add $t2,$t2,$t4
	#如果新的余数小于除数,则余数无需减去除数
	beqz $t4,Div_skip
	#否则新余数等于余数减去除数
	sub $t3,$t3,$s5
#余数无需减去除数
Div_skip:
	#检查商的第24位
	andi $t4,$t2,0x00800000
	#如果为0,则继续计算尾数
	beqz $t4,Div_mantissa_loop
	#否则尾数计算结束,检查上溢
	bgt $t1,254,Overflow
	#检查下溢
	blt $t1,1,Underflow
	#同号为正,异号为负
	xor $t0,$s0,$s3
	#打印二进制计算结果
	j Print_binary

#打印二进制计算结果
Print_binary:
	#打印提示信息:浮点结果
	li $v0,4
	la $a0,msg_result
	syscall
	#打印提示信息
	jal Print_binary_note
	#如果是正数则不打印负号
	beq $t0,$zero,Print_binary_skip
	#打印负号
	li $v0,4
	la $a0,msg_negative
	syscall
	
#二进制打印时跳过符号位
Print_binary_skip:
	#打印"1."
	li $v0,4
	la $a0,msg_one_point
	syscall
	#将尾数的隐藏位置0并作为参数
	sll $a1,$t2,9
	#打印小数点后的二进制尾数
	jal Print_binary_mantissa
	#打印"*2^"
	li $v0,4
	la $a0,msg_binary_exp
	syscall
	#打印指数
	li $v0,1
	#将移码转换为原码
	addi $a0,$t1,-127
	syscall
	#打印回车
	jal Print_return
	#跳转至打印十六进制计算结果
	j Print_hex

#打印十六进制计算结果
Print_hex:
	#打印提示信息
	jal Print_hex_note	
	#如果是正数则不打印负号
	beq $t0,$zero,Print_hex_skip
	#打印负号
	li $v0,4
	la $a0,msg_negative
	syscall
	
#十六进制打印时跳过符号位
Print_hex_skip:
	#打印十六进制前缀
	li $v0,4
	la $a0,msg_hex_h
	syscall
	#计算指数真值
	addi $t3,$t1,-127
	#按照指数真值的正负性分别处理
	bltz $t3,Print_negative_exp
	#保留指数符号
	move $s6,$zero
	#指数真值为正时,计算指数对4取模的结果
	andi $t4,$t3,3
	#计算右移量以获得十六进制下小数点前的数
	li $t5,23
	sub $t5,$t5,$t4
	#保留十六进制下小数点前的数
	srlv $a1,$t2,$t5
	#计算左移量以获得十六进制下小数点后的数
	addi $t5,$t4,9
	#保留十六进制下小数点后的数
	sllv $a2,$t2,$t5
	#将指数转为十六进制
	srl $t3,$t3,2	
	#打印处理后的十六进制数
	j Print_hex_continue
	
#十六进制指数为负数
Print_negative_exp:	
	#计算指数的相反数
	li $t3,127
	sub $t3,$t3,$t1
	#计算左移量
	li $t5,0
#通过循环操作将指数的相反数转变为比它大的第一个4的倍数
Print_negative_loop:	
	#计算指数相反数对4取模的结果
	andi $t4,$t3,3
	#如果结果为0则跳出循环继续打印
	beqz $t4,Print_negative_hex_exp
	#十六进制尾数左移量增加1
	addi $t5,$t5,1
	#指数相反数增加1
	addi $t3,$t3,1
	#循环操作
	j Print_negative_loop
	
#将指数的相反数转为十六进制并继续打印
Print_negative_hex_exp:
	#计算右移量以获得十六进制下小数点前的数
	li $t6,23
	sub $t6,$t6,$t5
	#保留十六进制下小数点前的数
	srlv $a1,$t2,$t6
	#计算左移量以获得十六进制下小数点后的数
	addi $t6,$t5,9
	#保留十六进制下小数点后的数
	sllv $a2,$t2,$t6
	#将指数转为十六进制
	srl $t3,$t3,2
	#保留指数负号
	li $s6,1
	#打印处理后的十六进制数
	j Print_hex_continue
	
#继续十六进制打印
Print_hex_continue:	
	#打印十六进制尾数
	jal Print_hex_mantissa
	#打印"*16^"
	li $v0,4
	la $a0,msg_hex_exp
	syscall
	#如果指数为负
	beqz $s6,Print_hexp_exp_skip
	#则打印负号
	li $v0,4
	la $a0,msg_negative
	syscall
#跳过指数负号打印
Print_hexp_exp_skip:
	#打印指数
	li $v0,1
	move $a0,$t3
	syscall
	#打印回车
	jal Print_return
	#打印运算任务完成信息
	li $v0,4
	la $a0,msg_complete
	syscall
	#打印结束,返回菜单页面
	j Menu

#打印十六进制尾数(a1为尾数小数点前的数,a2为尾数小数点后的数)
Print_hex_mantissa:
	#储存返回值地址
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#打印小数点前的尾数
	li $v0,11
	lb $a0,hex_table($a1)
	syscall
	#打印小数点
	li $v0,4
	la $a0,msg_point
	syscall
#循环打印小数点后的尾数
Print_hex_mantissa_loop:
	#计算小数点后尾数的最高4位
	srl $t4,$a2,28
	#打印对应的十六进制数
	li $v0,11
	lb $a0,hex_table($t4)
	syscall
	#通过左移舍弃最高4位
	sll $a2,$a2,4
	#如果新的尾数为0则结束打印
	beqz $a2,Print_hex_mantissa_back
	#否则继续打印新的尾数
	j Print_hex_mantissa_loop			
#十六进制尾数打印结束
Print_hex_mantissa_back:
	#取回返回值地址
	lw $ra,0($sp)
	addi $sp,$sp,4
	#返回函数调用处
	jr $ra

#打印二进制尾数(参数a1为小数点后的尾数)
Print_binary_mantissa:
	#储存返回值地址
	addi $sp,$sp,-4
	sw $ra,0($sp)
#循环打印小数点后的尾数
Print_binary_mantissa_loop:
	#计算尾数的最高位
	srl $t3,$a1,31
	li $v0,1
	#打印最高位
	move $a0,$t3
	syscall
	#通过逻辑左移舍弃最高位
	sll $a1,$a1,1
	#如果新的尾数为0,则结束打印
	beq $a1,$zero,Print_binary_back
	#如果新的尾数不为0,则继续打印下一位
	j Print_binary_mantissa_loop
Print_binary_back:
	#取回返回值地址
	lw $ra,0($sp)
	addi $sp,$sp,4
	#返回函数调用处
	jr $ra
	
#打印结果0
Print_result0:
	#打印提示信息:浮点结果
	li $v0,4
	la $a0,msg_result
	syscall
	#打印提示信息:二进制输出
	jal Print_binary_note
	#打印整数
	li $v0,1
	#设置参数为0
	add $a0,$zero,$zero
	syscall
	#打印回车符
	jal Print_return
	#打印提示信息:十六进制输出
	jal Print_hex_note
	#打印十六进制前缀
	li $v0,4
	la $a0,msg_hex_h
	syscall
	#打印整数
	li $v0,1
	#设置参数为0
	move $a0,$zero
	syscall
	#打印回车符
	jal Print_return
	#打印运算任务完成信息
	li $v0,4
	la $a0,msg_complete
	syscall
	#返回菜单页面
	j Menu

#打印二进制输出提示
Print_binary_note:
	#储存返回值地址
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#打印提示信息
	li $v0,4
	la $a0,msg_binary
	syscall
	#取回返回值地址
	lw $ra,0($sp)
	addi $sp,$sp,4
	#返回调用处
	jr $ra

#打印十六进制输出提示
Print_hex_note:
	#储存返回值地址
	addi $sp,$sp,-4
	sw $ra,0($sp)
	#打印提示信息
	li $v0,4
	la $a0,msg_hex
	syscall
	#取回返回值地址
	lw $ra,0($sp)
	addi $sp,$sp,4
	#返回调用处
	jr $ra

#打印回车
Print_return:
	#储存返回值地址
	addi $sp,$sp,-4	
	sw $ra,0($sp)
	#打印回车符
	li $v0,4
	la $a0,msg_return
	syscall
	#取回返回值地址
	lw $ra,0($sp)
	addi $sp,$sp,4	
	#返回调用处
	jr $ra

#除数为0
Dividend0:
	#打印提示信息
	li $v0,4
	la $a0,msg_dividend0
	syscall
	#返回菜单页面
	j Menu

#上溢
Overflow:
	#打印提示信息
	li $v0,4
	la $a0,msg_overflow
	syscall
	#返回菜单页面
	j Menu

#下溢
Underflow:
	#打印提示信息
	li $v0,4
	la $a0,msg_underflow
	syscall
	#返回菜单页面
	j Menu

#输入不合法	
Invalid_input:
	#打印提示信息
	li $v0,4
	la $a0,msg_invalid_input
	syscall
	#返回菜单页面
	j Menu	

#结束计算
Exit:
	#打印提示信息
	li $v0 4
	la $a0,msg_exit
	syscall
	#执行系统退出
	li $v0,10
	syscall

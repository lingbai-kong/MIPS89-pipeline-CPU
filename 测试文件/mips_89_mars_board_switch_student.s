.data
ANSCODE:.space 4	#最终数码管显示的内存单元
A:.space 240
B:.space 240
C:.space 240
D:.space 240
T:.space 16
exp:.space 4
.text
j main
nop
j exception
nop

exception:				#根据异常号，转跳至_syscall，_break，_teq某处
#exp计数
lw $k0,exp
addiu $k0,$k0,1
sw $k0,exp

mfc0 $k0,$13
andi $k1,$k0,0xff

addi $k0,$0,0
beq $k0,$k1,_timerInt
sll $0,$0,0

addi $k0,$0,0x20
beq $k0,$k1,_syscall
sll $0,$0,0

addi $k0,$0,0x24
beq $k0,$k1,_break
sll $0,$0,0

addi $k0,$0,0x34
beq $k0,$k1,_teq
sll $0,$0,0

addi $5,$0,0
sub $5,$5,10
sw $5,ANSCODE
j dead_loop

_break:
lui $10,0xffff
ori $10,$10,0xffff
j _epc_plus4
sll $0,$0,0

_syscall:
lui $11,0xffff
ori $11,$11,0xffff
j _epc_plus4
sll $0,$0,0

_teq:
lui $12,0xffff
ori $12,$12,0xffff
j _epc_plus4
sll $0,$0,0

_timerInt:
mfc0 $1,$11
addi $1,$1,0x100
bne $1,$0,_timerInt_fresh
addi $1,$1,1 #防止compare寄存器为0导致时钟中断关闭
_timerInt_fresh:
mtc0 $1,$11

addi $3,$0,2
lhu $2,ANSCODE($3)
addi $2,$2,1
sh $2,ANSCODE($3)
eret
nop

j _epc_plus4
sll $0,$0,0

_epc_plus4:
mfc0 $k0,$14
addi $k0,$k0,0x4
mtc0 $k0,$14
eret
sll $0,$0,0

main:

jal func_test1
nop
jal func_reset
nop
jal func_test2
nop
jal func_reset
nop
jal func_test3
nop
jal func_reset
nop
jal func_test4
nop
jal func_reset
nop
jal func_test5
nop
jal func_reset
nop
jal func_test6
nop
jal func_reset
nop
jal func_test7
nop
jal func_reset
nop
jal func_test8
nop
jal func_reset
nop
jal func_test9
nop
jal func_reset
nop
jal func_test10
nop
jal func_reset
nop
jal func_test11
nop
jal func_reset
nop

addi $5,$0,1
sw $5,ANSCODE
dead_loop:
j dead_loop
nop

func_reset:
addi $1,$0,0
addi $2,$0,0
addi $3,$0,0
addi $4,$0,0
addi $5,$0,0
addi $6,$0,0
addi $7,$0,0
addi $8,$0,0
addi $9,$0,0
addi $10,$0,0
addi $11,$0,0
addi $12,$0,0
addi $13,$0,0
addi $14,$0,0
addi $15,$0,0
addi $16,$0,0
addi $17,$0,0
addi $18,$0,0
addi $19,$0,0
addi $20,$0,0
addi $21,$0,0
addi $22,$0,0
addi $23,$0,0
addi $24,$0,0
addi $25,$0,0
addi $26,$0,0
addi $27,$0,0
addi $28,$0,0
addi $29,$0,0
addi $30,$0,0
jr $31
nop

#第一个测试函数，测试代码为54条MIPS指令流水线标准测试程序
#测试指令包括：addi,addiu,andi,ori,slti,sltiu,lui,xori,and,beq,bne,j,jal,jr,lw,sw,mul,sll,sub
#错误码:-1
func_test1:
addi $2,$0,0    #a[i] 初值为0
addiu $3,$0,1   #b[i] 初值为1
andi $4,$0,1234 #c[i] 初值为0
slti $5,$3,0   	#d[i] 初值为0
ori $6,$0,1     #计数器，每一个循环增加1
xori $7,$3,1    #a[i-1] 初值为0
sltiu $8,$0,1   #b[i-1] 初值为1
addu $10,$0,$0  #分支判断
addi $11,$0,60  #计数器上限
and  $12,$0,$11	#存放数组地址
addi $14,$0,3	#存放之后用到的乘法系数3

# 初始化A[0] B[0] C[0] D[0]
lui $27,0x0000
addu $27,$27,$0
sw $2,A($27)
lui $27,0x0000
addu $27,$27,$0
sw $3,B($27)
lui $27,0x0000
addu $27,$27,$0
sw $2,C($27)
lui $27,0x0000
addu $27,$27,$0
sw $3,D($27)

test1_loop:
sll $12,$6,2	# $6(i) 乘 4 (=4i) 存入 $12
add $7,$7,$6	# $7 加 i
		# 把 a[i] 的内容存入 A[i] 中
lui $27,0x0000
addu $27,$27,$12
sw $7,A($27)
mul $15,$14,$6	# $14 (3) 乘以 $6(i) (= 3i) 存入$15
add $8,$8,$15	# 把 $8 (b[i-1]) 的内容加上 3i
lui $27,0x0000	# 把 b[i] 的内容存入 B[i] 中
addu $27,$27,$12
sw $8,B($27)
slti $10,$6,20	# $6 是否小于 20 (i 是否小于 20)? 记入 $10
bne $10,1,test1_c1#若不是, 跳转

# (0<=i<=19)
		# 把 c[i] 的内容存入 C[i] 中 (c[i] = a[i])
lui $27,0x0000
addu $27,$27,$12
sw $7,C($27)
		# 把 d[i] 的内容存入 D[i] 中 (d[i] = b[i])
lui $27,0x0000
addu $27,$27,$12
sw $8,D($27)
addi $15,$7,0 	# $15 $16 分别赋值为 c[i] d[i]
addi $16,$8,0
j test1_endc
nop

# (20<=i<=39)
test1_c1: 
		# i 是否小于 40 ？ 若不是，跳转到 c2
slti $10,$6,40
addi $27,$0,1
bne $10,$27,test1_c2
		# C[i] = a[i] + b[i]
add $15,$7,$8
lui $27,0x0000
addu $27,$27,$12
sw $15,C($27)
		# D[i] = a[i] * c[i]
mul $16,$15,$7
lui $27,0x0000
addu $27,$27,$12
sw $16,D($27)
j test1_endc
nop

# (i>=40)
test1_c2: 			
		# C[i] = a[i] * b[i]
mul $15,$7,$8
lui $27,0x0000
addu $27,$27,$12
sw $15,C($27)
		# D[i] = c[i] * b[i]
mul $16,$15,$8
lui $27,0x0000
addu $27,$27,$12
sw $16,D($27)

test1_endc:
addi $6,$6,1 	# i = i + 1
bne $6,$11,test1_loop # i = 60 不跳转
nop

addi $2,$0,59
sll $2,$2,2
lw $3,D($2)
addi $4,$0,0
lui $4,0x9fd0
addi $4,$4,0xb7ea
beq $3,$4,test1_ok
nop

test1_error:
addi $5,$0,0
sub $5,$5,1
sw $5,ANSCODE
j dead_loop
nop

test1_ok:
jr $31
nop

#主要测试指令 mfhi,mflo,div,divu
#错误码:-2
func_test2:
addi $3,$0,0x7fff
addi $4,$0,0x10
div $3,$4
mfhi $20
mflo $21
lui $3,0xffff
ori $3,$3,0xfff8
addi $4,$0,0x2
divu $3,$4
mfhi $22
mflo $23
xor $20,$20,$21
nor $22,$22,$23
or $20,$20,$22

lui $2,0x8000
addi $2,$2,0x7f3
beq $20,$2,test2_ok
nop

test2_error:
addi $5,$0,0
sub $5,$5,2
sw $5,ANSCODE
j dead_loop
nop

test2_ok:
jr $31
nop

#测试指令包括：sb,lb,lbu,sh,lh,lhu,mthi,mtlo,mfhi,mflo,sltu,sllv,srav,srlv,sra,srl,subu,add,addu,slt,clz,clo
#错误码:-3
func_test3:
addi $2,$0,0x000f
addi $3,$0,0x00ff
addi $4,$0,0x0fff
addi $5,$0,0xffffffff
addi $6,$0,0x5555
addi $7,$0,0xffffaaaa
addi $8,$0,0xffffbbbb
addi $9,$0,0xffffcccc
addi $10,$0,0xffffdddd
addi $11,$0,0xffffeeee
addi $12,$0,0xffffffff

sb $2,T+0
sb $3,T+1
sb $4,T+2
sb $5,T+3
sh $6 T+4
sh $7 T+6
sh $8 T+8
sh $9 T+10
mthi $10
mtlo $11

lbu $2,T+3
lbu $3,T+0
lb $4,T+1
lb $5,T+2
lh $6 T+6
lh $7 T+8
lhu $8 T+10
lhu $9 T+4
mflo $10
mfhi $11

slt $13,$2,$3
sltu $14,$3,$4
sllv $15,$4,$5
sllv $16,$5,$6
srav $17,$7,$8
srav $18,$8,$9
srlv $19,$9,$10
srlv $20,$10,$11
sra $21,$5,0x5
sra $22,$6,0x6
srl $23,$7,0x7
srl $24,$8,0x8

subu $25,$13,$14
subu $26,$15,$16
add $27,$17,$18
add $28,$19,$20
addu $29,$21,$22
addu $30,$23,$24

clo $2,$25
clz $4,$26
add $3,$27,$28
sub $5,$29,$30

add $2,$2,$3
add $4,$4,$5
add $2,$2,$4

lui $3,0xfdff
addi $3,$3,0xfe89
beq $3,$2,test3_ok
nop

test3_error:
addi $5,$0,0
sub $5,$5,3
sw $5,ANSCODE
j dead_loop
nop

test3_ok:
jr $31
nop

#测试指令包括：jalr
#错误码:-4
func_test4:
add $20,$0,$31
jal jalr_test
nop
jalr_test:
add $21,$0,$31
addi $21,$21,16
jalr $22,$21
beq $21,$22,test4_ok
nop

test4_error:
addi $5,$0,0
sub $5,$5,4
sw $5,ANSCODE
j dead_loop
nop

test4_ok:
jr $20
nop

#测试指令包括：mult,multu,madd,maddu,msub,msubu
#错误码:-5
func_test5:
ori  $1,$0,0xffff                  
sll  $1,$1,16
ori  $1,$1,0xfffb           # $1 = -5
ori  $2,$0,6                # $2 = 6
mult $1,$2                  # hi = 0xffffffff
                            # lo = 0xffffffe2
mfhi $3
mflo $4
madd $1,$2                  # hi = 0xffffffff
                            # lo = 0xffffffc4
mfhi $5
mflo $6

maddu $1,$2                 # hi = 0x5
                            # lo = 0xffffffa6
mfhi $7
mflo $8

msub $1,$2                  # hi = 0x5
                            # lo = 0xffffffc4   
mfhi $9
mflo $10

msubu $1,$2                 # hi = 0xffffffff
                            # lo = 0xffffffe2  
mfhi $11
mflo $12

multu $1,$2                 # hi = 0x5
			    # lo = 0xffffffe2
mfhi $13
mflo $14

sub $15,$3,$4
sub $16,$5,$6
sub $17,$7,$8
sub $18,$9,$10
sub $19,$11,$12
sub $20,$13,$14

add $21,$15,$16
add $22,$17,$18
add $23,$19,$20

add $24,$21,$22
add $24,$24,$23		#0x138

addi $3,$0,0x138
beq $24,$3,test5_ok
nop

test5_error:
addi $5,$0,0
sub $5,$5,5
sw $5,ANSCODE
j dead_loop
nop

test5_ok:
jr $31
nop

#测试指令包括：movn,movz
#错误码:-6
func_test6:
lui $2,0x0000          # $2 = 0x00000000
lui $3,0xffff          # $3 = 0xffff0000
lui $4,0x0505          # $4 = 0x05050000
lui $5,0x0000          # $5 = 0x00000000 

movz $5,$3,$2          # $5 = 0xffff0000
addi $20,$0,0xffff0000
bne $5,$20,test6_error
nop
movn $5,$4,$2          # $5 = 0xffff0000
addi $20,$0,0xffff0000
bne $5,$20,test6_error
nop
movn $5,$4,$3          # $5 = 0x05050000
addi $20,$0,0x05050000
bne $5,$20,test6_error
nop
movz $5,$3,$4          # $5 = 0x05050000
addi $20,$0,0x05050000
bne $5,$20,test6_error
nop

j test6_ok
nop

test6_error:
addi $5,$0,0
sub $5,$5,6
sw $5,ANSCODE
j dead_loop
nop

test6_ok:
jr $31
nop

#测试指令包括：bgez,bgtz,blez,bltz,bltzal,bgezal
#错误码:-7
func_test7:
add $30,$0,$31

addi $10,$0,0
bgez $10,TAG1
j test7_error
TAG1:
addi $10,$10,1
bgez $10,TAG2
j test7_error
TAG2:
addi $20,$0,1
sub $10,$0,$20
bgez $10,test7_error

addi $10,$0,1
bgtz $10,TAG4
j test7_error
TAG4:
addi $10,$10,2
bgtz $10,TAG5
j test7_error
TAG5:
addi $20,$0,1
sub $10,$0,$20
bgtz $10,test7_error

addi $10,$0,1
blez $10,test7_error
addi $10,$10,2
blez $10,test7_error
addi $20,$0,1
sub $10,$0,$20
blez $10,TAG6
j test7_error

TAG6:
addi $10,$0,0
bltz $10,test7_error
addi $10,$10,1
bltz $10,test7_error
addi $20,$0,1
sub $10,$0,$20
bltz $10,TAG7
j test7_error

TAG7:
addi $31,$0,0
addi $10,$0,0
bltzal $10,test7_error
addi $10,$10,1
bltzal $10,test7_error
addi $20,$0,1
sub $10,$0,$20
bltzal $10,TAG8
j test7_error

TAG8:
beq $31,$0,test7_error
addi $31,$0,0
addi $10,$0,0
bgezal $10,TAG9
j test7_error
TAG9:
addi $10,$10,1
bgezal $10,TAG10
j test7_error
TAG10:
addi $20,$0,1
sub $10,$0,$20
bgezal $10,test7_error
beq $31,$0,test7_error
j test7_ok

test7_error:
addi $5,$0,0
sub $5,$5,7
sw $5,ANSCODE
j dead_loop
nop

test7_ok:
jr $30
nop

#测试指令包括：lwl,lwr,swl,swr
#错误码:-8
func_test8:
#initialize1
addi $1,$0,0x0001
addi $2,$0,0x0002
addi $3,$0,0x0003
addi $4,$0,0x0004
addi $5,$0,0x0005
addi $6,$0,0x0006
addi $7,$0,0x0007
addi $8,$0,0x0008
addi $9,$0,0x0009
addi $10,$0,0x000A
addi $11,$0,0x000B
addi $12,$0,0x000C
addi $13,$0,0x000D
addi $14,$0,0x000E
addi $15,$0,0x000F
addi $16,$0,0x0010
addi $17,$0,0x0011
addi $18,$0,0x0012
addi $19,$0,0x0013
addi $20,$0,0x0014

lui $30,0x1001
#test
swl $0, 0($30)
swl $1, 1($30)
swl $2, 2($30)
swl $3, 3($30)
swl $4, 4($30)
swl $5, 5($30)
sb $6, 6($30)
swr $7, 7($30)
sb $8, 8($30)
swl $9, 9($30)
swr $10,10($30)
swr $11,11($30)
swr $12,12($30)
swr $13,13($30)
swr $14,14($30)
swr $15,15($30)
sb $16,16($30)
swl $17,17($30)
sb $18,18($30)
swr $19,19($30)
sb $20,20($30)

lwr $20, 1($30)
lwr $1, 2($30)
lwl $2, 3($30)
lwl $3, 4($30)
lwr $4, 5($30)
lwr $5, 6($30)
lwl $6, 7($30)
lwl $7, 8($30)
lwr $8, 9($30)
lwr $9, 10($30)
lwl $10,11($30)
lwl $11,12($30)
lwr $12,13($30)
lwr $13,14($30)
lwr $14,15($30)
lwr $15,16($30)
lwr $16,17($30)
lwl $17,18($30)
lwl $18,19($30)
lwl $19,20($30)

add $21,$1,$2
add $22,$3,$4
add $23,$5,$6
add $24,$7,$8
add $25,$9,$10
add $26,$11,$12
add $27,$13,$14
add $28,$15,$16
add $29,$17,$18
add $30,$19,$20

xor $1,$21,$22
xor $2,$23,$24
xor $3,$25,$26
xor $4,$27,$28
xor $5,$29,$30

addu $6,$1,$2
addu $7,$3,$4
add $8,$5,$6
add $8,$8,$7#0x52503532

lui $3,0x5250
addi $3,$3,0x3532
beq $8,$3,test8_ok
nop

test8_error:
addi $5,$0,0
sub $5,$5,8
sw $5,ANSCODE
j dead_loop
nop

test8_ok:
jr $31
nop

#测试指令包括：ll,sc
#错误码:-9
func_test9:
ori $2,$0,0x1234     # $2 = 0x00001234
sw $2,T($0)
ll  $3,T            # $3 = 0x00001234
addi $4,$2,0x1       # $4 = 0x00001235
sc  $4,T    	     # $4 = 0x1
lw  $5,T     	     # $5 = 0x00001235
addi $6,$0,0x1
addi $7,$0,0x1235
bne $4,$6,test9_error
nop
bne $5,$7,test9_error
nop
j test9_ok
nop

test9_error:
addi $5,$0,0
sub $5,$5,9
sw $5,ANSCODE
j dead_loop
nop

test9_ok:
jr $31
nop

#测试cp0
#错误码:-10
func_test10:
sw $0,exp

addi $1,$0,0x401
mtc0 $1,$12
break
sll $0,$0,0
lui $1,0xffff
ori $1,$1,0xffff
bne $1,$10,test10_error
sll $0,$0,0

syscall
sll $0,$0,0
lui $1,0xffff
ori $1,$1,0xffff
bne $1,$11,test10_error
sll $0,$0,0

addi $1,$0,0x401
mtc0 $1,$12
addi $1,$0,1
addi $2,$0,1
teq $1,$2

sll $0,$0,0
lui $1,0xffff
ori $1,$1,0xffff
bne $1,$12,test10_error
sll $0,$0,0
movz $0,$0,$12
addi $1,$0,0
addi $2,$0,0
subi $2,$2,1
tge $1,$2

sll $0,$0,0
addi $1,$0,0
addi $2,$0,0
subi $2,$2,1
tgeu $2,$1

sll $0,$0,0
addi $1,$0,0
addi $2,$0,0
subi $2,$2,1
tlt $2,$1

sll $0,$0,0
addi $1,$0,0
addi $2,$0,0
subi $2,$2,1
tltu $1,$2

sll $0,$0,0
addi $1,$0,0
addi $2,$0,0
subi $2,$2,1
tne $1,$2

sll $0,$0,0
addi $1,$0,1
teqi $1,1

sll $0,$0,0
addi $1,$0,0
sub $1,$1,1
tgei $1,-2

sll $0,$0,0
addi $1,$0,0
sub $1,$1,1
tgeiu $1,0

sll $0,$0,0
addi $1,$0,0
sub $1,$1,1
tlti $1,0

sll $0,$0,0
addi $1,$0,0
tltiu $1,1

sll $0,$0,0
addi $1,$0,0
tnei $1,1
sll $0,$0,0

lw $k0,exp
addi $3,$0,13
beq $k0,$3,test10_ok
nop

test10_error:
addi $5,$0,0
sub $5,$5,10
sw $5,ANSCODE
j dead_loop
nop

test10_ok:
jr $31
nop

#测试时钟中断
#无错误码，应当观察到anscode的高半字随时钟中断而累加
func_test11:
addi $1,$0,0x401
mtc0 $1,$12
mfc0 $1,$9
addi $1,$1,0x100
mtc0 $1,$11
jr $31
nop

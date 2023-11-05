@数据段
@全局变量及常量的声明
    .data
a:              @声明变量a
    .word 0     @a的初始值为0
b:              @声明变量b
    .word 1     @b的初始值为1
i:              @声明变量i
    .word 1     @i的初始值为1
t:              @声明变量t
    .word 0     @t的初始值为0
n:              @声明变量n
    .word 0     @n的初始值为0

@代码段
    .text
    .align 4
res: 
    .asciz "%d \n"  @声明字符串res，用于printf函数输出
    .align 4
info:
    .asciz "input the number:"  @声明字符串info，用于printf函数输出
input: 
    .asciz "%d"    @声明字符串input，用于scanf函数输入
    .align 4
	
@主函数
	.global main
	.type main, %function
main:
	@mov r7, lr
	push {fp, lr}  @保存返回地址栈基地址

.input:
	adr r0, info   @读取字info字符串地址
	bl printf     @调用printf函数输出
	mov r8, lr
	adr r0, input
	sub sp, sp, #4   @留出一个4字节的空间，保存用户输入
	mov r1, sp
	bl scanf   
	ldr r2, [sp, #0]  @将用户输入的值保存到r2寄存器中
	ldr r1, addr_n0
	str r2, [r1]  @将用户输入的值保存到变量n对应的地址中
	add sp, sp, #4
	mov lr, r8

.params:
	mov r0, r2        @将用户输入的值保存到r0寄存器中
	ldr r4, addr_i0  @将变量i的地址保存到r4寄存器中
	ldr r4, [r4]     @将变量i的值保存到r4寄存器中
	ldr r3, addr_b0  @将变量b的地址保存到r3寄存器中
	ldr r3, [r3]     @将变量b的值保存到r3寄存器中
	ldr r6, addr_a0  @将变量a的地址保存到r6寄存器中
	ldr r6, [r6]     @将变量a的值保存到r6寄存器中

.output:
	push {r0,r1,r2,r3}  @将r0、r1、r2、r3寄存器的值保存到栈中
	adr r0, res       @将字符串res的地址保存到r0寄存器中
	mov r1, r3        @将变量b的值保存到r1寄存器中
	bl printf         @调用printf函数输出 
	pop {r0,r1,r2,r3}  @将r0、r1、r2、r3寄存器的值从栈中弹出

.LOOP1:
	cmp r4, r0        @比较变量i的值和变量n的值
	bge .end       @如果i>=n，则跳转到end,i<n的话则执行下面的循环体
	mov r5, r3        @将变量b的值保存到r5寄存器中
	add r3, r3, r6    @计算a+b的值，并将结果保存到r3寄存器中
	push {r0,r1,r2,r3}  @将r0、r1、r2、r3寄存器的值保存到栈中
	adr r0, res       @将字符串res的地址保存到r0寄存器中
	mov r1, r3        @将变量b的值保存到r1寄存器中
	bl printf         @调用printf函数输出 
	pop {r0,r1,r2,r3}  @将r0、r1、r2、r3寄存器的值从栈中弹出
	mov r6, r5        @将变量t的值保存到r6寄存器中
	add r4, #1        @将变量i的值加1
	b .LOOP1          @跳回循环开头

.end:
	@mov lr, r7  
	@bx lr                  @ 退出
	pop {pc}

@桥接全局变量的地址
addr_a0:
	.word a
addr_b0:
	.word b
addr_i0:
	.word i
addr_t0:
	.word t
addr_n0:
	.word n
	
	.section   .note.GNU-stack,"",%progbits

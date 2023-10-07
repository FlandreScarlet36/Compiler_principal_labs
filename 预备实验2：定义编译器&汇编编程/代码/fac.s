@数据段
.data
input_num:
    .asciz "请输入要计算阶乘的数:"
format:
    .asciz "%d"
result:
    .asciz "%d的阶乘为：%d\n"

@代码段
.text
factorial:
    str lr,[sp,#-4]! @Pushlr(返回链接寄存器)到堆栈
    str r0,[sp,#-4]! @Push参数r0到堆栈，这个是函数的参数

    cmp r0,#0 @对比r0and0的值
    bne is_nonzero @如果r0!=0那么跳转到分支is_nonzero
    mov r0,#1 @如果参数是0，则r0=1（0的阶乘为1），函数退出
    b end

is_nonzero:

    sub r0,r0,#1
    bl factorial @调用factorial函数，其结果会保存在r0中
    ldr r1,[sp] @从sp指向地址处取回原本的参数保存到r1中
    mul r0,r1

end:
    add sp,sp,#4 @恢复栈状态，丢弃r0参数
    ldr lr,[sp],#4 @加载源lr的寄存器内容重新到lr寄存器中
    bx lr @退出factorial函数

.global main
main:
    str lr,[sp,#-4]! @保存lr到堆栈中
    sub sp,sp,#4 @留出一个4字节空间，给用户输入保存

    ldr r0,address_of_input_num @传参，提示输入num
    bl printf @调用printf

    ldr r0,address_of_format @scanf的格式化字符串参数
    mov r1,sp @堆栈顶层作为scanf的第二个参数
    bl scanf @调用scanf

    ldr r0,[sp] @加载输入的参数num给r0
    bl factorial @调用factorial，结果保存在r0

    mov r2,r0 @结果赋值给r2，作为printf第三个参数
    ldr r1,[sp] @读入的整数，作为printf第二个参数
    ldr r0,address_of_result @作为printf第一个参数
    bl printf @调用printf

add sp,sp,#4
ldr lr,[sp],#4 @弹出保存的lr
bx lr @退出

@桥接全局变量的地址
address_of_input_num:

    .word input_num
address_of_result:
    .word result
address_of_format:
    .word format

    .section .note.GNU−stack,"",%progbits



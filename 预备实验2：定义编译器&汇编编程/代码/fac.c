#include <stdio.h>
int factorial(int n)
{
    if(n == 0)
    return 1;
    else
    return n*factorial(n-1);
}
int main()
{
    int num,result;
    putf("请输入要计算阶乘的数:");
    num=getint();
    result=factorial(num);
    putf("%d的阶乘为：%d\n",num,result);
    return 0;
}
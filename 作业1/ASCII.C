//输出 ASCII 小写字母 a～z，每行 13 个字母
#include <stdio.h> 

int main(void)
{
    int row;            // 外层循环的行
    int col;            // 内层循环的列
    int ch = 0x61;      // 0x61 是小写 a 的 ASCII 码，0x7A 是小写 z。

    for (row = 0; row < 2; ++row) {
        for (col = 0; col < 13; ++col) {
            putchar(ch); //输出当前 ASCII 码对应的字母。
            ++ch;     
            if (col < 12) {
                //最后一个字母之后不输出空格，其他字母后输出空格。
                putchar(' ');
            }
        }
        putchar('\n');   //换行
    }
    return 0;  
}

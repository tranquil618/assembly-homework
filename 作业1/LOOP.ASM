; 作业：输出 ASCII 小写字母，每行 13 个字母，共两行
; 平台：8086 / 16 位 DOS / MASM 5.0
.MODEL SMALL             ; 小内存模型：代码段和数据段各不超过 64KB
.STACK 100H              ; 分配 256 字节栈空间，供保存计数器及中断使用
.DATA                    ; 数据段；本程序直接用寄存器保存字母，无须定义变量
.CODE                    ; 代码段开始
START:
    MOV AX, @DATA        ; 先把数据段地址送入 AX
    MOV DS, AX           ; 再初始化 DS，不能直接把立即数送入段寄存器
    MOV BL, 'a'          ; BL 保存当前字母，从 a 开始；不受输出返回值 AL 影响
    MOV CX, 2            ; 外层计数器：总共输出两行
ROW_NEXT:
    PUSH CX              ; 把外层 CX 压栈，避免被内层循环覆盖
    MOV CX, 13           ; 内层计数器：本行输出 13 个字母
CHAR_NEXT:
    MOV DL, BL           ; 把当前字母送入 DOS 输出功能的参数寄存器 DL
    MOV AH, 02H          ; AH=02H：选择 DOS 单字符输出功能
    INT 21H              ; 调用 DOS，输出 DL 中的字符
    INC BL               ; 当前字母加一，依次从 a 递增
    CMP CX, 1            ; 判断是否已经到本行最后一个字母
    JE CHAR_DONE         ; CX=1 时跳过空格，避免行尾出现多余空格
    MOV DL, ' '          ; 其余字母后输出一个空格，分隔相邻字母
    MOV AH, 02H          ; 再次选择单字符输出功能
    INT 21H              ; 输出空格
CHAR_DONE:
    LOOP CHAR_NEXT       ; CX 先减一；若非零，继续输出本行的下一个字母
    MOV DL, 0DH          ; 0DH 是回车：光标回到当前行行首
    MOV AH, 02H
    INT 21H              ; 输出回车
    MOV DL, 0AH          ; 0AH 是换行：光标移到下一行
    MOV AH, 02H
    INT 21H              ; 输出换行；DOS 换行使用回车、换行两个字符
    POP CX               ; 本行结束，从栈中恢复外层循环的计数器
    LOOP ROW_NEXT        ; 外层 CX 减一；非零则输出下一行，为零则结束
    MOV AX, 4C00H        ; AH=4CH：退出程序；AL=00H：返回码为 0
    INT 21H              ; 返回 DOS 命令行
END START                ; 汇编源码结束，指定程序入口为 START

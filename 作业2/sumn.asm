.MODEL SMALL
.STACK 100H

.DATA
    prompt DB 'Please input N (1-100):', '$'
    errorMsg DB 0DH,0AH,'Please enter a number from 1 to 100!',0DH,0AH,'$'
    result DW 0      ; DW定义一个16位的字，之后练习保存结果时使用

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    MOV DX, OFFSET prompt
    MOV AH,09H
    INT 21H

    MOV SI,0         ; 输入的数值从0开始累加

    READ_DIGIT:
        MOV AH,01H
        INT 21H

        CMP AL,0DH
        JE INPUT_DONE   ;按回车，结束输入

        ; 检查是否为数字字符
        CMP AL,'0'
        JB INPUT_ERROR
        CMP AL,'9'
        JA INPUT_ERROR

        SUB AL,'0'    ; 字符转换成数字0～9
        MOV AH,0      ; 让整个AX等于当前数字
        MOV DI,AX     ; DI暂存当前数字
  
        MOV AX,SI     ; AX=之前累积的数
        MOV BX,10     ; 
        MUL BX        ; DX:AX=AX*BX
        ADD AX,DI     ; 加上当前的数字

        CMP AX,100    ; 检查刚计算出的数值
        JA INPUT_ERROR; 大于100就报错

        MOV SI,AX     ; 保存更新后的N

        JMP READ_DIGIT  ; 继续读取下一个字符
        
    INPUT_ERROR:
        MOV DX,OFFSET errorMsg
        MOV AH,09H
        INT 21H

        MOV AX,4C01H
        INT 21H          ; 输入错误，退出程序

    INPUT_DONE:
        CMP SI,1
        JB INPUT_ERROR   ; 拒绝0，以及没有输入数字就按回车

        MOV AH,02H       ; 输入结束后回车、换行
        MOV DL,0DH
        INT 21H
        MOV DL,0AH
        INT 21H

    MOV AX,0         ; 累加结果从0开始
    MOV BX,1         ; 第一个要加的数是1
    MOV CX,SI        ; 循环N次，计算1～N的和

    SUM_LOOP:
        ADD AX,BX    ; 把BX加到AX中
        INC BX       ; BX+=1
        LOOP SUM_LOOP

    MOV result,AX
    MOV BX,10        ; 16位除数
    MOV CX,0         ; 记录拆出了多少位数字

    SPLIT_DIGITS:
        MOV DX,0     ; 每次除法前，都清零被除数的高16位
        DIV BX       ; DX:AX/BX,商放AX，余数放DX
        PUSH DX      ; 把这一位数字压栈
        INC CX       ; 位数加一

        CMP AX,0     ; 商是否已经为0？
        JNE SPLIT_DIGITS  ; 不是0，就继续拆下一位

    POPOUT_RESULT:
        POP DX       ; 取出一位数字，范围是0～9，所以高字节DH为0
        ADD DL,'0'
        MOV AH,02H
        INT 21H
        LOOP POPOUT_RESULT

    MOV AH,02H
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H

    MOV AX,4C00H
    INT 21H
END START


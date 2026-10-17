.MODEL SMALL
.STACK 100H

.DATA
    result DW 0      ; DW定义一个16位的字，之后练习保存结果时使用

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    MOV AX,0         ; 累加结果从0开始
    MOV BX,1         ; 第一个要加的数是1
    MOV CX,100       ; 一共加100次

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


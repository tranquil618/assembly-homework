.MODEL SMALL
.STACK 100H

.DATA 
    titleMsg DB 'The 9mul9 table:', 0DH, 0AH, '$'

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    ;  输出标题
    MOV DX, OFFSET titleMsg
    MOV AH, 09H
    INT 21H

    ; BL 当前行号9 -> 1
    ; BH 当前列号，每行从1开始

    ;  双重循环输出乘法表
    MOV BL,9        ; 第一行从9开始    

    ROW_LOOP:
        MOV BH,1    ; 每一行的列号重新从1开始

    COL_LOOP:
        ; 输出 BL * BH = 乘积
        MOV DL,BL        ; 行号是数值，需要先转换成字符
        ADD DL,'0'
        CALL PRINT_CHAR

        MOV DL,'*'
        CALL PRINT_CHAR

        MOV DL,BH        ; 列号转换成字符
        ADD DL,'0'
        CALL PRINT_CHAR

        MOV DL,'='
        CALL PRINT_CHAR

        MOV AL,BL        ; AL=行号
        MUL BH           ; AL*BH，结果放入AX

        MOV CL,10
        DIV CL           ; AX/10: 商放AL，余数放AH

        CMP AL,0
        JE PRINT_ONES    ; 十位为0时不输出，避免让9显示成09

        MOV DL,AL
        ADD DL,'0'
        CALL PRINT_CHAR  ; 输出十位：过程会保护AX

        PRINT_ONES:
            MOV DL,AH    ; AH中仍然是个位
            ADD DL,'0'
            CALL PRINT_CHAR

        MOV DL,09H       ; 制表符Tab，分格相邻算式
        CALL PRINT_CHAR

        INC BH
        CMP BH,BL
        JBE COL_LOOP     ; 列号不超过行号，就继续本行

        MOV DL,0DH
        CALL PRINT_CHAR
        MOV DL,0AH
        CALL PRINT_CHAR

        DEC BL
        CMP BL,0
        JNE ROW_LOOP     ; 行号还没减到0，就继续下一行




    MOV AX,4C00H
    INT 21H

PRINT_CHAR PROC
    PUSH AX              ; 保存调用前的 AX

    MOV AH,02H
    INT 21H              ; 输出DL中的字符

    POP AX               ; 恢复调用前的AX
    RET                  ; 返回CALL后面的指令
PRINT_CHAR ENDP

END START
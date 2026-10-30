.MODEL SMALL
.STACK 100H

.DATA 
    titleMsg DB 'x y', 0DH, 0AH, '$'
    errorMsg DB '  error', 0DH, 0AH, '$'
    doneMsg  DB 'accomplish!', 0DH, 0AH, '$'

    tableData DB 7,2,3,4,5,6,7,8,9
            DB 2,4,7,8,10,12,14,16,18
            DB 3,6,9,12,15,18,21,24,27
            DB 4,8,12,16,7,24,28,32,36
            DB 5,10,15,20,25,30,35,40,45
            DB 6,12,18,24,30,7,42,48,54
            DB 7,14,21,28,35,42,49,56,63
            DB 8,16,24,32,40,48,56,7,72
            DB 9,18,27,36,45,54,63,72,81

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    ;  输出标题
    MOV DX, OFFSET titleMsg
    MOV AH, 09H
    INT 21H

    ; BL 当前行号1 -> 9
    ; BH 当前列号，每行从1开始

    ;  双重循环检查乘法表
    MOV BL,1        ; 第一行从1开始    
    MOV SI, OFFSET tableData  ; SI指向表中的第一个数据

    ROW_LOOP:
        MOV BH, 1           ; 每行从第1列开始

    COL_LOOP:
        MOV AL, BL
        MUL BH              ; AX = 行号 × 列号，最大81

        CMP AL, [SI]        ; 比较正确乘积与表中存储的字节
        JE NEXT_ITEM        ; 相等就跳过错误输出

        ; 不相等，输出错误项的行号和列号
        MOV DL, BL
        ADD DL, '0'
        CALL PRINT_CHAR

        MOV DL, ' '
        CALL PRINT_CHAR

        MOV DL, BH
        ADD DL, '0'
        CALL PRINT_CHAR

        MOV DX, OFFSET errorMsg
        MOV AH, 09H
        INT 21H             ; 输出 error，并回车换行

    NEXT_ITEM:
        INC SI              ; 无论正确与否，都移到下一个字节
        INC BH
        CMP BH, 9
        JBE COL_LOOP        ; 每行检查完整的9列

        INC BL
        CMP BL, 9
        JBE ROW_LOOP        ; 共检查9行

        MOV DX, OFFSET doneMsg
        MOV AH, 09H
        INT 21H             ; 所有检查结束，输出完成提示

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
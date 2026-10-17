.MODEL SMALL
.STACK 100H

.DATA    ;定义程序使用的数据。 DB：按字节定义数据，字符串中的每个字符占一个字节
    ; 0DH，0AH
    prompt DB 'Please input a Hex number:',0DH,0AH,'$'
    errorMsg DB 0DH, 0AH, 'Invalid hex number!',0DH, 0AH, '$'

.CODE
START:
    MOV AX,@DATA
    MOV DS,AX

    MOV DX,OFFSET prompt ; DX保存提示字符串的偏移地址
    MOV AH,09H           ; 选择DOS的字符串输出功能
    INT 21H              ; 从DS:DX开始输出，直到遇到$停止

    MOV AH,01H           ; 选择键盘输入功能
    INT 21H              ; 等待按键，读到字符自动放入AL

    CMP AL,'a'
    ; JB 无符号比较中，小于就跳转
    JB FIRST_READY       ; 小于‘a’，不需要转大写
    CMP AL,'f'
    ; JA 无符号比较中，大于就跳转
    JA FIRST_READY       ; 大于’f‘，不属于a～f
    SUB AL,20H           ; a~f转成 A～F
    
    FIRST_READY:
        CMP AL,'0'
        JB BAD_FIRST     ; 小于‘0’，非法
        CMP AL,'9'
        JBE IS_DIGIT

        CMP AL,'A'
        JB BAD_FIRST     ; 大于‘9’但小于‘A’，非法
        CMP AL,'F'
        JA BAD_FIRST     ; 大于‘F’，非法

        ; 没有跳转，说明输入的是A-F
        SUB AL,'A'
        ADD AL,10
        JMP CONVERT_DONE     ;字母处理完，跳过数字的处理

    BAD_FIRST:
        JMP INPUT_ERROR     ;跳到统一的错误处理

    IS_DIGIT:
        SUB AL,'0'

    CONVERT_DONE:
        MOV BL,AL       ; 吧第一位转换后的数值保存到BL

    ; 再读取一个字符
    MOV AH,01H          ; 再读取一个字符
    INT 21H             ; 新字符的ASCII码放入AL

    CMP AL,0DH          ; 回车键对应0DH，比较是不是按了回车
    JE INPUT_DONE       ; 如果相等，跳到输入结束的位置

    CMP AL,'a'
    JB SECOND_READY
    CMP AL,'f'
    JA SECOND_READY
    SUB AL,20H

    SECOND_READY:
        CMP AL,'0'
        JB BAD_SECOND
        CMP AL,'9'
        JBE IS_DIGIT_2

        CMP AL,'A'
        JB BAD_SECOND
        CMP AL,'F'
        JA BAD_SECOND

        ; 如果没有跳转
        SUB AL,'A'
        ADD AL,10
        JMP CONVERT_DONE_2   ; 字母处理完，跳过数字的处理

    BAD_SECOND:
        JMP INPUT_ERROR

    IS_DIGIT_2:
        SUB AL,'0'
    
    CONVERT_DONE_2:
        SHL BL,1      ;*2
        SHL BL,1      ;*4
        SHL BL,1      ;*8
        SHL BL,1      ;*16
        ADD BL,AL     ; BL=第一位*16+第二位

    INPUT_DONE:
        ; 加上回车换行
        MOV AH,02H
        MOV DL,0DH
        INT 21H
        MOV DL,0AH
        INT 21H

        MOV AL,BL     ;把带转换的数值放入AL 
        MOV AH,0      ;清零高8位，让整个AX等于原来的BL
        MOV CL,10     ;除数是十进制的10
        DIV CL        ;AL=商，AH=余数(个位)
        MOV BH,AH     ;BH暂存个位，避免下次除法覆盖它
        MOV AH,0      ;再次清零
        DIV CL        ;再次除以10
        MOV BL,AH     ;BL保存10位，原来的输入数值已经不再需要
        ; 这个时候AL->百位  BL->十位  BH->个位
        CMP AL,0
        JE CHECK_TENS      ; 百位是零，跳到检查十位的位置

        ; 输出百位
        MOV DL,AL
        ADD DL,'0'      ; 数值转换成字符
        MOV AH,02H
        INT 21H

        JMP PRINT_TENS     ; 有百位，十位必须输出

        CHECK_TENS:
            CMP BL,0
            JE PRINT_ONES  ; 没有百位，并且十位为零，只输出个位

        PRINT_TENS:
            MOV DL,BL
            ADD DL,'0'
            MOV AH,02H
            INT 21H

        PRINT_ONES:
            MOV DL,BH
            ADD DL,'0'
            MOV AH,02H
            INT 21H


    MOV AX,4C00H
    INT 21H

    INPUT_ERROR:
        MOV DX,OFFSET errorMsg
        MOV AH,09H
        INT 21H

        MOV AX,4C01H      ; 退出程序，返回码1表示错误
        INT 21H
END START
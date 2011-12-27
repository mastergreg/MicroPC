INCLUDE MACROS.TXT

STACK_SEG SEGMENT STACK
    DW 128 DUP(?)
ENDS


DATA_SEG SEGMENT
    MSG DB "GIMME <=20 CHARS END PRESS RETURN '/' TO QUIT",0AH,0DH,"$"  
    MSG2 DB " => $"
    SPACE DB " "
    LINE DB 0AH,0DH,"$"       
    NUMS DB 21 DUP("$")
    NCNT DW 0
    LOWC DB 21 DUP("$")
    LCNT DW 0
    UPRC DB 21 DUP("$")
    UCNT DW 0
    
    
ENDS

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG,SS:STACK_SEG,DS:DATA_SEG,ES:DATA_SEG

MAIN PROC FAR
;FOR SEGMENT REGISTERS
    MOV AX,DATA_SEG
    MOV DS,AX
    MOV ES,AX

START:
    PRINT_STRING MSG
    MOV DX,0
    MOV BX,0
    CALL GET_INPUT
CNT:
    PRINT_STRING MSG2
    PRINT_STRING NUMS
    PRINT SPACE
    PRINT_STRING LOWC
    PRINT SPACE
    PRINT_STRING UPRC
    PRINT_STRING LINE  
    JMP START

EX:
    MOV AL,0H 
    EXIT
MAIN ENDP


GET_INPUT PROC NEAR
    MOV DX,0
    MOV CX,20
READL:
    READ  
    CMP AL,0DH
    JE CNT     
    CMP AL,'/'
    JE EX  
    CMP AL,30H ;0
    JL READL
    CMP AL,40H ;9+1
    JL NUMBERS  
    CMP AL,41H ;A
    JL READL
    CMP AL,5BH ;Z+1
    JL ULETTER
    CMP AL,61H ;a
    JL  READL
    CMP AL,7BH ;z+1
    JL LLETTER
    JMP READL
NUMBERS:
    MOV BX,OFFSET NUMS
    ADD BX,NCNT
    MOV [BX] ,AL
    INC NCNT
    LOOP READL
    RET
LLETTER:      
    MOV BX,OFFSET LOWC
    ADD BX,LCNT
    MOV [BX] ,AL
    INC LCNT
    LOOP READL
    RET
ULETTER:
    MOV BX,OFFSET UPRC
    ADD BX,UCNT
    MOV [BX] ,AL
    INC UCNT
    LOOP READL
    RET
GET_INPUT ENDP


CODE_SEG ENDS

END MAIN

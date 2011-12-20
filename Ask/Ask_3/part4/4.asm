INCLUDE MACROS.TXT

STACK_SEG SEGMENT STACK
    DW 128 DUP(?)
ENDS


DATA_SEG SEGMENT
    FIRST DB "First number: $"
    SECOND DB "Second number: $"  
    SPACE DB " "
    LINE DB 0AH,0DH,"$"       
    
    
ENDS

CODE_SEG SEGMENT
    ASSUME CS:CODE_SEG,SS:STACK_SEG,DS:DATA_SEG,ES:DATA_SEG

MAIN PROC FAR
    CALL GET_INPUT  
    MOV AX,BX
    MUL SI
    MOV BP,AX
    PUSH BP
    PUSH CX
    MOV CX,DX
    MOV AX,BX
    MUL DI
    ADD AX,CX
    JNO NOTOVF1
    INC DX
NOTOVF1:
    POP CX
    MOV BX,DX
    PUSH BX
    MOV BX,AX
    MOV AX,CX
    MUL SI
    ADD AX,BX
    JNO NOTOVF2
    INC DX
NOTOVF2:
    POP BX
    MOV BP,AX
    PUSH BP
    MOV AX,CX
    MUL DI
    ADD AX,BX
    JNO NOTOVF3
    INC DX
NOTOVF3:
    ADD AX,CX
    JNO NOTOVF4  
    INC DX  
NOTOVF4:
    MOV BP,AX
    PUSH BP
    MOV BP,DX  
    ;now BP has the answer
        
         
    
    EXIT
MAIN ENDP

GET_INPUT PROC NEAR    
    PRINT_STRING FIRST
    GETHON CX
    GETHON BX   
    PRINT_STRING LINE
    PRINT_STRING SECOND
    GETHON DI
    GETHON SI
    PRINT_STRING LINE
    RET
ENDP GET_INPUT   
    

GETHEX PROC NEAR
R:  READ
    MOV AH,0
    CMP AL,30H ;0
    JL R
    CMP AL,40H ;9+1
    JL NUM
    CMP AL,41H ;A
    JL R
    CMP AL,47H ;F+1
    JL CAPS
    CMP AL,61H ;a
    JL  R
    CMP AL,67H ;f+1
    JL  SMALL
    JMP R
NUM:
    SUB AL,30H
    RET
CAPS:
    SUB AL,37H
    RET
SMALL:
    SUB AL,57H
    RET
    




CODE_SEG ENDS

END MAIN

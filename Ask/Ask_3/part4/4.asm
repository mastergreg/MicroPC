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
    MOV AX,DATA_SEG
    MOV DS,AX
    MOV ES,AX
    CALL GET_INPUT    
    MOV AX,BX   ; AX = X0
    MOV DX,0    ; DX = 0
    MUL SI      ; DX::AX = X0*Y0
    MOV BP,AX   
    ; == 16 LSB in BP
    PUSH BP     ; now pushed
    PUSH CX     ; don't need X1 right now
    MOV CX,DX   ; so use it as buffer
    MOV AX,BX   ; AX = X0
    MOV DX,0    ; DX = 0
    MUL DI      ; DX::AX = X0*Y1
    ADD AX,CX   ; AX+=previous DX
    JNC NOTOVF1
    INC DX      ; if carry increase DX
NOTOVF1:
    POP CX      ; will need X1
    MOV BX,DX   ; X0 is no longer needed
    PUSH BX     ; save DX
    MOV BX,AX   ; save AX
    MOV AX,CX   ; AX = X1
    MOV DX,0    ; DX = 0
    MUL SI      ; DX::AX = X1*Y0
    ADD AX,BX   ; AX += previous AX
    JNC NOTOVF2 ; if carry increase DX
    INC DX
NOTOVF2:
    POP BX      ; BX = previous DX
    MOV BP,AX   
    ; == next 16 bits in BP
    PUSH BP     ; now pushed       
    MOV AX,CX   ; AX = X1
    MOV CX,DX   ; CX = DX
    MOV DX,0    ; DX = 0
    MUL DI      ; DX::AX = X1*Y1
    ADD AX,BX   ; AX += previous previous DX
    JNC NOTOVF3 ; if carry increase DX
    INC DX
NOTOVF3:
    ADD AX,CX   ; AX += previous DX
    JNC NOTOVF4 ; if carry increase DX
    INC DX  
NOTOVF4:
    MOV BP,AX
    ; == next 16 bits in BP
    PUSH BP     ; now pushed
    MOV BP,DX
    ; == final 16 bits in BP
    ; now BP has the answer
    CALL DIGITS_TO_HEXS
    ; printed 16 bits in HEX
    POP BP
    CALL DIGITS_TO_HEXS
    ; printed 16 bits in HEX
    POP BP
    CALL DIGITS_TO_HEXS
    ; printed 16 bits in HEX
    POP BP 
    CALL DIGITS_TO_HEXS
    ; printed 16 bits in HEX
        
         
    MOV AL,0H 
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
GET_INPUT ENDP
    
; == translates HEX input to binary values
; in AL
; "A" -> 10
; "a" -> 10
; "9" -> 9
; "F" -> 15
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

GETHEX ENDP


;======MAKE 16 BITS TO HEX=======  
DIGITS_TO_HEXS PROC NEAR
     MOV BX, BP
     MOV BL, BH ;APOMONWNW TA 4 MSB
     SHR BL, 4  ;OLIS8HSE TA STIS 4 LEAST SIGNIF 8ESEIS
     CALL PRINT_HEX
     MOV BX, BP
     MOV BL,BH
     AND BL, 0FH
     CALL PRINT_HEX
     MOV BX, BP
     AND BL, 0F0H
     SHR BL, 4
     CALL PRINT_HEX
     MOV BX, BP
     AND BL, 0FH
     CALL PRINT_HEX
     
     
     RET    
DIGITS_TO_HEXS ENDP

PRINT_HEX PROC NEAR
    CMP BL,9    ;AN O ARI8MOS EINAI METAKSU 0 K 9 PROS8ETW 30H
    JG ADDR1 
    ADD BL, 30H
    JMP ADDR2

ADDR1:
    ADD BL, 37H ;DIAFORETIKA PROS8ETW 37H ('A' = 41H)
ADDR2:
    PRINT BL
    RET  
    
PRINT_HEX ENDP
;======END OF MAKE 16 BITS TO HEX========

CODE_SEG ENDS

END MAIN

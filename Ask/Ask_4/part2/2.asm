INCLUDE MACROS.TXT

CODE SEGMENT
    ASSUME CS:CODE,DS:CODE,ES:CODE
    ORG 100H

MAIN PROC FAR
    ECHO_LINE DW 0
    ECHO_COL  DW 0
    MSG_LINE  DW 0
    MSG_COL   DW 41


START:
    CLEAR
    CALL SCREEN_SPLIT
    MOVE_THERE ECHO_LINE ECHO_COL
    ;[ this is just for testing
    MOV AL,0E3H
    ; this is just for testing
    CALL OPEN_RS232

READ_RS232:
    CALL RXCH_RS232
    CMP AL,0
    JE NOCHAR
    MOV BL,AL
; === PRINT THE MESSAGE ===
    CMP BL,0DH
    JE INCMLINE
    MOVE_THERE MSG_LINE MSG_COL
    PRINT_THERE BL
    MOV BP,OFFSET MSG_COL
    MOV BL,DS:[BP]
    INC BL
    CMP BL,80
    JNE NOINCMLINE
INCMLINE:
    INCREASE_LINE MSG_LINE MSG_COL 41
    MOVE_THERE MSG_LINE MSG_COL
; === This should scroll up when needed ===
    MOV BP,OFFSET MSG_LINE
    MOV BL,DS:[BP]
    CMP BL,22
; === compare with 22 [lines in dosbox] ===
    JNE NOCHAR
    SUB BL,1
    MOV DS:[BP],BL
    SCROLL_UP 1 0 41 23 79
    JMP NOCHAR

NOINCMLINE:
    MOV DS:[BP],BL
    
    
NOCHAR:
    READNB
    JZ READ_RS232
    MOV BL,AL
; === PRINT ECHO ===
    CMP BL,27
    JE QUIT
    CMP BL,0DH
    JE  INCELINE
    MOVE_THERE ECHO_LINE ECHO_COL
    PRINT_THERE BL
    MOV BP,OFFSET ECHO_COL
    MOV BL,DS:[BP]
    INC BL
    CMP BL,40
    JNE NOINCELINE
INCELINE:
    INCREASE_LINE ECHO_LINE ECHO_COL 0
    MOVE_THERE ECHO_LINE ECHO_COL
; === This should scroll up when needed ===
    MOV BP,OFFSET ECHO_LINE
    MOV BL,DS:[BP]
    CMP BL,22
; === compare with 22 [lines in dosbox] ===
    JNE READ_RS232
    SUB BL,1
    MOV DS:[BP],BL
    SCROLL_UP 1 0 0 23 39
    JMP READ_RS232

NOINCELINE:
    MOV DS:[BP],BL
    JMP READ_RS232

QUIT:
    CLEAR
    MOV AL,0H
    EXIT
         
MAIN ENDP

         
SCREEN_SPLIT PROC NEAR		
	MOV CX, 24  ; 24 fores na trexei to loop

LOOP1:
	MOVE_THERE_CX 40 ; paei sthn i grammh kai sthlh panta thn 40 kai tupwnei'|'
	PRINT_THERE 179
    LOOP LOOP1
	MOVE_THERE_CX 40 ; paei sthn i grammh kai sthlh panta thn 40 kai tupwnei'|'
	PRINT_THERE 179
    RET

SCREEN_SPLIT ENDP
;==== INITIALIZE RS232 PORT ====
OPEN_RS232 PROC NEAR
    JMP BEGIN
BAUD_RATE LABEL WORD
    DW 1047
    DW 768
    DW 385
    DW 192
    DW 96
    DW 48
    DW 24
    DW 12
BEGIN:
    STI
    MOV AH,AL
    MOV DX,3FBH
    MOV AL,80H
    OUT DX,AL

    MOV DL,AH
    MOV CL,4
    ROL DL,CL
    AND DX,0EH
    MOV DI,OFFSET BAUD_RATE
    ADD DI,DX
    MOV DX,3F9H
    MOV AL,CS:[DI]+1
    OUT DX,AL

    MOV DX,3F8H
    MOv AL,CS:[DI]
    OUT DX,AL

    MOV DX,3FBH
    MOV AL,AH
    AND AL,01FH
    OUT DX,AL
    MOV DX,3F9H
    MOV AL,0H
    OUT DX,AL
    RET
OPEN_RS232 ENDP

;==== READ 1 CHAR FROM RS232 PORT ====
RXCH_RS232 PROC NEAR
    MOV DX,3FDH
    IN AL,DX

    TEST AL,1
    JZ NOTHING
    SUB DX,5
    IN AL,DX
    JMP EXIT2
NOTHING:
    MOV AL,0
EXIT2:
    RET

RXCH_RS232 ENDP

;==== WRITE 1 CHAR TO RS232 PORT ====
TXCH_RS232 PROC NEAR
    PUSH AX
    MOV DX,3FDH

TXCH_RS232_2:
    IN AL,DX
    TEST AL,20H
    JZ TXCH_RS232_2

    SUB DX,5
    POP AX
    OUT DX,AL
    RET
TXCH_RS232 ENDP

END MAIN

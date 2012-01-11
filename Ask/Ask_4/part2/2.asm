INCLUDE MACROS.TXT

CODE SEGMENT
    ASSUME CS:CODE,DS:CODE,ES:CODE
    ORG 100H

MAIN PROC FAR
    ECHO      DW 0
    ECHO_LINE DW 0
    ECHO_COL  DW 0
    MSG_LINE  DW 0
    MSG_COL   DW 41
    MESSAGE1 DB "FOR ECHO FUNCTION PRESS <Y> . OTHERWISE PRESS <N> ? $"
    MESSAGE2 DB "PLEASE GIVE BAUD RATE. PRESS  <1> FOR 300, <2> FOR 600, <3> FOR 1200, <4> FOR 2400, <5> FOR 4800, <6> FOR9600 $"
    NEW_LINE DB 0AH, 0DH, '$'


START:
    CLEAR                           ; clear the screen
    PRINT_STRING MESSAGE1
    CALL READ_ECHO
    PRINT_STRING NEW_LINE
    PRINT_STRING MESSAGE2
    CALL READ_BR ;Baut Rate
    CALL OPEN_RS232
    CLEAR                           ; clear the screen
    CALL SCREEN_SPLIT               ; print the line in the middle
    MOVE_THERE ECHO_LINE ECHO_COL   ; move to echo line column
    ;[ THIS IS JUST FOR TESTING
    MOV AL,0E3H                     ; initialize AL  
    ; THIS IS JUST FOR TESTING

READ_RS232:
    CALL RXCH_RS232                 ; read com
    CMP AL,0                        ; if there is nothing there
    JE NOCHAR                       ; check keyboard
    MOV BL,AL                       ; move it to BL for printing
; === PRINT THE MESSAGE ===
    CMP BL,0DH                      
    JE INCMLINE
; === IF GIVEN ENTER SHOULD INC LINE ===
    MOVE_THERE MSG_LINE MSG_COL     ; move cursor to appropriate line col
    PRINT_THERE BL                  ; ok print it
    MOV BP,OFFSET MSG_COL           ; and increase
    MOV BL,DS:[BP]                  ; the column
    INC BL                          ; if it reaches 80
    CMP BL,80                       ; it should be reset to 41
    JNE NOINCMLINE                  
INCMLINE:
    INCREASE_LINE MSG_LINE MSG_COL 41       ; increase line and save new line/column
    MOVE_THERE MSG_LINE MSG_COL             ; and move the cursor there
; === THIS SHOULD SCROLL UP WHEN NEEDED ===
    MOV BP,OFFSET MSG_LINE
    MOV BL,DS:[BP]
    CMP BL,22
; === COMPARE WITH 22 [LINES IN DOSBOX] ===
    JNE NOCHAR                              
    SUB BL,1                                ; 
    MOV DS:[BP],BL
    SCROLL_UP 1 0 41 23 79                  
    JMP NOCHAR                              ; if you don't need to scroll
                                            ; then check the keyboard
NOINCMLINE:
    MOV DS:[BP],BL                  ; store the column (no line increase no scroll)
    
    
NOCHAR:
    READNB
; === no char then read com ===
    JZ READ_RS232
    MOV BL,AL
; === PRINT ECHO ===
    CMP BL,27
; === compare with escape ===
    JE QUIT
    CALL TXCH_RS232
    CMP BL,0DH
    JE  INCELINE
; === IF GIVEN ENTER SHOULD INC LINE ===
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
; === THIS SHOULD SCROLL UP WHEN NEEDED ===
    MOV BP,OFFSET ECHO_LINE
    MOV BL,DS:[BP]
    CMP BL,22
; === COMPARE WITH 22 [LINES IN DOSBOX] ===
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
    MOV CX, 24  ; 24 FORES NA TREXEI TO LOOP

LOOP1:
    MOVE_THERE_CX 40 ; PAEI STHN I GRAMMH KAI STHLH PANTA THN 40 KAI TUPWNEI'|'
    PRINT_THERE 179
    LOOP LOOP1
    MOVE_THERE_CX 40 ; PAEI STHN I GRAMMH KAI STHLH PANTA THN 40 KAI TUPWNEI'|'
    PRINT_THERE 179
    RET

SCREEN_SPLIT ENDP

READ_ECHO PROC NEAR

;PI8ANON NA XREIASTEI PUSH K POP TON AL
LOOP_E:
    READ         ;DIABAZEI XARAKTHRA APO TO PLHKTROLOGIO
    CMP AL, 'Y'  ;AN YES TOTE EXOUME ECHO
    JE ECHO_ON
    CMP AL, 'y'
    JE ECHO_ON
    CMP AL, 'N'
    JE ECHO_OFF
    CMP AL, 'n'
    JE ECHO_OFF
    CMP AL, 27
    JE QUIT       ;AN PATH8EI ESCAPE PHGAINEI STO QUIT
    JMP LOOP_E

ECHO_ON:
    MOV DS:[OFFSET ECHO],1
    RET
ECHO_OFF:
    MOV DS:[OFFSET ECHO],0
    RET

READ_ECHO ENDP

READ_BR PROC NEAR

    ;PI8ANON NA XREIASTEI PUSH K POP TON AL
LOOP_BR:
    READ         ;DIABAZEI XARAKTHRA APO TO PLHKTROLOGIO
    CMP AL, '1'  ;AN YES TOTE EXOUME ECHO
    JE BAUD_300
    CMP AL, '2'
    JE BAUD_600
    CMP AL, '3'
    JE BAUD_1200
    CMP AL, '4'
    JE BAUD_2400
    CMP AL, '5'
    JE BAUD_4800
    CMP AL, '6'
    JE BAUD_9600
    CMP AL, 27
    JE QUIT       ;AN PATH8EI ESCAPE PHGAINEI STO QUIT
    JMP LOOP_BR
    
;======DIABASMA GIA TO BAUD RATE APO PLHKTROLOGIO=======

BAUD_300:
    MOV AL,43H
    RET
BAUD_600:
    MOV AL,63H
    RET
BAUD_1200:
    MOV AL,83H
BAUD_2400:
    MOV AL,0A3H
    RET
BAUD_4800:
    MOV AL,0C3H
    RET
BAUD_9600:
    MOV AL,0E3H
    RET
READ_BR ENDP


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
    MOV DX,03FBH
    MOV AL,80H
    OUT DX,AL

    MOV DL,AH
    MOV CL,4
    ROL DL,CL
    AND DX,0EH
    MOV DI,OFFSET BAUD_RATE
    ADD DI,DX
    MOV DX,03F9H
    MOV AL,CS:[DI]+1
    OUT DX,AL

    MOV DX,03F8H
    MOV AL,CS:[DI]
    OUT DX,AL

    MOV DX,03FBH
    MOV AL,AH
    AND AL,01FH
    OUT DX,AL
    MOV DX,03F9H
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
    MOV DX,03FDH

TXCH_RS232_2:
    IN AL,DX
    TEST AL,020H
    JZ TXCH_RS232_2

    SUB DX,5
    POP AX
    OUT DX,AL
    RET
TXCH_RS232 ENDP

END MAIN

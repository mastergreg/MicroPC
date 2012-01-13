INCLUDE LIB.INC         ; PERILAMVANOYME TH VILVIO8HKH
INCLUDE MACROS.TXT      ; KAI TIS MAKROENTOLES

DATA SEGMENT
    ; ADD YOUR DATA HERE!      
    PROSTH DB 0         ; FLAG GIA PROS8ESI // FLAG GIA PLHN STHN EKTYPWSH THS AFAIRESHS
    MESSAGE DB 3DH,"$"
    GRAMMI DB 0ah,0dh,"$" 
    PLHN DB "-$"
ENDS

STACK SEGMENT
    DW   128  DUP(0)
ENDS

CODE SEGMENT
START:
; SET SEGMENT REGISTERS:
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX

    MOV PROSTH,0        ; ARXIKOPOIHSH FLAG 
    CALL READ_HEX       ; 1OS ->AX, 2OS ->DX
     
    PUSH AX
    PUSH DX
    PUSH BX
    PRINT_STRING GRAMMI ; ALLAGI GRAMMHS KAI '='
    MOV CL,3DH            
    PRINT CL              
    POP BX
    POP DX
    POP AX
    
    CMP PROSTH,1        ; ELEGXOS FLAG GIA PRAXH
    JE PROSTHESI
    JMP AFAIRESH 
    
PROSTHESI:          
    ADD AX,DX    
    JNC EKTYPWSH  
    PUSH AX
    PUSH DX
    PUSH BX   
    MOV CL,31H          ; YPERXEILISH STHN PROS8ESI -> 5O PSIFIO = 1
    ;MOV PROSTH,02      ; FLAG GIA KRATOUMENO STHN PROS8ESH
    PRINT CL
    POP BX
    POP DX
    POP AX
    
EKTYPWSH:               ; EKTYPWSH APOTELESMATOS APO PROS8ESI H AFAIRESH
    PUSH AX             ; APO8IKEUSH ARXIKOU ARI8MOU 
    CMP AH,0            ; MHN EKTYPWSEIS TA 2 PRWTA PSIFIA AN EINAI 0
    JE EPOMENO
    PUSH AX             ; ALLIWS KALESE THN ASCII KAI EKTYPWSE TA 2 PSIFIA
    MOV AL,AH           ; ARI8MOS STON AL
    CALL ASCII
    PRINT AH
    PRINT AL
    POP AX
EPOMENO:
    CALL ASCII          ; TO IDIO GIA TON ARI8MO STON AL
    PRINT AH
    PRINT AL    
    
    PUSH AX
    PUSH DX
    PUSH CX
    MOV BL,3DH          ; '='
    PRINT BL
    POP CX
    POP DX
    POP AX
    
    POP AX              ; EXAGOUME TON ARXIKO ARI8MO PROS EKTYPWSH
    
    CMP PROSTH,03       ; ELEGXOS FLAG GIA EKTPYSWSH PLHN
    JNE ADDRESS
    PUSH AX
    PUSH DX
    PRINT_STRING PLHN
    POP DX
    POP AX
    
ADDRESS:
    CALL PRINT_DEC      ; EKTYPWSH ANTISTOIXOU DEKADIKOU ARI8MOU
    PRINT_STRING GRAMMI ; ALLAGI GRAMMHS  

    JMP START 
    
AFAIRESH:
    CMP AX,DX           ; UNSIGNED SYGKRISH ARI8MWN
    JB MIKROTEROS       ; AX < DX
    SUB AX,DX           ; AX >= DX
    JMP EKTYPWSH
  
MIKROTEROS: 
   MOV PROSTH,03        ; FLAG = 03 GIA TYPWSH PLHN   
   PUSH AX
   PUSH DX
   PRINT_STRING PLHN
   POP DX
   POP AX
   SUB DX,AX
   MOV AX,DX
   JMP EKTYPWSH
      
QUIT:    
    MOV AX, 4C00H       ; EXIT TO OPERATING SYSTEM.
    INT 21H  
      
ENDS

DEFINE_READ_HEX
DEFINE_PRINT_HEX
DEFINE_PRINT_DEC   
DEFINE_ASCII
DEFINE_NUMBER

END START

 ;
 ;part1.asm
 ;
 ; Created: 29/1/2012 11:50:22 ??
 ;  Author: Valia
 ; 

 ;.include "m16def.inc"
 .def temp1 = r24
 .def temp2 = r25
 .def metrhths = r26
 .def check_PD0 = r22
 .def state = r27
 .def metr_diakopwn = r23

 .org 0x000
 rjmp main
.org 0x002
    rjmp ISR0
    reti

main:   
    ldi temp1,high(RAMEND)
    out SPH,temp1         ; arxikopoihsh ths stoivas
    ldi temp1,low(RAMEND)
    out SPL,temp1

    ldi temp1,(1<<ISC01) | (1 << ISC00) ;energopoihsh ths diakophs INT0
    out MCUCR,temp1
    ldi temp1,(1 <<INT0)
    out GICR ,temp1
    sei
    clr temp1   

    ser metrhths
    out DDRA,metrhths   ;PORTA exodos

    clr metrhths
    out DDRD,metrhths   ;PORTD eisodos

loop:
    out PORTA,metrhths

    ldi temp1,low(100)
    ldi temp2,high(100)  ;ka8ysterhsh 100 msec
    rcall wait_msec
    inc metrhths
    rjmp loop

ISR0:
    push metrhths
    in state,SREG   ;swzw thn katastash:D
    push state
    push check_PD0

    in check_PD0,PIND  ;elegxos PD0
    ror check_PD0
    brcs exit      ;an PRD0 = 0 metraei th diakoph

    ser metrhths
    out DDRB,metrhths   ;exodos h PORTB
    
    inc metr_diakopwn   ;auxanoume t metrhth

    out PORTB, metr_diakopwn        ;emfanish twn diakopwn
    ldi temp1,low(1000)
    ldi temp2,high(1000)
    ;rcall wait_msec    ;ka8ysterhsh 1 sec

exit:
    out SREG,state
    pop check_PD0
    pop state
    pop metrhths
    reti

;routines pou pragmatopoioun ka8ysterhsh tosa msec, oso to periexomeno twn r25-r24
wait_msec:
    push temp1
    push temp2
    ldi temp1, low(998)
    ldi temp2, high(998)
    rcall wait_usec 
    pop temp2
    pop temp1
    sbiw temp1, 1
    brne wait_msec
    
    ret
    
wait_usec:
    sbiw temp1,1
    nop
    nop 
    nop 
    nop 
    brne wait_usec  

    ret

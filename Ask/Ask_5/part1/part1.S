#include <avr/io.h>
#define __SFR_OFFSET 0


.global main
main:
reset: 
    ldi r24,lo8(RAMEND)
    out SPL,r24
    ldi r24,hi8(RAMEND)
    out SPH,r24
    ser r24
    out DDRA,r24
    clr r26
    clr r27
    out DDRB,r27
calc:
    out PORTA, r26

    ldi r24,lo8(1000)
    ldi r25,hi8(1000)
    

    rcall wait_msec
    inc r26
    cpi r26,16
    brlo calc
    clr r26
    rjmp calc



wait_usec:
    sbiw r24,1
    nop
    brne wait_usec
    ret

wait_msec:
    in r27,PINB
    ror r27
    brcs wait_msec
    push r24
    push r25
    ldi r24,lo8(998)
    ldi r25,hi8(998)
    rcall wait_usec

    pop r25
    pop r24
    sbiw r24,1
    brne wait_msec
    ret

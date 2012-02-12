#define __SFR_OFFSET 0
#include <avr/io.h>

.global main
main:
reset: 
    ldi r24,lo8(RAMEND)
    out SPL,r24
    ldi r24,hi8(RAMEND)
    out SPH,r24
    ser r24
    out DDRA,r24

loop:
    rjmp loop



alarm:
    push r24
    ldi r24,0xff
    out PORTA,r24
    pop r24
    ret


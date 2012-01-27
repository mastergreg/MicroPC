#define __SFR_OFFSET 0
#include <avr/common.h>
#include <avr/io.h>
#include <avr/interrupt.h>
#define TCNT1L 0x10
#define TCNT1H 0x10


.org OVF1addr
rjmp TIMER1_OVF

.global main
main:
reset: 
    ldi r24,lo8(RAMEND)
    out SPL,r24
    #ldi r24,hi8(RAMEND)
    #out SPH,r24
    ldi r24,2
    out DDRA,r24
    #set A1 for output
    #and A0 for input
    ldi r24,(1<<TOIEI)
    out TIMSK,r24
    ldi r24,(1<<CS12)|(0<<CS11)|(1<<CS10)
    out TCCR1B,r24
    ldi r24,(1 << ISC01) | (1 << ISC00)
    out MCUCR,r24
    ldi r24,(1 << INT0)
    out GICR,r24
    sei
fun:

    rjmp fun


ISR0:
    rcall debounce
    rcall set_timer
    rcall led_on
    ret

TIMER1_OVF:
    rcall led_off
    ret

debounce:
    push r26
deb_loop:
    ldi r26,(1<<INTF0)
    out GIFR,r26
    in  r26,GIFR
    rol r26
    rol r26
    ldi r24,0x5
    ldi r25,0x0
    rcall wait_msec
    brcs deb_loop
    pop r24
    ret

set_timer:
    push r24
    ldi r24,0xa4
    ldi TCNT1H,r24
    ldi r24,0x72
    ldi TCNT1L,r24
    ret

led_on:
    push r24
    ldi r24,2
    out PORTA,r24
    pop r24
    ret

led_off:
    push r24
    ldi r24,0
    out PORTA,r24
    pop r24
    ret

wait_usec:
    sbiw r24,1
    nop
    brne wait_usec
    ret

wait_msec:
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
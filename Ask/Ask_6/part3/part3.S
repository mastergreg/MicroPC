.include "m16def.inc"
.org 0x000
    rjmp main
.org 0x002
    rjmp ISR0
.org 0x010
    rjmp TIM1_OVF
    reti

main:
reset: 
    ldi r24,high(RAMEND)
    out SPH,r24
    ldi r24,low(RAMEND)
    out SPL,r24
    ldi r24,2
    ;#set A1 for output
    ;#and A0 for input
    out DDRA,r24
    ;activate timer1
    ;2 is TOIE1
    ;avrStudio doesn't know about it
    ldi r24,(1 << 2)
    out TIMSK,r24
    ldi r24,(1 << CS12)|(0<<CS11)|(1<<CS10)
    out TCCR1B,r24
    ;activate INT0
    ldi r24,(1 << ISC01) | (1 << ISC00)
    out MCUCR,r24
    ldi r24,(1 << INT0)
    out GICR,r24
    sei

fun:
    ;busy wait
    ;for interrupt
    in r26,PINA
    ror r26
    brcs ON
    rjmp fun
ON:
    rcall set_timer
    rcall led_on
    rjmp fun
   


ISR0:
	push r26 ;swzei to periexomeno tou r26
	in r26, SREG ;kai SREG
	push r26
    rcall debounce
    rcall set_timer
    rcall led_on
    out SREG,r26
    pop r26
    sei
    reti

TIM1_OVF:
    rcall led_off
    reti

debounce:
    push r26
    push r25
    push r24
deb_loop:
    ldi r26,(1<<INTF0)
    out GIFR,r26
    in  r26,GIFR
    rol r26
    rol r26
    ldi r24,0x05
    ldi r25,0x00
    rcall wait_msec
    brcs deb_loop
    pop r24
    pop r25
    pop r26
    ret

set_timer:
    push r24
    ldi r24,0xa4
    sts TCNT1H,r24
    ldi r24,0x72
    sts TCNT1L,r24
    pop r24
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
    ldi r24,low(998)
    ldi r25,high(998)
    rcall wait_usec

    pop r25
    pop r24
    sbiw r24,1
    brne wait_msec
    ret

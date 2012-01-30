/*
 * part1.S
 *
 *  Created: 29/1/2012 11:50:22 ??
 *   Author: Valia
 */ 

 ;.include "m16def.inc"
 .org 0x000
 rjmp main
.org 0x0002
	rjmp ISR0
	reti

main:	
	ldi r24,high(RAMEND)
	out SPH,r24          ; arxikopoihsh ths stoivas
	ldi r24,low(RAMEND)
	out SPL,r24

	ldi r24,(1<<ISC01) | (1 << ISC00) ;energopoihsh ths diakophs INT0
	out MCUCR,r24
	ldi r24,(1 <<INT0)
	out GICR ,r24
	sei
	clr r23 ; mhdenismos metrhth 

	ser r26
	out DDRA,r26   ;PORTA exodos
	clr r26

	clr r26
	out DDRD,r26   ;PORTD eisodos

loop:
	out PORTA,r26

	ldi r24,low(100)
	ldi r25,high(100)  ;ka8ysterhsh 100 msec
	;rcall wait_msec
	inc r26
	rjmp loop

ISR0:
	push r26
	in r27,SREG  ;swzw thn katastash:D
	push r27
	push r22

	in r22,PIND  ;elegxos PD0
	ror r22
	brcs exit	   ;an PRD0 = 0 menei edw

	ser r26
	out DDRB,r26   ;exodos h PORTB
	
	inc r23		;auxanoume t metrhth

	out PORTB, r23		;emfanish twn diakopwn
	ldi r24,low(1000)
	ldi r25,high(1000)
	;rcall wait_msec	;ka8ysterhsh 1 sec

exit:
	out SREG,r27
	pop r22
	pop r27
	pop r26
	reti

wait_msec:
	push r24
	push r25
	ldi r24, low(998)
	ldi r25, high(998)
	rcall wait_usec	
	pop r25	
	pop r24
	sbiw r24, 1
	brne wait_msec
	
	ret
	
wait_usec:
	sbiw r24,1
	nop
	nop	
	nop	
	nop	
	brne wait_usec	

	ret

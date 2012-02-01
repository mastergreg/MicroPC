/*
 * AVRAssembler2.asm
 *
 *  Created: 31/1/2012 7:58:21 ??
 *   Author: Eleni
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#define __SFR_OFFSET 0

 .global main



main:
	ldi r30,lo8(RAMEND)
	out SPL, r30
	ldi r30, hi8(RAMEND)
	out SPH, r30

	;programma metrhshs opws dinetai
	ser r26
	out DDRA, r26
	clr r26

loop:
	out PORTA, r26
	ldi r24, lo8(100)
	ldi r25, hi8(100)

	rcall wait_msec
	inc r26
	rjmp loop

;=====gia energopoihsh ths INT1 =======

	ldi r24, (1<< ISC01)|(1 << ISC00) ;na prokaleitai me shma 8etikhs akmhs
	out MCUCR, r24
	ldi r24, (1<< INT1)
	out GICR, r24
	sei

;====routina eksuphrethshs diakophs=====

ISR0:
	push r26 ;swzei to periexomeno tou r26
	in r26, SREG ;kai SREG
	push r26

	clr r27 ;clear ton r27 giati ekei 8a mazepsw to sum mou

	clr r25
	out DDRB, r25 ;den eimai sigourh gia ton r25
	in r29, PINB

	mov r28, r29 ;mhpws tuxon xreiastei
	
	;shift bit0
	lsr r28
	brcs plus_one ;an exw carry dhlash asso tote pros8etw ena sto sum dhladh ston register r27
	;shift bit1
	lsr r28
	brcs plus_one
	;shift bit2
	lsr r28
	brcs plus_one
	;shift bit3
	lsr r28
	brcs plus_one
	;shift bit4
	lsr r28
	brcs plus_one
	;shift bit5
	lsr r28
	brcs plus_one
	;shift bit6
	lsr r28
	brcs plus_one
	;shift bit7
	lsr r28
	brcs plus_one

;auksanei kata 1
plus_one:
	inc r27
	ret
;telos plus_one

;kanw AND me 0000 1111	
;set bit mask ston r16 gia na exw ari8mo mono sta 4 lsb, gia asfaleia , mporei k na mhn xreiazetai
	ldi r16, 0x0F
	and r27, r16 ;bitwise and. To apotelesma apo8hkeuetai ston r27

	out DDRC, r27 ;ta deixnw sta leds

	reti

;=========wait_msec===============
wait_msec:
	push r24
	push r25
	ldi r24, lo8(998)
	ldi r25, hi8(998)
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









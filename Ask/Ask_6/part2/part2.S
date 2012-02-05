/*
 * AVRAssembler2.asm
 *
 *  Created: 31/1/2012 7:58:21 ??
 *   Author: Eleni




 */ 

.org 0x00
	rjmp main
.org 0x04
	rjmp ISR1
	reti



main:
	ldi r30,low(RAMEND)
	out SPL, r30
	ldi r30, high(RAMEND)
	out SPH, r30

	;programma metrhshs opws dinetai
	ser r26
	out DDRA, r26
	clr r26
;=====gia energopoihsh ths INT1 =======

	ldi r24, (1<< ISC11)|(1 << ISC10) ;na prokaleitai me shma 8etikhs akmhs
	out MCUCR, r24
	ldi r24, (1<< INT1)
	out GICR, r24
	sei


loop:
	out PORTA, r26
	ldi r24, low(100)
	ldi r25, high(100)

	rcall wait_msec
	inc r26
	rjmp loop

;====routina eksuphrethshs diakophs=====

ISR1:
	push r26 ;swzei to periexomeno tou r26
	in r26, SREG ;kai SREG
	push r26

	clr r27 ;clear ton r27 giati ekei 8a mazepsw to sum mou

	clr r25
	out DDRB, r25 ;den eimai sigourh gia ton r25
	in r29, PINB

	mov r28, r29 ;mhpws tuxon xreiastei
	
bit0:
	lsr r28
	brcs plus_one_0 ;an exw carry dhlash asso tote pros8etw ena sto sum dhladh ston register r27
	
bit1:
	lsr r28
	brcs plus_one_1
bit2:
	lsr r28
	brcs plus_one_2
bit3:
	lsr r28
	brcs plus_one_3
bit4:
	lsr r28
	brcs plus_one_4
bit5:
	lsr r28
	brcs plus_one_5
bit6:
	lsr r28
	brcs plus_one_6
bit7:
	lsr r28
	brcs plus_one_7
	rjmp go_on

;auksanei kata 1
plus_one_0:
	inc r27
	rjmp bit1

plus_one_1:
	inc r27
	rjmp bit2

plus_one_2:
	inc r27
	rjmp bit3

plus_one_3:
	inc r27
	rjmp bit4

plus_one_4:
	inc r27
	rjmp bit4

plus_one_5:
	inc r27
	rjmp bit6

plus_one_6:
	inc r27
	rjmp bit7

plus_one_7:
	inc r27
	


;telos plus_one

;kanw AND me 0000 1111	
;set bit mask ston r16 gia na exw ari8mo mono sta 4 lsb, gia asfaleia , mporei k na mhn xreiazetai
go_on:
	ldi r16, 0x0F
	and r27, r16 ;bitwise and. To apotelesma apo8hkeuetai ston r27

	ser r29
	out PORTC, r29
	out DDRC, r27 ;ta deixnw sta leds

	reti

;=========wait_msec===============
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









/*
 * AVRAssembler1.asm
 *
 *  Created: 23/1/2012 10:02:18 ??
 *   Author: Eleni
 */ 

 ;.INCLUDE "m16def.inc"
#include <avr/io.h>
#define __SFR_OFFSET 0

.global main

main:
	ldi r24,lo8(RAMEND)
	out SPL,r24
	ldi r24,hi8(RAMEND)
	out SPH,r24

	ser r26			;arxikopoihsh ths PORTA ; ser = set register
	out DDRA, r26		;gia eksodo
	;arxikopoihsh gia eisodo:
	clr r25			;bazw mhdenika gia na exoume eisodo s ola ta bits
	out DDRB, r25		;giati 8elw apo ta B switches

flash:
	in r28, PINB		;diabazei kia ta grafei ston r28
	
	rcall on		;anapse ta LEDS
	rcall delay1  		;diabazw delay gia anamma
	rcall wait_msec


	rcall off		;sbhse ta LEDS
	rcall delay2		;diabazw delay gia sbhsimo
	rcall wait_msec

	rjmp flash		; do it again


;Yporoutina gia na anaboun ta leds

on: ser r26			;8ese thn 8ura eksodou twn LED
	out PORTA, r26
	ret			;gurise sto kurio programma

;Yporoutina gia na sbhnoun ta leds

off: clr r26			;mhdenise thn 8ura eksodou twn LED
	 out PORTA, r26
	 ret			;gurise sto kuriws programma

;===================== delay1 gia anamma================================

delay1:
	ldi r24, 0x0F
	and r24, r28     	;gia na parw ta lsbs
	ldi r23, 01		;gia na pros8esw 1
	add r24, r23
	ldi r23, 0x64		;gia na pollaplasiasw epi 100
	mul r24, r23		;kanw ton pollaplasiasmo k exw etoimh thn ka8usterhsh
						;ston diplo r0:r1
	mov r25, r1		;metaferw ta msbs ston r25 gia na ta parei wait_msec
	mov r24, r0		;metaferw ta lsbs ston r24 gia na ta parei wait_msec

	ret

;=====================delay2 gia sbhsimo================================

delay2:
	ldi r24, 0xF0
	and r24, r28		;gia na parw ta msbs
	lsr r24			;4 shift pros ta aristera gia na pane stis swstes 8eseis
	lsr r24
	lsr r24
	lsr r24


	ldi r23, 0x01		;gia na pros8esw 1
	add r24, r23
	ldi r23, 0x64		;gia na pollaplasiasw epi 100
	mul r24, r23		;kanw ton pollaplasiasmo k exw etoimh thn ka8usterhsh ston diplo r0:r1
	mov r25, r1		;metaferw ta msbs ston r25 gia na ta parei wait_msec
	mov r24, r0		;metaferw ta lsbs ston r24 gia na ta parei wait_msec

	ret

;==============wait_msec kai wait_usec (etoimh apo thn ekfwnhsh)======

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

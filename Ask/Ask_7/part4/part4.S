/*Includes for compatibility with GNU toolchain*/
#define __SFR_OFFSET 0
#include <avr/io.h>
#include <avr/interrupt.h>
.global main
/*
 * AVRAsk4.asm
 *
 *  Created: 12/2/2012 10:31:36 ??
 *   Author: Valia
 */ 
 .data
 _tmp_ :.byte 2

 .text
 #define temp1  r24
 #define temp2  r25

 main:
	rcall lcd_init ;//initialize

	ldi r24,0x045  ;//'T'
	rcall lcd_data
	ldi r24,0x05B  ;//'E'
	rcall lcd_data
	ldi r24,0x014  ;//'A'
	rcall lcd_data
	ldi r24,0x0b3  ;//'M'
	rcall lcd_data
	ldi r24,0x00c  ;//' '
	rcall lcd_data
	ldi r24,0x07c  ;//'0'
	rcall lcd_data
	ldi r24,0x073  ;//'7'
	rcall lcd_data

start:
	rcall scan_keypad_rising_edge ;//apotelesma sto r24:r25
	rcall keypad_to_ascii
	cpi r24,0
	breq start

	push r24
	ldi r24,0x01	 ;//freskarisma
	rcall lcd_command
	ldi r24,lo8(1530)
	ldi r25,hi8(1530)
	rcall wait_usec
	pop r24

	rcall lcd_data  ;//emfanish sthn o8onh

	ldi r26,lo8(_tmp_)  ;//ka8arisma mnhmhs
	ldi r27,hi8(_tmp_)
	ldi r24,0x0
	st  X+,r24
	st  X,r24

	rjmp start
	
keypad_to_ascii:
	movw r26,r24
	ldi r24,'*'
	sbrc r26,0
	ret
	ldi r24,'0'
	sbrc r26,1
	ret
	ldi r24,'#'
	sbrc r26,2
	ret
	ldi r24,'D'
	sbrc r26,3
	ret
	ldi r24,'7'
	sbrc r26,4
	ret
	ldi r24,'8'
	sbrc r26,5
	ret
	ldi r24,'9'
	sbrc r26,6
	ret
	ldi r24,'C'
	sbrc r26,7
	ret
	ldi r24,'4'
	sbrc r27,0
	ret
	ldi r24,'5'
	sbrc r27,1
	ret
	ldi r24,'6'
	sbrc r27,2
	ret
	ldi r24,'B'
	sbrc r27,3
	ret
	ldi r24,'1'
	sbrc r27,4
	ret
	ldi r24,'2'
	sbrc r27,5
	ret
	ldi r24,'3'
	sbrc r27,6
	ret
	ldi r24,'A'
	sbrc r27,7
	ret
	clr r24
	ret

	scan_keypad_rising_edge:
	mov r22,r24
	rcall scan_keypad

	push r24 ;//apo8ikeush apotelesmatos
	push r25
	mov r24,r22	;//ka8ysterhsh r22msec (10-20  msec)
	ldi r25,0
	rcall wait_msec
	
	rcall scan_keypad ;//aporrispe osa plhktra emfanizoyn spin8hrismo
	pop r23
	pop r22
	and r24,r22
	and r25,r23
	ldi r26,lo8(_tmp_)
	ldi r27,hi8(_tmp_)
	ld r23,X+
	ld r22,X
	st X,r24
	st -X,r25
	com r23
	com r22
	and r24,r22
	and r25,r22
	ret

lcd_init:
	ldi r24,40
	ldi r25,0
	;//rcall wait_msec

	ldi r24,0x30
	out PORTD,r24
	sbi PORTD,PD3
	cbi PORTD,PD3
	ldi r24,39
	ldi r25,0
	;//rcall wait_usec

	ldi r24,0x30
	out PORTD,r24
	sbi PORTD,PD3
	cbi PORTD,PD3
	ldi r24,39
	ldi r25,0
	;//rcall wait_usec

	ldi r24,0x20
	out PORTD,r24
	sbi PORTD,PD3
	cbi PORTD,PD3
	ldi r24,39
	ldi r25,0
	;//rcall wait_usec

	ldi r24,0x28
	rcall lcd_command

	ldi r24,0x0c
	rcall lcd_command

	ldi r24,0x01
	rcall lcd_command
	ldi r24,lo8(1530)
	ldi r25,hi8(1530)
	;//rcall wait_usec

	ldi r24,0x06
	rcall lcd_command

	ret

lcd_data:
	sbi PORTD,PD2
	rcall write_2_nibbles
	ldi r24,43
	ldi r25,0
	;//rcall wait_usec
	ret

lcd_command:
	cbi PORTD,PD2
	rcall write_2_nibbles
	ldi r24,39
	ldi r25,0
	;//rcall wait_usec
	ret

write_2_nibbles:
	push r24
	in r25,PIND
	andi r25,0x0f
	andi r24,0xf0
	add r24,r25
	out PORTD,r24
	sbi PORTD,PD3
	cbi PORTD,PD3
	pop r24
	swap r24
	andi r24,0xf0
	add r24,r25
	out PORTD,r24
	sbi PORTD,PD3
	cbi PORTD,PD3
	ret

 scan_keypad:
	ldi r24,0x01
	rcall scan_row
	swap r24
	mov r27,r24
	ldi r24,0x02
	rcall scan_row
	add r27,r24		;//1h kai 2h grammh
	ldi r24,0x03
	rcall scan_row
	swap r24
	mov r26,r24		
	ldi r24,0x04
	rcall scan_row
	add r26,r24		;//3h kai 4h grammh
	movw r24,r26	;//r25:r24 to apotelesma
	ret

scan_row:
	ldi r25,0x08
back_:
	lsl r25
	dec r24	
	brne back_
	out PORTC,r25
	nop
	nop
	in r24,PINC
	andi r24,0x0f
	ret

	wait_msec:
	push temp1
	push temp2
	ldi temp1, lo8(998)
	ldi temp2, hi8(998)
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
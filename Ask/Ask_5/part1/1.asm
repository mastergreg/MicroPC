.include "m16def.inc"

reset: 
		ldi r24,low(RAMEND)
		out SPL,r24
		ldi r24,high(RAMEND)
		out SPH,r24
		ser r24
		out DDRA,r24
		clr r26

main:
		out PORTA, r26
		ldi r24,low(500)
		ldi r25,high(500)
		

		rcall wait_msec
		inc r26
		cpi r26,128
		brlo main
		clr r26
		rjmp main



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
		

/*Includes for compatibility with GNU toolchain*/
#define __SFR_OFFSET 0
#include <avr/io.h>
#include <avr/interrupt.h>
.global main
/*
 * AVRAssembler3_a.asm
 *
 *  Created: 14/2/2012 1:23:46 ??
 *   Author: Eleni
 */ 
 /*
 * AVRAssembler3.asm
 *
 *  Created: 13/2/2012 9:07:06 ??
 *   Author: Eleni
 */ 

/*
 * bonus_part_2.asm
 *
 *  Created: 12/2/2012 1:08:30 ??
 *   Author: Eleni
 */

#define input  r18
#define sign  r21
#define tempo  r20
#define ekat  r22
#define dek  r23
#define mon  r19
#define quantum  r24

main:

    ldi r24 ,lo8(RAMEND)
    out SPL, r24
    ldi r24, hi8(RAMEND)
	out SPL, r24

    clr r25             ;//bazw mhdenika gia eisodo sthn A
    out DDRA, r25
    
    ser r25				;//bazw 1 gia eksodo sthn D
    out DDRD, r25

	rcall lcd_init

start:
    in input, PINA
    mov tempo, input
    lsl tempo
    brcc positive		;//an carry = 0 pame sto positive

negative:				;//edw einai arnhtikos o ari8mos
    ;// bazw to arnhtiko proshmo
    ldi sign, '-'
    neg input			;//to neg dinei kateu8eian to sumplhrwma ws pros 2
    rjmp calculation
    
positive:
    ;//an einai 8etikos bazw to + kai proxwrw sto calculation gia display
    ldi sign, '+'
    
calculation:
    clr ekat
    clr dek
    clr mon

    cpi input, 0x64		;//sugkrish me to 100
    brlo count_dek		;//branch if less sto metrhma dekadwn
    
    ;//alliws exoume 1 ekatontada
count_ekat:
    ldi ekat, 1			;//giati mia ekatontada to polu 8a exoume
    subi input, 0x64	;//afairw 100 epeidh 8elw na sunexisw

count_dek:
    cpi input, 10		;//sugkrish me to 10
    brlo count_mon		;//an einai mikrotero tou 10 metrame tis monades
    ;//alliws
    subi input, 10		;//afairw 10
    inc dek
	rjmp count_dek

    ;//edw ston input exoun meinei pleon oi monades
count_mon: 
    mov mon, input
    rjmp print_to_lcd

print_to_lcd:
	;//tupwnw to proshmo
    mov quantum, sign
    rcall lcd_data 

    ;//elegxos gia an exw ekatontada
    cpi ekat, 1
    brlo check_dekades	;//an <100 koitaw mhpws einai kai dekades0
    subi ekat, -48		;//pros8etw 48 gia na parw ton ascii
    mov quantum, ekat
    rcall lcd_data

check_dekades:
    cpi dek, 0
    breq check_monades	;//an einai iso me 0
    subi dek, -48		;//alliws.
    mov quantum, dek
    rcall lcd_data

check_monades:
    subi mon, -48
    mov quantum, mon	;//oi monades o,ti kai na nai tis deixnw, giati exw sumplhrwma ws pros 2. Opote 8a deiksw gia 0 to +0.
    rcall lcd_data
    

	rjmp start


;//=======routines gia thn o8onh=========

;//_______WRITE_2_NIBBLES______
write_2_nibbles:
    push r24
    in r25, PIND
    andi r25, 0x0f
    andi r24, 0xf0
    add r24, r25
    out PORTD, r24
    sbi PORTD, PD3
    cbi PORTD, PD3
    pop r24
    swap r24
    andi r24 ,0xf0 
    add r24, r25
    out PORTD, r24
    sbi PORTD, PD3
    cbi PORTD, PD3
	
	ret 
;//________LCD_DATA________
lcd_data:
    sbi PORTD, PD2
    ;//ldi r25, 0x04
	rcall write_2_nibbles
    ldi r24, 43
    ldi r25, 0
 ;//   rcall wait_usec
    ret
;//_______LCD_COMMAND______
lcd_command:
    cbi PORTD, PD2
    rcall write_2_nibbles
    ldi r24, 39 ;//gia anamonh 39 usec
    ldi r25,0
;//    rcall wait_usec
    ret
;//_______LCD_INIT________
lcd_init:
    ldi r24, 40
    ldi r25, 0
 ;//   rcall wait_msec
    
    ldi r24, 0x30
    out PORTD, r24
    sbi PORTD, PD3
    cbi PORTD, PD3
    ldi r24, 39
    ldi r25, 0
;//    rcall wait_usec

    ldi r24, 0x30
    out PORTD, r24
    sbi PORTD, PD3
    cbi PORTD, PD3
    ldi r24, 39
    ldi r25,0
 ;//   rcall wait_usec

    ldi r24, 0x20
    out PORTD, r24
    sbi PORTD, PD3
    cbi PORTD, PD3
    ldi r24, 39
    ldi r25, 0
 ;//   rcall wait_usec

    ldi r24, 0x28
    rcall lcd_command

    ldi r24, 0x0c
    rcall lcd_command
    
    ldi r24, 0x01
    rcall lcd_command
    ldi r24, lo8(1530)
    ldi r25, hi8(1530)
 ;//   rcall wait_usec

    ldi r24, 0x06
    rcall lcd_command

    ret

;//=========wait routines==========

wait_usec:
    sbiw r24, 1
    nop
    nop
    nop
    nop
    brne wait_usec
    ret

wait_msec:
    push r24
    push r24
    ldi r24, lo8(998)
    ldi r25, hi8(998)
    rcall wait_usec
    pop r24
    pop r25
    sbiw r24, 1
    brne wait_msec
    ret




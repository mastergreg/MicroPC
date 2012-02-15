/*Includes for compatibility with GNU toolchain*/
#define __SFR_OFFSET 0
#include <avr/io.h>
#include <avr/interrupt.h>
.global main
/*
 * AVR_3h_ask1.asm
 *
 *  Created: 10/2/2012 10:01:52 ??
 *   Author: Valia
 */ 


 /*
 * AVR_ask1.asm
 *
 *  Created: 10/2/2012 9:24:48 ??
 *   Author: Valia
 */ 

#define temp1  r24
#define input  r28
#define output  r27
#define temp2  r25
#define regC  r29
#define tempo  r26
#define output1  r30

main:
    ldi temp1, hi8(RAMEND)
    out SPH, temp1
    ldi temp1, lo8(RAMEND)
    out SPL, temp1

    ser temp1
    out DDRB, temp1

    clr temp1
    out DDRA, temp1

    clr regC
    out DDRC, regC
start:
    clr output1
    in regC, PINC

    lsr regC
    brcc syn1
etik1:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsr tempo
    brcs etik1    
    ori output1, 1

syn1:
    lsr regC
    brcc syn2
etik2:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsr tempo
    lsr tempo
    brcs etik2
    ori output1, 2

syn2:
    lsr regC
    brcc syn3
etik3:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsr tempo
    lsr tempo
    lsr tempo
    brcs etik3
    ori output1, 4
 
 syn3:
    lsr regC
    brcc syn4
etik4:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsr tempo
    lsr tempo
    lsr tempo
    lsr tempo
    brcs etik4
    ori output1, 8

 syn4:
    lsr regC
    brcc syn5
etik5:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsl tempo
    lsl tempo
    lsl tempo
    lsl tempo
    brcs etik5
    ori output1, 0x010

syn5:
    lsr regC
    brcc syn6
etik6:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsl tempo
    lsl tempo
    lsl tempo
    brcs etik6
    ori output1, 0x020
 
 syn6:
    lsr regC
    brcc syn7
 etik7:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsl tempo
    lsl tempo
    brcs etik7
    ori output1, 0x040

syn7:
    lsr regC
    brcc synexise
 etik8:      ;//perimenei mexri na ginei 0 (button)
    in tempo, PINC
    lsl tempo
    brcs etik8 
    ori output1, 0x080

 synexise:

    in input, PINA  
    clr temp2   ;//mhdenismos exodwn
    clr output

gate_1:
    lsr input
    brcc exit1_gate1  ;//an to lsb = 0 feugoume
    lsr input
    brcc exit_gate1  ;//an to 2o lsb = 0 feugoume
    inc temp2
	rjmp exit_gate1

exit1_gate1:
	lsr input;//dior8wsh
exit_gate1:
    
gate_2:
    lsr input
    brcc exit1_gate2 ;//an to 3o lsb = 0 feugoume
    lsr input
    brcc exit_gate2  ;//an to 4o lsb = 0 feugoume
    ori output, 2
	rjmp exit_gate2
exit1_gate2:
	lsr input 
exit_gate2:
    or output, temp2    ;//exodos sta 2 prwta lsb bit

gate_3:
    lsr input
    brcs exit1_gate3 ;//an to 5o lsb = 1 feugoume
    lsr input
    brcs exit_gate3 ;//an to 6o lsb = 1 feugoume
    ori output, 4  ;// or me 100
	rjmp exit_gate3
exit1_gate3:
	lsr input 
exit_gate3:
    
gate_4:
    lsr input
    brcs  one   ;//an einai 1 psaxnoumt an kai to allo einai 1
    lsr input   ;//an einai to 1o 0, tsekaroyme an kai to 2o einai 0
    brcs exit_gate4
    rjmp setting

one:
    lsr input
    brcc exit_gate4 ;// an to allo einai 0 feugoyme
 
setting:
    ori output,8

exit_gate4:
   eor output, output1  ;//xor 
   out PORTB, output
   rjmp start 



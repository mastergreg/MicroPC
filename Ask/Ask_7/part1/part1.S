/*Includes for compatibility with GNU toolchain*/
#include <avr/io.h>
#include <avr/interrupt.h>
#define __SFR_OFFSET 0
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

//.def r24 = r24
//.def r28 = r28
//.def r27 = r27
//.def r25 = r25
//.def r29 = r29
//.def r26 = r26
//.def r30 = r30

main:
    ldi r24, hi8(RAMEND)
    out SPH, r24
    ldi r24, lo8(RAMEND)
    out SPL, r24

    ser r24
    out DDRB, r24

    clr r24
    out DDRA, r24

    clr r29
    out DDRC, r29
start:
    clr r30
    in r29, PINC
    lsr r29
    brcc syn1
etik1:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsr r26
    brcs etik1    
    ori r30, 1

syn1:
    lsr r29
    brcc syn2
etik2:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsr r26
    lsr r26
    brcs etik2
    ori r30, 2

syn2:
    lsr r29
    brcc syn3
etik3:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsr r26
    lsr r26
    lsr r26
    brcs etik3
    ori r30, 4
 
 syn3:
    lsr r29
    brcc syn4
etik4:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsr r26
    lsr r26
    lsr r26
    lsr r26
    brcs etik4
    ori r30, 8

 syn4:
    lsr r29
    brcc syn5
etik5:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsl r26
    lsl r26
    lsl r26
    lsl r26
    brcs etik5
    ori r30, 0x010

syn5:
    lsr r29
    brcc syn6
etik6:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsl r26
    lsl r26
    lsl r26
    brcs etik6
    ori r30, 0x020
 
 syn6:
    lsr r29
    brcc syn7
 etik7:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsl r26
    lsl r26
    brcs etik7
    ori r30, 0x040

syn7:
    lsr r29
    brcc synexise
 etik8:      //perimenei mexri na ginei 0 (button)
    in r26, PINC
    lsl r26
    brcs etik8 
    ori r30, 0x080

 synexise:

    in r28, PINA  
    clr r25   //mhdenismos exodwn
    clr r27

gate_1:
    lsr r28
    brcc exit_gate1  //an to lsb == 0 feugoume
    lsr r28
    brcc exit_gate1  //an to 2o lsb == 0 feugoume
    inc r25

exit_gate1:
    
gate_2:
    lsr r28
    brcc exit_gate2 //an to 3o lsb == 0 feugoume
    lsr r28
    brcc exit_gate2  //an to 4o lsb == 0 feugoume
    ori r27, 2
 
exit_gate2:
    or r27, r25    //exodos sta 2 prwta lsb bit

gate_3:
    lsr r28
    brcs exit_gate3 //an to 5o lsb == 1 feugoume
    lsr r28
    brcs exit_gate3 //an to 6o lsb == 1 feugoume
    ori r27, 4  // or me 100
 
exit_gate3:
    
gate_4:
    lsr r28
    brcs  one   //an einai 1 psaxnoumt an kai to allo einai 0
    lsr r28   //an einai to 1o 0, tsekaroyme an kai to 2o einai 1
    brcc exit_gate4
    rjmp setting

one:
    lsr r28
    brcs exit_gate4 // an to allo einai 0 feugoyme
 
setting:
    ori r27,8

exit_gate4:
   eor r27, r30  //xor 
   out PORTB, r27
   rjmp start 



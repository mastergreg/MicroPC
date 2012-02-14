#define __SFR_OFFSET 0
#include <avr/io.h>

.data
    _tmp_: .byte 2
.text
.global main
main:
reset: 
    ldi r24,lo8(RAMEND)
    out SPL,r24
    ldi r24,hi8(RAMEND)
    out SPH,r24
    ser r24
    out DDRA,r24
    ;// PORTA output
    ldi r24 ,(1 << PC7) | (1 << PC6) | (1 << PC5) | (1 << PC4)
    out DDRC ,r24
    ;// 4x4 pad input
    rcall scan_keypad_rising_edge
    ;// initialize 
lock:
    ;//reset the memory
    ldi r24,0x00
    ldi r25,0x00
    ldi r26 ,lo8(_tmp_)
    ldi r27 ,hi8(_tmp_)
    st X+ ,r24
    st X ,r25
first_key:
    ldi r24, 0x14
    rcall scan_keypad_rising_edge
    cpi r24,0x00
    breq first_key
    cpi r24, 0x02
    ;//first test failed
    brne lock
second_key:
    ldi r24, 0x14
    rcall scan_keypad_rising_edge
    ;//second test failed
    cpi r24,0x02
    breq second_key
    cpi r24, 0x12
    brne lock
    rjmp pass

pass:
    ldi r24,0xff
    out PORTA, r24
    ldi r24,lo8(2000)
    ldi r25,hi8(2000)
    rcall wait_msec
    ;//reset the leds
    ldi r24,0x00
    out PORTA, r24
    rjmp lock
    

scan_row:
    ldi r25 ,0x08
back_: lsl r25
    dec r24
    brne back_
    out PORTC ,r25
    nop
    nop
    in r24 ,PINC
    andi r24 ,0x0f
    ret



scan_keypad:
    ldi r24 ,0x01
    rcall scan_row
    swap r24
    mov r27 ,r24
    ldi r24 ,0x02
    rcall scan_row
    add r27 ,r24
    ldi r24 ,0x03
    rcall scan_row
    swap r24
    mov r26 ,r24
    ldi r24 ,0x04
    rcall scan_row
    add r26 ,r24
    movw r24 ,r26
    ret


scan_keypad_rising_edge:
    mov r22 ,r24
    rcall scan_keypad
    push r24
    push r25
    mov r24 ,r22
    ldi r25 ,0
    rcall wait_msec
    rcall scan_keypad
    pop r23
    pop r22
    and r24 ,r22
    and r25 ,r23
    ldi r26 ,lo8(_tmp_)
    ldi r27 ,hi8(_tmp_)
    ld r23 ,X+
    ld r22 ,X
    st X ,r24
    st -X ,r25
    com r23
    com r22
    and r24 ,r22
    and r25 ,r23
    ret



wait_usec:
    sbiw r24,1
    nop
    brne wait_usec
    ret

wait_msec:
    in r27,PINB
    ror r27
    brcs wait_msec
    push r24
    push r25
    ldi r24,lo8(998)
    ldi r25,hi8(998)
    rcall wait_usec
    pop r25
    pop r24
    sbiw r24,1
    brne wait_msec
    ret

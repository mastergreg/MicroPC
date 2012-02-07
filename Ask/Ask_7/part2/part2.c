/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : part2.c

* Purpose :

* Creation Date : 07-02-2012

* Last Modified : Tue 07 Feb 2012 09:24:39 PM EET

* Created By : Greg Liras <gregliras@gmail.com>

_._._._._._._._._._._._._._._._._._._._._.*/


#include<avr/io.h>

int f0 ( int c )
{
    int i;
    for( i = 0 ; i < 4 ; ++i, c <<=1 )
    {
        if ( ( c & 3 ) == 3 )
            return 0;
    }
    return 1;
}
int f1 ( int c )
{
    c &=31;
    return  c <= 15 || c == 31;
}
int f2 ( int c )
{
    return f0(c) || f1(c);
}
int main(void)
{
    DDRA = 0xff;
    DDRC = 0x00;
    for( ;; )
        PORTA = f0(PINC) | (f1(PINC) << 1) | (f2(PINC) << 2);
}

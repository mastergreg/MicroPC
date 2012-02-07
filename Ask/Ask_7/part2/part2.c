/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : part2.c

* Purpose :

* Creation Date : 07-02-2012

* Last Modified : Tue 07 Feb 2012 09:02:31 PM EET

* Created By : Greg Liras <gregliras@gmail.com>

_._._._._._._._._._._._._._._._._._._._._.*/


#include<avr/io.h>

int f0 ( int c )
{
    int i;
    for( i = 0 ; i < 4 ; ++i )
    {
        if ( ( ( c << i ) & 3 ) == 3 )
            return 1;
    }
    return 0;
}

int f1 ( int c )
{
    return (c & 31) != 31;
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

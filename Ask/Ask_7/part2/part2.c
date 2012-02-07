/* -.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.

* File Name : part2.c

* Purpose :

* Creation Date : 07-02-2012

* Last Modified : Wed 08 Feb 2012 12:09:50 AM EET

* Created By : Greg Liras <gregliras@gmail.com>

_._._._._._._._._._._._._._._._._._._._._.*/


#include<avr/io.h>

int f0 ( int c )
{
    for( ; c > 0 ; c >>=1 )
        if ( ( c & 3 ) == 3 )
            return 0;
    return 1;
}
int f1 ( int c )
{
    if (  c <= 15 || c == 31 )
        return 1;
    return 0;
}
int main(void)
{
    DDRA = 0xff;
    DDRC = 0x00;
    int f_0;
    int f_1;
    int c;
    for( ;; )
    {
        c = PINC & 31;
        f_0 = f0( c );
        f_1 = f1( c );
        PORTA = f_0 | ( f_1 << 1) | ( ( f_0 | f_1 ) << 2);
    }
}

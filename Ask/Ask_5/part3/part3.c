/*
 * part3.c
 *
 * Created: 22/1/2012 7:55:21 μμ
 *  Author: Valia
 */ 

#include <avr/io.h>

int main(void)
{
   //while(1)
    //{
        //TODO:: Please write your application code 
		DDRB = 0xff; //output
		DDRD = 0x00; //input
		PORTB =0x01;
		while(1){
			if ((PIND & 1) == 0x01){
				while (((PIND & 1) != 0x00) && (PIND  <= 0x01 )) ;	//perimenei mexri na ginei 0 h feugei an energopoih8ei 
					if ((PIND & 1) == 0x00){						//button ypsiloterhs proteraiothtas
						if ((PORTB << 1) == 0x100) PORTB = 0x01; 
							else PORTB = PORTB << 1;
					}							
			}
									
			if ((PIND & 2) == 0x02){
 				while (((PIND & 2) != 0x00) && (PIND <= 0x03 )) ;	//perimenei
					if ((PIND & 2) == 0x00){
						if ((PORTB >> 1) == 0)
							PORTB = 0x80;   //128 dec 
						else PORTB = PORTB >> 1; 
					}						
			}
									
			if ((PIND & 4) == 0x04){
				while (((PIND & 4) != 0x00) && (PIND <= 0x07 )) ;	//perimenei
					if ((PIND & 4) == 0x00){
						if ((PORTB << 1) == 0x100) 
							PORTB = 0x02;		//dior8wseis
					    else if ((PORTB << 2) == 0x100) PORTB = 0x01; 
						else PORTB = PORTB << 2;
					}
			}
														
			if ((PIND & 8) == 0x08){
				while (((PIND & 8) != 0x00) && (PIND <= 0x0F )) ;	//perimenei
					if ((PIND & 8) == 0){
						if ((PORTB >> 1) == 0)
							PORTB = 0x40;
						else if ((PORTB >> 2) == 0) 
							PORTB = 0x80;
						else PORTB = PORTB >> 2;	//dior8wseis
					}
			}
													
			if ((PIND & 16) == 16){
				while ((PIND & 16)!= 0x00) ;		//perimenei
						PORTB = 0x01;
				}			
    }
return 0;
}

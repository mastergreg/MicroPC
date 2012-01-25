/*
 * ask5_3.c
 *
 * Created: 19/1/2012 11:42:49 рм
 *  Author: Valia
 */ 

#include <avr/io.h>

int main(void)
{
    //while(1)
    //{
        //TODO:: Please write your application code 
		DDRA = 0xff; //output
		DDRD = 0x00; //input
		PORTA =0x01;
		while(1){
			if ((PIND & 1) == 0x01){
				while (((PIND & 1) != 0x00) && (PIND  <= 0x01 )) ;	//perimene
					if ((PIND & 1) == 0x00){ 
						if ((PORTA << 1) == 0x100) PORTA = 0x01; 
							else PORTA = PORTA << 1;
					}							
			}
									
			if ((PIND & 2) == 0x02){
 				while (((PIND & 2) != 0x00) && (PIND <= 0x03 )) ;	//perimene
					if ((PIND & 2) == 0x00){
						if ((PORTA >> 1) == 0)
							PORTA = 0x80;   //128 dec 
						else PORTA = PORTA >> 1; 
					}						
			}
									
			if ((PIND & 4) == 0x04){
				while (((PIND & 4) != 0x00) && (PIND <= 0x07 )) ;	//perimene
					if ((PIND & 4) == 0x00){
						if ((PORTA << 1) == 0x100) 
							PORTA = 0x02;		//dior8wseis
					    else if ((PORTA << 2) == 0x100) PORTA = 0x01; 
						else PORTA = PORTA << 2;
					}
			}
														
			if ((PIND & 8) == 0x08){
				while (((PIND & 8) != 0x00) && (PIND <= 0x0F )) ;	//perimene
					if ((PIND & 8) == 0){
						if ((PORTA >> 1) == 0)
							PORTA = 0x40;
						else if ((PORTA >> 2) == 0) 
							PORTA = 0x80;
						else PORTA = PORTA >> 2;	//dior8wseis
					}
			}
													
			if ((PIND & 16) == 16){
				while ((PIND & 16)!= 0x00) ;		//perimene
						PORTA = 0x01;
				}			
    }
return 0;
}
			

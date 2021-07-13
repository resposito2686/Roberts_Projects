/*
 * Lab3.c
 *
 * Created: 6/7/2019 8:53:06 AM
 * Author : Robert
 */ 

#define F_CPU 16000000UL
#define BAUD 9600
#define MYUBRR F_CPU/16/BAUD-1
#include <avr/io.h>
#include <util/delay.h>

void usart_init(unsigned int ubrr);
void usart_transmit(unsigned char data);
unsigned char usart_recieve();

void main(void)
{
	
	usart_init(MYUBRR);
	DDRD = 0b11111111;     //sets register D as output.
	DDRB = 0b00000000;     //sets register B as input.
	PORTB = 0b11111111;    //sets B to pull-up mode.
	
	unsigned char keypadTable[4][4] = {
		{'1', '2', '3', 'A'},
		{'4', '5', '6', 'B'},
		{'7', '8', '9', 'C'},
		{'*', '0', '#', 'D'},
	};
	
	while(1)
	{
		PORTD = 0b11111111;                         //sets the rows to high.
		
		for (int i = 0; i < 4; i++)                 //loops through the rows.
		{
			PORTD &= ~(1 << (i+4));                 //sets current row to low.
			
			for (int j = 0; j < 4; j++)             //loops through columns.
			{
				if (!(PINB & (1 << j)))             //checks if a button was pressed.
				{
					usart_transmit(keypadTable[i][j]);
					_delay_ms(150);
				}
			}
			
			PORTD |= (1 << (i+4));                     //sets current row back to high.
		}
	}
}

void usart_init(unsigned int ubrr)
{
	UBRR0H &= 0;
	UBRR0L = (unsigned char) ubrr;
	UCSR0B |= (1<<TXEN0) | (1<<RXEN0);
	UCSR0C |= (1<<UCSZ00) | (1<<UCSZ01);
}

void usart_transmit(unsigned char data)
{
	while (!(UCSR0A & (1 << UDRE0)));
	UDR0 = data;
}

unsigned char usart_recieve()
{
	while (!(UCSR0A & (1<<RXC0)));
	return UDR0;
}




/*
 * Lab5.c
 *
 * Created: 6/17/2019 9:44:35 AM
 * Author : Robert
 */ 
#define F_CPU 16000000UL
#define MICROSECOND_SCALER 1000000
#define POWER_CONSTANT 1.059463094
#define PRE_SCALING 0.000016
#include <avr/io.h>
#include <util/delay.h>
#include <math.h>


void delay(int a)
{
	for (int i = 0; i < a; i++)
	{
		_delay_us(1);
	}
}

void outputToneDelay(int a)                              //outputs the tones using the delay() function.
{
	double rawPeriod = 1/(440*(pow(POWER_CONSTANT,a)));  //calculate the period of the given note
	double rawTimeOn = (rawPeriod/2)*MICROSECOND_SCALER; //scale the period to microseconds and divide it by 2 (50% duty cycle).
	int timeOn = truncf(rawTimeOn);                      //truncate double so its a whole number.
	
	PORTC |= (1<<PORTC5);
	delay(timeOn);
	PORTC &= ~(1<<PORTC5);
	delay(timeOn);
}

void outputToneTimer(int a)                              //outputs the tones using a timer.
{
	TCCR0A |= (1<<WGM01);                                //sets timer to CTC mode
	double rawTime = 1/(440*(pow(POWER_CONSTANT, a)));   //calculates the period of the given note
	double rawTimerCount = rawTime/PRE_SCALING;          //calculates the value for CTC compare
	int timerCount = trunc(rawTimerCount) - 1;           //truncates and subtracts 1 from raw count
	OCR0A = timerCount;                                  
	OCR0B = timerCount/2;
	
	TCCR0B |= (1<<CS02);                                 //pre-scaling 256 and start timer.
	
	while ((TIFR0 & (1<<OCF0B)) == 0){}
	TIFR0  |= (1<<OCF0B);
	PORTC |= (1<<PORTC5);
	
	while ((TIFR0 & (1<<OCF0A)) == 0){}
	TIFR0 |= (1<<OCF0A);
	PORTC &= ~(1<<PORTC5);
	
}
int main(void)
{
	DDRD = 0b11111111;     //sets register D as output.
	DDRB = 0b00000000;     //sets register B as input.
	PORTB = 0b11111111;    //sets B to pull-up mode.
	DDRC |= (1<<DDRC5);    //sets pin C5 to an output.
	
	int keypadTable[4][4] = {
		{0, 1, 2, 3},
		{4, 5, 6, 7},
		{8, 9, 10, 11},
		{12, 13, 14, 15},
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
					//outputToneDelay(keypadTable[i][j]);
					outputToneTimer(keypadTable[i][j]);
				}
			}
			
			PORTD |= (1 << (i+4));                     //sets current row back to high.
		}
	}
}




/*
 * Lab7.c
 *
 * Created: 7/1/2019 8:58:53 AM
 * Author : Robert
 */

#define F_CPU 16000000UL
#define BAUD 9600
#define MYUBRR F_CPU/16/BAUD-1
#include <avr/io.h>
#include <avr/interrupt.h>

void adc_init();
void adc_read();
void timer_esposito1();
void timer_esposito2();
volatile uint16_t adcValue;

ISR(ADC_vect)
{
	adcValue = ((ADC/1023.0)*124);
	OCR2B = adcValue;
	PINC ^= (1<<PINC5);
}
ISR(TIMER2_COMPA_vect)
{

	PORTB |= (1<<PORTB5);
}

ISR(TIMER2_COMPB_vect)
{
	if (OCR2B < 90)
	{
		PORTB &= ~(1<<PORTB5);	
	}
}

int main(void)
{
	cli();
	adc_init();
	DDRB |= (1<<DDRB5);
	timer_esposito1();
	timer_esposito2();
	sei();                                                          //enable global interrupts.
	
    while (1) {}
}

void adc_init()
{
	DDRC &= ~(1<<DDRC5);                             //sets portc5 to an input
	ADMUX |= (1<<REFS0) | (1<<MUX0) | (1<<MUX2);     //sets the analog channel to c5.
	ADCSRA |= (1 << ADEN) | (1<<ADATE)               //enable ADC and ADC auto trigger
	       | (1<<ADIE)                               //enable ADC interrupt
		   | (1<<ADPS0) | (1 << ADPS1);              //ADC pre-scale of 8
	ADCSRB |= (1 << ADTS1) | (1 << ADTS0);           //enable compare match A with timer 0
}

void adc_read()
{
	ADCSRA |= (1<<ADSC) | (1<<ADIF);
}

void timer_esposito1()
{
	TCCR0A |= (1<<WGM01);                                           //sets timer0 to CTC mode
	OCR0A = 155;                                                    //timer set for 10ms (9+1)ms.
	TIMSK0 |= (1<<OCIE0A);                                          //enables compare match interrupt for OCR0A.
	TCCR0B |= (1<<CS02) | (1<CS00);                                 //prescale of 1024 and start timer.
}
void timer_esposito2()
{
	TCCR2A |= (1<<WGM21);                                          //sets timer2 to CTC mode.
	OCR2A = 124;                                                   //timer set for 2ms (1/((4+1)*100Hz)).
	TCCR2B |= (1<<CS22);                                           //prescale of 256 and start timer.
	TIMSK2 |= (1<<OCIE2A) | (1<<OCIE2B);                           //enable compare match interrupts for OCR2A and OCR2B.
}




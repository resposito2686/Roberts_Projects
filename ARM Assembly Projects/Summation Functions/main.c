#include <stdio.h>
#include "Hw5function.h"

int main() 
{ 
	
	int N1, N2;
	int sum;
	
	// Sample input value (It may be tested with other input values)
	// Do not hard code these values inside the function
	N1 = 100; 
	N2 = 230; 

	sum = sumofFirstNNumbers(N1); 
	printf("\nThe sum of first %d numbers is %d \n", N1, sum);
	
	
	sum = sumofEvenNumbers(N1,N2);
	printf("\nThe sum of even numbers between %d and  %d  is %d \n", N1, N2, sum);
	
	return 0;
}

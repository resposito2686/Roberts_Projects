#include <stdio.h>
#include <time.h>

unsigned long long sumFunc(unsigned long n) {

	unsigned long long sum = 0;
	
	for (unsigned long i = 1; i <= n; i++) {
		sum += i;
	}
	
	return sum;
}

void printSumAndTime(unsigned long n, unsigned long long sum, double timeTaken) {

	printf("\nWhen N is %lu, the sum is: %llu", n, sum);
	printf("\nTime taken: %f seconds", timeTaken);
}

int main() {

	unsigned long n;
	unsigned long long sum;
	double timeTaken;
	time_t start, end;
	
	n = 100000000;
	time(&start);
	sum = sumFunc(n);
	time(&end);
	timeTaken = (double)(end-start);
	printSumAndTime(n, sum, timeTaken);
	
	n = 1000000000;
	time(&start);
	sum = sumFunc(n);
	time(&end);
	timeTaken = (double)(end-start);
	printSumAndTime(n, sum, timeTaken);
	
	n = 10000000000;
	time(&start);
	sum = sumFunc(n);
	time(&end);
	timeTaken = (double)(end-start);
	printSumAndTime(n, sum, timeTaken);
	
	return 0;
}

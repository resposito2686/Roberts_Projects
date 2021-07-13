#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <pthread.h>

const int NUM_THREADS = 8;
const unsigned long N = 10000000000;

void* sumFunc(void* index) {
	
	unsigned long long* sum = (unsigned long long*)malloc(sizeof(unsigned long long));
	*sum = 0;
	
	unsigned long i = *(unsigned long*)index;
	unsigned long loopEnd = i + (N/NUM_THREADS);
	
	for (i; i < loopEnd; i++) {
		*sum += i;
	}
	
	pthread_exit((void*)sum);
}
int main() {
	
	unsigned long index[(NUM_THREADS-1)];
	unsigned long long* sumArr[(NUM_THREADS-1)];
	pthread_t threadID[(NUM_THREADS-1)];
	time_t start, end;
	unsigned long long totalSum = 0;
	
	time(&start);
	for (int i = 0; i < NUM_THREADS; i++) {
		index[i] = 1 + (N*i)/NUM_THREADS;
	}
	
	for (int i = 0; i < NUM_THREADS; i++) {
		pthread_create(&threadID[i], NULL, sumFunc, (void*)&index[i]);
	}
	
	for (int i = 0; i < NUM_THREADS; i++) {
		pthread_join(threadID[i], (void**)&sumArr[i]);
	}
	
	for (int i = 0; i < NUM_THREADS; i++) {
		totalSum += *sumArr[i];
	}
	time(&end);
	
	double timeTaken = (double)(end-start);
	printf("\nThe sum is: %llu", totalSum);
	printf("\nTime taken: %f seconds\n", timeTaken);
	pthread_exit(NULL);

	return 0;
}

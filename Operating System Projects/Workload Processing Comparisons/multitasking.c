#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <time.h>

const int NUM_TASKS = 2;
const unsigned long N = 100000000;

unsigned long long sumTwoTasks() {
	
	int fd[2];
	unsigned long long sum = 0;
	unsigned long long sumC = 0;
	unsigned long long sumP = 0;
	
	pipe(fd);
	
	pid_t pid = fork();
	
	if (pid == 0) {
		close(fd[0]);
		for (unsigned long i = 1; i <= (N/NUM_TASKS); i++) {
			sumC += i;
		}
		write(fd[1], &sumC, sizeof(sumC));
		exit(0);
	}
	else if (pid > 0) {
		close(fd[1]);
		for (unsigned long i = (N/NUM_TASKS)+1; i <= N; i++) {
			sumP += i;
		}
		read(fd[0], &sumC, sizeof(sumC));
		sum = sumP + sumC;
	}
	
	return sum;
}

unsigned long long sumFourTasks() {

	int fd1[2], fd2[2], fd3[2];
	unsigned long sumIndex[(NUM_TASKS)-1];
	unsigned long long sum = 0;
	unsigned long long sumPP = 0;
	unsigned long long sumPC = 0;
	unsigned long long sumCP = 0;
	unsigned long long sumCC = 0;
	
	pipe(fd1);
	pipe(fd2);
	pipe(fd3);
	
	pid_t pid[2];
	
	for (int i = 0; i < (NUM_TASKS-1); i++) {
		sumIndex[i] = N*(i/NUM_TASKS)+1;
	}
	
	
	for (int i = 0; i < 2; i++) {
		pid[i] = fork();
	}
	
	if ((pid[0] == 0) && (pid[1] == 0)) {
		close(fd3[0]);
		for (unsigned long i = sumIndex[0]; i < sumIndex[1]; i++) {
			sumCC += i;
		}
		write(fd3[1], &sumCC, sizeof(sumCC));
		exit(0);
	}
	else if ((pid[0] == 0) && (pid[1] > 0)) {
		close(fd2[0]);
		close(fd3[1]);
		for (unsigned long i = sumIndex[1]; i < sumIndex[2]; i++) {
			sumCP += i;
		}
		read(fd3[0], &sumCC, sizeof(sumCC));
		sumCP += sumCC;
		write(fd2[1], &sumCP, sizeof(sumCP));
		exit(0);
	}
	else if ((pid[0] > 0) && (pid[1] == 0)) {
		close(fd1[0]);
		for (unsigned long i = sumIndex[2]; i < sumIndex[3]; i++) {
			sumPC += i;
		}
		write(fd1[1], &sumPC, sizeof(sumPC));
		exit (0);
	}
	else if ((pid[0] > 0) && (pid[1] > 0)) {
		close(fd2[1]);
		close(fd1[1]);
		for (unsigned long i = sumIndex[3]; i <= N; i++) {
			sumPP += i;
		}
		read(fd2[0], &sumCP, sizeof(sumCP));
		read(fd1[0], &sumPC, sizeof(sumPC));
		sum = sumPP + sumCP + sumPC;
	}
	
	return sum;
}

unsigned long long sumEightTasks() {
	
	int fd1[2], fd2[2], fd3[2], fd4[2], fd5[2], fd6[2], fd7[2];
	unsigned long sumIndex[(NUM_TASKS)-1];
	unsigned long long sum = 0;
	unsigned long long sumPPP = 0;
	unsigned long long sumPPC = 0;
	unsigned long long sumPCP = 0;
	unsigned long long sumPCC = 0;
	unsigned long long sumCPP = 0;
	unsigned long long sumCPC = 0;
	unsigned long long sumCCP = 0;
	unsigned long long sumCCC = 0;
	
	pipe(fd1);
	pipe(fd2);
	pipe(fd3);
	pipe(fd4);
	pipe(fd5);
	pipe(fd6);
	pipe(fd7);
	
	pid_t pid[3];
	
	for (int i = 0; i < (NUM_TASKS-1); i++) {
		sumIndex[i] =  N*(i/NUM_TASKS)+1;
	}
	
	
	for (int i = 0; i < 3; i++) {
		pid[i] = fork();
	}
	
	if ((pid[0] == 0) && (pid[1] == 0) && (pid[2] == 0)) {
		close(fd7[0]);
		for (unsigned long i = sumIndex[0]; i < sumIndex[1]; i++) {
			sumCCC += i;
		}
		write(fd7[1], &sumCCC, sizeof(sumCCC));
		exit(0);
		
	}
	else if ((pid[0] == 0) && (pid[1] == 0) && (pid[2] > 0)) {
		close(fd7[1]);
		close(fd6[0]);
		for (unsigned long i = sumIndex[1]; i < sumIndex[2]; i++) {
			sumCCP += i;
		}
		read(fd7[0], &sumCCC, sizeof(sumCCC));
		sumCCP += sumCCC;
		write(fd6[1], &sumCCP, sizeof(sumCCP));
		exit(0);
	}
	else if ((pid[0] == 0) && (pid[1] > 0) && (pid[2] == 0)) {
		close(fd5[0]);
		for (unsigned long i = sumIndex[2]; i < sumIndex[3]; i++) {
			sumCPC += i;
		}
		write(fd5[1], &sumCPC, sizeof(sumCPC));
		exit(0);
	}
	else if ((pid[0] == 0) && (pid[1] > 0) && (pid[2] > 0)) {
		close(fd6[1]);
		close(fd5[1]);
		close(fd4[0]);
		for (unsigned long i = sumIndex[3]; i < sumIndex[4]; i++) {
			sumCPP += i;
		}
		read(fd6[0], &sumCCP, sizeof(sumCCP));
		read(fd5[0], &sumCPC, sizeof(sumCPC));
		sumCPP += (sumCCP + sumCPC);
		write(fd4[1], &sumCPP, sizeof(sumCPP));
		exit(0);
	}
	else if ((pid[0] > 0) && (pid[1] == 0) && (pid[2] == 0)) {
		close(fd3[0]);
		for (unsigned long i = sumIndex[4]; i < sumIndex[5]; i++) {
			sumPCC += i;
		}
		write(fd3[1], &sumPCC, sizeof(sumPCC));
		exit(0);
	}
	else if ((pid[0] > 0) && (pid[1] == 0) && (pid[2] > 0)) {
		close(fd3[1]);
		close(fd2[0]);
		for (unsigned long i = sumIndex[5]; i < sumIndex[6]; i++) {
			sumPCP += i;
		}
		read(fd3[0], &sumPCC, sizeof(sumPCC));
		sumPCP += sumPPC;
		write(fd2[1], &sumPCP, sizeof(sumPCP));
		exit(0);
	}
	else if ((pid[0] > 0) && (pid[1] > 0) && (pid[2] == 0)) {
		close(fd1[0]);
		for (unsigned long i = sumIndex[6]; i < sumIndex[7]; i++) {
			sumPPC += i;
		}
		write(fd1[1], &sumPPC, sizeof(sumPPC));
		exit(0);
	}
	else if ((pid[0] > 0) && (pid[1] > 0) && (pid[2] > 0)) {
		close(fd4[1]);
		close(fd2[1]);
		close(fd1[1]);
		for (unsigned long i = sumIndex[7]; i <= N; i++) {
			sumPPP += i;
		}
		read(fd4[0], &sumCPP, sizeof(sumCPP));
		read(fd2[0], &sumPCP, sizeof(sumPCP));
		read(fd1[0], &sumPPC, sizeof(sumPPC));
		sum = sumPPP + sumCPP + sumPCP + sumPPC;
	}
	return sum;
}

int main() {

	unsigned long long sum;
	time_t start, end;
	
	time(&start);
	if (NUM_TASKS == 2) {
		sum = sumTwoTasks();
	}
	else if (NUM_TASKS == 4) {
		sum = sumFourTasks();
	}
	else if (NUM_TASKS == 8) {
		sum = sumEightTasks();
	}
	else {
		sum = 0;
	}
	time(&end);
	
	double timeTaken = (double)(end-start);
	printf("\nThe sum is: %llu", sum);
	printf("\nTime taken: %f seconds\n", timeTaken);
	return 0;
}

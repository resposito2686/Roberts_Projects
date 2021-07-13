#include <stdio.h> 
#include <sys/types.h> 
#include <unistd.h>  
#include <stdlib.h>  
#include <sys/wait.h> 
#include <string.h> 
#include <time.h> 
#include <signal.h>
#include <sys/time.h>

/************************************************************************************************ 
		These DEFINE statements represent the workload size of each task and 
		the time quantum values for Round Robin scheduling for each task.
*************************************************************************************************/

#define WORKLOAD1 100000
#define WORKLOAD2 100000
#define WORKLOAD3 100000
#define WORKLOAD4 100000

#define QUANTUM1 50000
#define QUANTUM2 50000
#define QUANTUM3 50000
#define QUANTUM4 50000

/************************************************************************************************ 
					DO NOT CHANGE THE FUNCTION IMPLEMENTATION
*************************************************************************************************/
void myfunction(int param){

	int i = 2;
	int j, k;

	while(i < param){
		k = i; 
		for (j = 2; j <= k; j++)
		{
			if (k % j == 0){
				k = k/j;
				j--;
				if (k == 1){
					break;
				}
			}
		}
		i++;
	}
}
/************************************************************************************************/

int main(int argc, char const *argv[])
{
	pid_t pid1, pid2, pid3, pid4;
	int running1, running2, running3, running4;
	struct timeval start, res;
	struct timeval end[4];

	pid1 = fork();

	if (pid1 == 0){

		myfunction(WORKLOAD1);

		exit(0);
	}
	kill(pid1, SIGSTOP);

	pid2 = fork();

	if (pid2 == 0){

		myfunction(WORKLOAD2);

		exit(0);
	}
	kill(pid2, SIGSTOP);

	pid3 = fork();

	if (pid3 == 0){

		myfunction(WORKLOAD3);

		exit(0);
	}
	kill(pid3, SIGSTOP);

	pid4 = fork();

	if (pid4 == 0){

		myfunction(WORKLOAD4);

		exit(0);
	}
	kill(pid4, SIGSTOP);

	/************************************************************************************************ 
		At this point, all  newly-created child processes are stopped, and ready for scheduling.
	*************************************************************************************************/



	/************************************************************************************************
		- Scheduling code starts here
		- Below is a sample schedule. (which scheduling algorithm is this?)
		- For the assignment purposes, you have to replace this part with the other scheduling methods 
		to be implemented.
	************************************************************************************************/
	double responseTime[4];
	double avg = 0;
	running1 = 1;
	running2 = 1;
	running3 = 1;
	running4 = 1;
	
	gettimeofday(&start, NULL);
	while (running1 > 0 || running2 > 0 || running3 > 0 || running4 > 0)
	{
		if (running1 > 0) {
			kill(pid1, SIGCONT);
			usleep(QUANTUM1);
			kill(pid1, SIGSTOP);
			gettimeofday(&end[0], NULL);
		}
		if (running2 > 0) {
			kill(pid2, SIGCONT);
			usleep(QUANTUM2);
			kill(pid2, SIGSTOP);
			gettimeofday(&end[1], NULL);
		}
		if (running3 > 0) {
			kill(pid3, SIGCONT);
			usleep(QUANTUM3);
			kill(pid3, SIGSTOP);
			gettimeofday(&end[2], NULL);
		}
		if (running4 > 0) {
			kill(pid4, SIGCONT);
			usleep(QUANTUM4);
			kill(pid4, SIGSTOP);
			gettimeofday(&end[3], NULL);
		}
		waitpid(pid1, &running1, WNOHANG);
		waitpid(pid2, &running2, WNOHANG);
		waitpid(pid3, &running3, WNOHANG);
		waitpid(pid4, &running4, WNOHANG);
	}
	
	for (int i = 0; i < 4; i++) {
		timersub(&end[i], &start, &res);
        	responseTime[i] = (res.tv_sec * 1000000 + res.tv_usec);
        	responseTime[i] /= 1000000;
        	avg += responseTime[i];
        	printf("PROCESS #%d RESPONSE TIME: %.3f seconds.\n", (i+1), responseTime[i]);
	}
	avg /= 4;
	printf("AVERAGE RESPONSE TIME FOR MULTI-LEVEL FEEDBACK QUEUE: %.3f seconds.\n", avg);
	/************************************************************************************************
		- Scheduling code ends here
	************************************************************************************************/
	return 0;
}

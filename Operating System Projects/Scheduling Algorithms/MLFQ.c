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
#define WORKLOAD2 50000
#define WORKLOAD3 25000
#define WORKLOAD4 10000

#define QUANTUM1 500000
#define QUANTUM2 500000
#define QUANTUM3 500000
#define QUANTUM4 500000

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
	int running[4];
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
	pid_t pidArr[] = {pid1, pid2, pid3, pid4};
	double responseTime[4];
	double avg = 0;
	running[0] = 1;
	running[1] = 1;
	running[2] = 1;
	running[3] = 1;
	
	gettimeofday(&start, NULL);
	
	kill(pid1, SIGCONT);
	usleep(QUANTUM1);
	waitpid(pid1, &running[0], WNOHANG);
	if (running[0] == 0)
	{
		gettimeofday(&end[0], NULL);
	}
	else
	{
		kill(pid1, SIGSTOP);
	}
	
	kill(pid2, SIGCONT);
	usleep(QUANTUM2);
	waitpid(pid2, &running[1], WNOHANG);
	if (running[1] == 0)
	{
		gettimeofday(&end[1], NULL);
	}
	else
	{
		kill(pid2, SIGSTOP);
	}
	
	kill(pid3, SIGCONT);
	usleep(QUANTUM3);
	waitpid(pid3, &running[2], WNOHANG);
	if (running[2] == 0)
	{
		gettimeofday(&end[2], NULL);
	}
	else
	{
		kill(pid3, SIGSTOP);
	}
	
	kill(pid4, SIGCONT);
	usleep(QUANTUM4);
	waitpid(pid4, &running[3], WNOHANG);
	if (running[3] == 0)
	{
		gettimeofday(&end[3], NULL);
	}
	else
	{
		kill(pid4, SIGSTOP);
	}
	
	for (int i = 0; i < 4; i++)
	{
		if (running[i]) {
			kill(pidArr[i], SIGCONT);
        		while (running[i]) {
        			waitpid(pidArr[i], &running[i], 0);
        		}
        		gettimeofday(&end[i], NULL);
        	}
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

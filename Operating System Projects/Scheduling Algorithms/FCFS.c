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

#define QUANTUM1 1000
#define QUANTUM2 1000
#define QUANTUM3 1000
#define QUANTUM4 1000

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
	struct timeval start, end, res;

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
		- First Come First Serve
	************************************************************************************************/
	pid_t pidArr[4] = {pid1, pid2, pid3, pid4};
	double responseTime[4];
	double t;
	double avg = 0;
	
	running[0] = 1;
	running[1] = 1;
	running[2] = 1;
	running[3] = 1;
	
	for (int i = 0; i < 4; i++) {
        	gettimeofday(&start, NULL);
        	kill(pidArr[i], SIGCONT);
        	while (running[i]) {
        		waitpid(pidArr[i], &running[i], 0);
        	}
        	gettimeofday(&end, NULL);
        	timersub(&end, &start, &res);
        	t = (res.tv_sec * 1000000 + res.tv_usec);
        	t = t/1000000;
        	if (i == 0) {
        		responseTime[i] = t;
        	}
        	else {
        		responseTime[i] = t + responseTime[i-1];
        	}
        	avg += responseTime[i];
        	printf("PROCESS #%d RESPONSE TIME: %.3f seconds.\n", (i+1), responseTime[i]);
        }
        avg /= 4;
        printf("AVERAGE RESPONSE TIME FOR FIRST COME FIRST SERVE: %.3f seconds.\n", avg);
	/************************************************************************************************
		- Scheduling code ends here
	************************************************************************************************/
	return 0;
}

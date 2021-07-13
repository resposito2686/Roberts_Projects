/*********************************************************************
*               SEGGER MICROCONTROLLER GmbH & Co. KG                 *
*       Solutions for real time microcontroller applications         *
**********************************************************************
*                                                                    *
*       (c) 2014 - 2016  SEGGER Microcontroller GmbH & Co. KG        *
*                                                                    *
*       www.segger.com     Support: support@segger.com               *
*                                                                    *
**********************************************************************

-------------------------- END-OF-HEADER -----------------------------

File    : main.c
Purpose : Generic application start
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void toPostFix(char *, char *);

int main() 
{

     static char convertedstring1[16], convertedstring2[16];
     static char checkstring1[16],checkstring2[16];
     static char string1[16], string2[16];
     
     strcpy(string1,"A*B+C*D+E");
     strcpy(string2,"(A+B)*(C+D)+E");
	
      
     toPostFix(string1, convertedstring1);
     toPostFix(string2, convertedstring2);


     printf("\nString 1- Infix to Postfix is %s\n",convertedstring1);
     printf("\nString 2- Infix to Postfix is %s\n",convertedstring2);  
 
     return 0;
}

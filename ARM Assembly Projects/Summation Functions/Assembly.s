/*
 * Assembly.S
 */

  .global sumofFirstNNumbers
  .data
  // declare any global variables here
  .text
  // Summation of all integers between 1 and the input
  sumofFirstNNumbers:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  push  {lr}		// push link register onto stack -- make sure you pop it out before you return

  //r0 = input, r1 = loopCounter, r2 = sum
  mov r1, #1      //sets loopCounter to 1
  mov r2, #0      //sets sum to 0

 FOR1:
  cmp r1, r0;     //loops until loopCounter = input
  bgt DONE1       //jump to DONE if loopCounter > input
  add r2, r2, r1  //sum = sum + loop counter
  add r1, r1, #1  //loop counter = loop counter + 1
  b FOR1          //repeat loop

 DONE1:
  mov r0, r2      // moves sum to r0 so it can be returned
  pop {lr}		  // pop link register from stack 
  mov sp,r12	  // restore the stack pointer -- Please note stack pointer should be equal to the 
				  // value it had when you entered the function .  
  bx lr			  // return from the function by copying link register into program counter


  .global sumofEvenNumbers
  .data
  // declare any global variables here
  .text
  // Summation of all even integers between n1 and n2
  sumofEvenNumbers:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  push  {lr}		// push link register onto stack -- make sure you pop it out before you return 

  //r0 = n1, r1 = n2, r2 = sum, r3 = mulResult
  mov r2, #0       //sets sum = 0
  lsr r0, r0, #1   //divides n1 by 2
  lsr r1, r1, #1   //divides n2 by 2
 
 FOR2:
  cmp r0, r1       //loops until n1 > n2
  bgt DONE2         
  lsl r3, r0, #1   //mulResult = n1*2 (using a logical shift left)
  add r2, r2, r3   //sum = sum + mulResult
  add r0, r0, #1   //n1 = n1 + 1
  b FOR2           //repeats loop

 DONE2:
  mov r0, r2       //moves sum to r0 so it can be returned
  pop {lr}		   // pop link register from stack 
  mov sp,r12	   // restore the stack pointer -- Please note stack pointer should be equal to the 
				   // value it had when you entered the function .  
  bx lr			   // return from the function by copying link register into  program counter
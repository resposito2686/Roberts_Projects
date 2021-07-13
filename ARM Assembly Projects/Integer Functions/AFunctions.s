/*
 * Homework6_822379994.s
 *
 *  Please rename this file as Homework6_yourReadID.s  and submit only this file
 */

 .global isNumber
  .data
  // declare any global variables here
  .text
  isNumber:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  push  {lr}		// push link register onto stack -- make sure you pop it out before you return 

  //r0 = ch, r1 = 0 in ascii, r2 = 9 in ascii
  mov r1, #48           //ascii value of 0.
  mov r2, #57           //ascii value of 9.
  cmp r0, r1            //compairs ch with the ascii value of 0.
  blt NOTNUM            //branches if ch is less than 48 (which means it isn't a digit).
  cmp r0, r2            //compairs ch with the ascii value of 9.
  bgt NOTNUM            //branches if ch is greater than 57 (which means it isn't a digit).
  mov r0, #1            //moves 1 into r0 to be returned.
  b DONE_ISNUMBER       //branches to done if ch is a number

 NOTNUM:
  mov r0, #0            //moves 0 into r0 to be returned.

 DONE_ISNUMBER:
  
  pop {lr}		// pop link register from stack 
  mov sp,r12		// restore the stack pointer -- Please note stack pointer should be equal to the 
			// value it had when you entered the function .  
  mov pc,lr		// return from the function by copying link register into  program counter

 

 
  .global compare
  .data
  // declare any global variables here
  .text
  compare:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  push  {lr}		// push link register onto stack -- make sure you pop it out before you return 

  //r0 = a, r1 = b, r2 = value to be returned
  mov r2, #1           //sets r3 to be 1. If a > b, return will be a 1.
  cmp r0, r1           //compare a and b
  bgt DONE_COMPARE     //branch to done if a > b
  neg r2, r2           //sets r3 to be -1. If a < b, return will be a -1.
  cmp r0, r1           //compare a and b
  blt DONE_COMPARE     //branch to done if a < b
  mov r2, #0           //sets r3 to be 0. if a > b and a < b are both false, then a = b. return will be a 0.
  b DONE_COMPARE       //unconditional branch to done.

 DONE_COMPARE:
  mov r0, r2           //moves r2 into r0 to be returned.

  pop {lr}	       // pop link register from stack 
  mov sp,r12	       // restore the stack pointer -- Please note stack pointer should be equal to the 
		       // value it had when you entered the function .  
  mov pc,lr	       // return from the function by copying link register into  program counter

  
  .global countOnes
  .data
  // declare any global variables here
  .text
  countOnes:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  push  {lr}		// push link register onto stack -- make sure you pop it out before you return 

  //r0 = a, number to be counted. r1 = count, r2 = a-1
  mov r1, #0          //sets count = 0

 WHILE_COUNTONES:
  cmp r0, #0           //checks if a = 0
  beq DONE_COUNTONES   //branches to done if a = 0
  mov r2, r0           //moves a into temp
  sub r2, r2, #1       //subtracts 1 from temp (a)
  and r0, r0, r2       //a & a-1
  add r1, r1, #1       //increments count
  b WHILE_COUNTONES    //loop again

 DONE_COUNTONES:
  mov r0, r1           //moves count into r0 to be returned

  pop {lr}	       // pop link register from stack 
  mov sp,r12	       // restore the stack pointer -- Please note stack pointer should be equal to the 
		       // value it had when you entered the function .  
  mov pc,lr	       // return from the function by copying link register into  program counter


  .global returnHammingDistance
  .data
  // declare any global variables here
  .text
  returnHammingDistance:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  push  {lr}		// push link register onto stack -- make sure you pop it out before you return 
  
  //r0 = a, r1 = b
  eor r0, r0, r1        //a ^ b. Stores value into r0
  b countOnes           //calls countOnes function

  pop {lr}		// pop link register from stack 
  mov sp,r12		// restore the stack pointer -- Please note stack pointer should be equal to the 
			// value it had when you entered the function .  
  mov pc,lr		// return from the function by copying link register into  program counter 
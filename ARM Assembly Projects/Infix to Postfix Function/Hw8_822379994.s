/* 
* Infix to PostFix
* Hw8_822379994.s
*/
  
  	
  .global toPostFix
  .data
  .text
  toPostFix:
  mov   r12,r13		// save stack pointer into register r12
  sub   sp,#32		// reserve 32 bytes of space for local variables 
  mov   r11, lr		// saves link register in r11. This is to avoid any stack errors.

  //r0 = inFixString[0]
  //r1 = postFixString[0]
  //r2 = i
  //r3 = j
  
  mov r2, #0            // sets i = 0
  mov r3, #0            // sets j = 0

 while_toPost_1:        // iterates through inFixString
  ldrb r4, [r0, r2]     // loads into r4 inFixString[i]
  cmp r4, #0            // stops loop when the null terminator is hit
  beq finish_toPost     // branch to finish_toPost if true
  cmp r4, #40           // checks if inFixString[i] = 'C'
  beq if1               // branch to if1 when true
  cmp r4, #41           // checks if inFixString[i] =')'
  beq if2               // branch to if2 when true
  push {r0}             // pushes r0 onto the stack to be saved for isOperator function call
  mov r0, r4            // moves inFixString[i] into r0 for isOperator function call
  bl isOperator         // calls the function isOperator
  mov r5, r0            // moves the return value of isOperator to r5 so inFixString pointer can be popped back
  pop {r0}              // pops inFixString pointer back into r0
  cmp r5, #1            // checks if inFixString[i] is an operator
  beq if3               // branch of if3 when true
  strb r4, [r1, r3]     // stores r4 to postFixString[j] (r4 must be a letter if this executes).
  add r2, r2, #1        // i++
  add r3, r3, #1        // j++
  b while_toPost_1      // loops
  
 if1:                   // if1 is called when inFixString[i] == '('
  push {r4}             // pushes r4 onto the stack
  add r2, r2, #1        // i++
  b while_toPost_1      // branches back to while_toPost_1

 if2:                   // if2 is called when inFixString[i] == ')'
  ldrb r5, [sp]         // loads top of the stack in r5
  cmp r5, #40           // checks if r5 is = '('
  bne while_if2         // branches to while_if2 when false
  pop {r4}              // pops '(' off the stack because it is no longer needed
  add r2, r2, #1        // i++
  b while_toPost_1      // branches back to while_toPost_1

 while_if2:             // called when the top of the stack is not = '(', which means its an operator
  pop {r5}              // pops the operator in r5
  strb r5, [r1, r3]     // stores r5 to postFixString[j]
  add r3, r3, #1        // j++
  b if2                 // branches back to if2

 if3:                   // if3 is called when inFixString[i] is an operator
  push {r0}             // push r0 onto the stack to be saved for precedence function call
  mov r0, r4            // moves inFixString[i] into r0 for precedence function call
  bl precedence         // calls the function precedence
  mov r4, r0            // moves the return value of precedence to r4 so inFixString pointer can be popped back
  pop {r0}              // pops inFixString pointer back into r0
  ldrb r5, [sp]         // loads into r5 whatever is currently on top of the stack.
  push {r0}             // push r0 onto the stack to be saved for precedence function call
  mov r0, r5            // moves whatever was on top of the stack into r0 for precedence function call
  bl precedence         // calls the function precedence
  mov r5, r0            // moves the return value of precedence to r5 so inFixString pointer can be popped back
  pop {r0}              // pops inFixString pointer back into r0
  cmp r4, r5            // compares the precedence of inFixString[i] and whatever is at the top of the stack.
  bgt if3.1             // branch to if3.1 if r4 > r5
  cmp r4, r5            // compares the precedence of inFixString[i] and whatever is at the top of the stack.
  beq if3.2             // branch to if3.2 if r4 == r5
  b while_if3           // otherwise, branch to while_if3

 if3.1:
  ldrb r4, [r0, r2]     // loads into r4 inFixString[i]
  push {r4}             // pushes r4 onto the stack
  add r2, r2, #1        // i++
  b while_toPost_1      // branch back to while_toPost_1
  
 if3.2:
  pop {r4}              // pops the top of the stack into r4
  strb r4, [r1, r3]     // stores r4 into postFixString[j]
  add r3, r3, #1        // j++
  ldrb r4, [r0, r2]     // loads into r4 inFixString[i]
  push {r4}             // pushes r4 onto the stack
  add r2, r2, #1        // i++
  b while_toPost_1      // branch back to while_toPost_1

 while_if3:
  cmp r4, r5            // compares the precedence of inFixString[i] and whatever is at the top of the stack.
  bgt done_if3          // branches to done_if3 when r4 > r5
  pop {r6}              // pops the top of the stack into r6
  strb r6, [r1, r3]     // stores r6 to postFixString[j]
  add r3, r3, #1        // j++
  ldrb r5, [sp]         // loads into r5 whatever is currently on top of the stack.
  push {r0}             // push r0 onto the stack to be saved for precedence function call
  mov r0, r5            // moves whatever was on top of the stack into r0 for precedence function call
  bl precedence         // calls the function precedence
  mov r5, r0            // moves the return value of precedence to r5 so inFixString pointer can be popped back
  pop {r0}              // pops inFixString pointer back into r0
  b while_if3           // loops
 
 done_if3:
  ldrb r4, [r0, r2]     // loads into r4 inFixString[i]
  push {r4}             // pushes r4 onto the stack
  add r2, r2, #1        // i++
  b while_toPost_1      // branch back to while_toPost_1
  
 finish_toPost:         // finishes popping any remaining operators still on the stack
  pop {r4}              // pops the remaining operator off the stack into r4
  strb r4, [r1, r3]     // stores r4 into postFixString[j]
  add r3, r3, #1        // j++
  b done_toPost         // branches to done_toPost

 done_toPost:
  mov lr, r11           // moves the original link register (stored in r11) back into lr
  mov sp,r12		// restore the stack pointer -- Please note stack pointer should be equal to the 
			// value it had when you entered the function .  
  bx lr		        // return from the function by copying link register into  program counter


 isOperator:            // this function checks if r0 is an operator

  //r0 = item
  
  cmp r0, #42           // checks if r0 == '*'
  beq is_an_operator    // branches to is_an_operator when true
  cmp r0, #43           // checks if r0 == '+'
  beq is_an_operator    // branches to is_an_operator when true
  cmp r0, #45           // checks if r0 == '-'
  beq is_an_operator    // branches to is_an_operator when true
  cmp r0, #47           // checks if r0 == '/'
  beq is_an_operator    // branches to is_an_operator when true
  b is_not_operator     // branches to is_not_operator when none of the conditions are true

 is_an_operator:        // item is an operator
  mov r0, #1            // returns a 1 when item is an operator
  b done_operator       

 is_not_operator:       // item is not an operator
  mov r0, #0            // returns a 0 when item is not an operator
  b done_operator       

 done_operator:

  bx lr			// return from the function by copying link register into program counter


 precedence:            // this function returns the precedence of r0

  //r0 = item
  cmp r0, #42           // checks if r0 == '*'
  beq precedence_2      // branches to precedence_2 when true
  cmp r0, #47           // checks if r0 == '/'
  beq precedence_2      // branches to precedence_2 when true
  cmp r0, #43           // checks if r0 == '+'
  beq precedence_1      // branches to precedence_1 when true
  cmp r0, #45           // checks if r0 == '-'
  beq precedence_1      // branches to precedence_1 when true
  b precedence_0        // branches to precedence_0 when none of the conditions are true

 precedence_2:
  mov r0, #2            // the precedece of item is 2
  b done_precedence

 precedence_1:
  mov r0, #1            // the precedece of item is 1
  b done_precedence
  
 precedence_0:
  mov r0, #0            // the precedece of item is 0
  b done_precedence

 done_precedence:
  bx lr			// return from the function by copying link register into  program counter
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
// Design Name: 
// Module Name: alu
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu #(parameter WORD_SIZE = 32, SHAMT_SIZE = 5, SEL_SIZE = 4)
            (input wire signed [WORD_SIZE - 1: 0] a,
                   wire signed [WORD_SIZE - 1: 0] b,
             input wire [SHAMT_SIZE - 1 : 0] shamt,
             input wire [SEL_SIZE - 1 : 0] sel,
             output reg zero,
             output reg signed [WORD_SIZE - 1: 0] z);
                     
    always @ (*) begin     //any input change will be executed asynchronously.
        case (sel)         //determines what operation alu will preform
            0: z <= a + b;  //addition.
            1: z <= a - b;  //subtraction.
            2: z <= b << shamt; //logical shift left
            3: z <= b >> shamt; //logical shift right
            4: z <= b << a [4:0]; //logical variable shift left.
            5: z <= b >> a [4:0]; //logical variable shift right.
            6: z <= b >>> a [4:0]; //arithmetic variable shift right.
            7: z <= b >>> shamt; //arithmetic shift right.
            8: z <= a & b;   //AND
            9: z <= a | b;   //OR
            10: z <= a ^ b;   //XOR
            11: z <= a ~^ b; //XNOR
            default: z <= 0; //default output is 0.
        endcase
        
        if (!z)
            zero <= 1;
        else
            zero <= 0;
    end
endmodule

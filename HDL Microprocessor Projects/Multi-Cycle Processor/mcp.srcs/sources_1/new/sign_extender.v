`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 03:31:56 PM
// Design Name: 
// Module Name: sign_extender
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


module sign_extender #(parameter WORD_SIZE = 32, IMMEDIATE = 16)
                      (input [IMMEDIATE - 1 : 0] IMM,
                       output reg [WORD_SIZE - 1 : 0] SIMM);
         
    always @ (IMM) begin
        SIMM <= { {(WORD_SIZE-IMMEDIATE){IMM[(IMMEDIATE-1)]}}, IMM[IMMEDIATE-1 : 0] };  
    end         
endmodule

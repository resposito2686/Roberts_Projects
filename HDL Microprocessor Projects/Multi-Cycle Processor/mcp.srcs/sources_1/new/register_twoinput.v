`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 02:49:11 PM
// Design Name: 
// Module Name: register_twoinput
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


module register_twoinput #(parameter WORD_SIZE = 32)
                          (input [WORD_SIZE - 1 : 0] d1, d2,
                           input clk,
                           output reg [WORD_SIZE - 1: 0] q1, q2);
    
    always @ (posedge clk) begin
        q1 <= d1;
        q2 <= d2;
    end
endmodule

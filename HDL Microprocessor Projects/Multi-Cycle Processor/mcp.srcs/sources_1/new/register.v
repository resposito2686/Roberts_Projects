`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 02:41:24 PM
// Design Name: 
// Module Name: register
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


module register #(parameter WORD_SIZE = 32)
                 (input [WORD_SIZE - 1: 0] d,
                  input clk,
                  output reg [WORD_SIZE - 1: 0] q);

    always @ (posedge clk) begin
        q <= d;
    end
endmodule

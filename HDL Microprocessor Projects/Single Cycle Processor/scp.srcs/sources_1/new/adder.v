`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
// Design Name: 
// Module Name: adder
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

module adder #(parameter WORD_SIZE = 32)
            (input [WORD_SIZE - 1 : 0] a, b,
             output reg [WORD_SIZE - 1 : 0] z);

    always @ (*) begin
        z <= a + b;
    end
endmodule
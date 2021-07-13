`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
// Design Name: 
// Module Name: mux
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

module mux #(parameter WORD_SIZE = 32)
            (input [WORD_SIZE - 1 : 0] a, b,
             input sel,
             output reg [WORD_SIZE - 1 : 0] z);
             
    always @ (*) begin
        case (sel)
            1'b0: z <= a;
            1'b1: z <= b;
            default: z <= a;
        endcase
    end
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 02:57:51 PM
// Design Name: 
// Module Name: mux_fourway
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


module mux_fourway #(parameter WORD_SIZE = 32)
                    (input [WORD_SIZE - 1: 0] a, b, c, d,
                     input [1:0] sel,
                     output reg [WORD_SIZE - 1: 0] z);

    always @ (*) begin
        case (sel)
            2'b00: z <= a;
            2'b01: z <= b;
            2'b10: z <= c;
            2'b11: z <= d;
        endcase
    end               
endmodule

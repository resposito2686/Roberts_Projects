`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 01:01:36 PM
// Design Name: 
// Module Name: register_decode
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


module register_decode #(parameter WORD_SIZE = 32)
                        (input [WORD_SIZE - 1 : 0] InstrF, PCp1F,
                         input clk,
                         output reg [WORD_SIZE - 1 : 0] InstrD, PCp1D);

    always @ (posedge clk) begin
        InstrD <= InstrF;
        PCp1D <= PCp1F;
    end
endmodule

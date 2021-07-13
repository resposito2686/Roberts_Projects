`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 01:24:52 PM
// Design Name: 
// Module Name: register_writeback
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


module register_writeback #(parameter WORD_SIZE = 32)
                           (input clk,
                            input RFWEM, MtoRFSelM,
                            input [WORD_SIZE - 1 : 0] ALUOutM, DMOutM,
                            input [4:0] rtdM,
                            output reg RFWEW, MtoRFSelW,
                            output reg [WORD_SIZE - 1 : 0] ALUOutW, DMOutW,
                            output reg [4:0] rtdW);

    always @ (posedge clk) begin
        RFWEW <= RFWEM;
        MtoRFSelW <= MtoRFSelM;
        ALUOutW <= ALUOutM;
        DMOutW <= DMOutM;
        rtdW <= rtdM;
    end
endmodule

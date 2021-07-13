`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 01:17:21 PM
// Design Name: 
// Module Name: register_memory
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


module register_memory #(parameter WORD_SIZE = 32)
                        (input clk,
                         input RFWEE, MtoRFSelE, DMWEE, BranchE, zeroE,
                         input [WORD_SIZE - 1 : 0] ALUOutE, DMInE, PCBranchE,
                         input [4:0] rtdE,
                         output reg RFWEM, MtoRFSelM, DMWEM, BranchM, zeroM,
                         output reg [WORD_SIZE - 1 : 0] ALUOutM, DMInM, PCBranchM,
                         output reg [4:0] rtdM);

    always @ (posedge clk) begin
        RFWEM <= RFWEE;
        MtoRFSelM <= MtoRFSelE;
        DMWEM <= DMWEE;
        BranchM <= BranchE;
        zeroM <= zeroE;
        ALUOutM <= ALUOutE;
        DMInM <= DMInE;
        PCBranchM <= PCBranchE;
        rtdM <= rtdE;
    end
endmodule

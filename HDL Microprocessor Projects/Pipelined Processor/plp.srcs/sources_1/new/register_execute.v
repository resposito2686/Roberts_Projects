`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 01:05:28 PM
// Design Name: 
// Module Name: register_execute
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


module register_execute #(parameter WORD_SIZE = 32)
                         (input clk,
                          input RFWED, MtoRFSelD, DMWED, BranchD, ALUInSelD,
                          RFDSelD,
                          input [3:0] ALUSelD,
                          input [WORD_SIZE - 1 : 0] RFRD1D, RFRD2D, SImmD, PCp1D,
                          input [4:0] rtD, rdD, shamtD,
                          output reg RFWEE, MtoRFSelE, DMWEE, BranchE, ALUInSelE,
                          RFDSelE,
                          output reg [3:0] ALUSelE,
                          output reg [WORD_SIZE - 1 : 0] RFRD1E, RFRD2E, SImmE, PCp1E,
                          output reg [4:0] rtE, rdE, shamtE);

    always @ (posedge clk) begin
        RFWEE <= RFWED;
        MtoRFSelE <= MtoRFSelD;
        DMWEE <= DMWED;
        BranchE <= BranchD;
        ALUInSelE <= ALUInSelD;
        RFDSelE <= RFDSelD;
        ALUSelE <= ALUSelD;
        RFRD1E <= RFRD1D;
        RFRD2E <= RFRD2D;
        SImmE <= SImmD;
        PCp1E <= PCp1D;
        rtE <= rtD;
        rdE <= rdD;
    end
endmodule

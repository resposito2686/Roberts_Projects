`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2020 12:03:24 PM
// Design Name: 
// Module Name: memory
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


module memory #(parameter WORD_SIZE = 32, MEMORY_SIZE = 512, DATA_OFFSET = 100)
               (input [WORD_SIZE - 1: 0] MRA, MWD,
                input clk, we,
                output [WORD_SIZE - 1 : 0] MRD);
    
    reg [WORD_SIZE - 1 : 0] mem [0 : MEMORY_SIZE - 1];

    initial begin
        $readmemb("mcp_Program.data", mem);
        $readmemh("mcp_Data.data", mem, DATA_OFFSET);
    end
    
    always @ (posedge clk) begin
        if (we) begin
            mem[MRA] <= MWD;
        end
    end
    
    assign MRD = mem[MRA];
    
endmodule

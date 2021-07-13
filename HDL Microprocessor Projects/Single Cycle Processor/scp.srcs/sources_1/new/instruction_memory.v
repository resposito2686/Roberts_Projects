`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
// Design Name: 
// Module Name: instruction_memory
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

module instruction_memory #(parameter WORD_SIZE = 32, MEMORY_SIZE = 64)
                           (input [WORD_SIZE - 1 : 0] IMA, 
                            output reg [WORD_SIZE - 1: 0] IMRD);
                         
    reg [WORD_SIZE - 1 : 0] instMem [0 : MEMORY_SIZE - 1];
    
    initial begin
        $readmemb("scp_Program.data", instMem);
    end
    
    always @ (IMA) begin
       IMRD <= instMem[IMA];
    end    
endmodule

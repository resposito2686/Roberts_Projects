`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
// Design Name: 
// Module Name: data_memory
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

module data_memory #(parameter WORD_SIZE = 32, MEMORY_SIZE = 64)
                    (input [WORD_SIZE - 1: 0] DMA,
                     input [WORD_SIZE - 1 : 0] DMWD,
                     input clk, we,
                     output [WORD_SIZE - 1 : 0] DMRD);
                     
    reg [WORD_SIZE - 1 : 0] dataMem [0 : MEMORY_SIZE - 1];
    
    initial begin
        $readmemh("plp_Data.data", dataMem);
    end
    
    always @ (posedge clk) begin
        if (we) begin
            dataMem[DMA] <= DMWD;
        end
    end
    
    assign DMRD = dataMem[DMA];

endmodule
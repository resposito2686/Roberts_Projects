`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
// Design Name: 
// Module Name: register_file
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

module register_file #(parameter WORD_SIZE = 32, ADDRESS = 5)
                      (input [ADDRESS - 1: 0] RFR1, RFR2, RFWA, 
                       input [WORD_SIZE - 1: 0] RFWD,
                       input clk, we,
                       output [WORD_SIZE - 1 : 0] RFRD1,
                       output [WORD_SIZE - 1 : 0] RFRD2);

    reg [WORD_SIZE - 1 : 0] rfMem [0 : 2**ADDRESS - 1]; //creates the memory array for rf.
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            rfMem[i] = 0;
        end
    end
        
    always @ (posedge clk) begin    //synchronous write.
        if (we) begin               //writes only when write-enable is 1.
            rfMem[RFWA] <= RFWD; //writes data on RFWD into address RFWA.
        end
    end
    
    assign RFRD1 = rfMem[RFR1]; //asynchronous read of address RFR1.
    assign RFRD2 = rfMem[RFR2]; //asynchronous read of address RFR2.
    
endmodule
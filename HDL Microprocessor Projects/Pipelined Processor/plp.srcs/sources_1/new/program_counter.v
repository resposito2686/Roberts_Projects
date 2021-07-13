`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 01:45:06 PM
// Design Name: 
// Module Name: pc
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


module program_counter #(parameter ADDRESS = 32)
                        (input wire [ADDRESS - 1 : 0] PCIn,
                         input clk, rst,
                         output reg [ADDRESS - 1 : 0] PCOut);
                    
    always @ (rst)
        if (rst)
            PCOut <= -1;
    always @ (posedge clk)
        PCOut <= PCIn;
endmodule

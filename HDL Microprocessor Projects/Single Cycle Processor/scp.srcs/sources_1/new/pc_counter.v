`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 03:10:57 PM
// Design Name: 
// Module Name: pc_counter
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


module pc_counter #(parameter ADDRESS = 32)
                   (input wire [ADDRESS - 1 : 0] PCIN,
                    input clk, rst,
                    output reg [ADDRESS - 1 : 0] PCOUT);
                    
    always @ (rst)
        if (rst)
            PCOUT <= 0;
    always @ (posedge clk)
        PCOUT <= PCIN;
endmodule

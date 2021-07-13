`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 03:05:31 PM
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
                    input clk, rst, we,
                    output reg [ADDRESS - 1 : 0] PCOUT);
                    
    always @ (rst) begin
        if (rst)
            PCOUT <= 0;
    end
    always @ (posedge clk) begin
        if (we)
            PCOUT <= PCIN;
    end
endmodule

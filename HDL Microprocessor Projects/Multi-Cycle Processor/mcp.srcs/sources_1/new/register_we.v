`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 03:16:24 PM
// Design Name: 
// Module Name: register_we
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


module register_we #(parameter WORD_SIZE = 32)
                    (input [WORD_SIZE - 1 : 0] d,
                     input clk, we,
                     output reg [WORD_SIZE - 1 : 0] q);

    always @ (posedge clk) begin
        if (we)
            q <= d; 
            
    end
endmodule

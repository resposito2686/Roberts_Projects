`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 04:33:39 PM
// Design Name: 
// Module Name: tb_scp
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


module tb_scp;

    reg clk, PCRst;
    
    scp SCP00 (.clk(clk), .PCRst(PCRst));
    
    initial clk <= 0;
    always #5 clk <= ~clk; 
    initial begin
        PCRst = 1;
        #1;
        PCRst = 0;
        #440;
        $finish;
    end
endmodule

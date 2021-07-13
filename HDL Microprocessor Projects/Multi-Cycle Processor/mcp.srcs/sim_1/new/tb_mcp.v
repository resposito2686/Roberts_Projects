`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 03:54:20 PM
// Design Name: 
// Module Name: tb_mcp
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


module tb_mcp;
    
    reg clk, PCrst, CUrst;
    
    mcp MCP (.clk(clk), .PCrst(PCrst), .CUrst(CUrst));
    
    initial clk <= 0;
    always #5 clk <= ~clk;
    
    initial begin
        PCrst <= 1;
        #1;
        PCrst <= 0;
        CUrst <= 1;
        #10;
        CUrst <= 0;
        #2100;
        $finish;
    end
endmodule

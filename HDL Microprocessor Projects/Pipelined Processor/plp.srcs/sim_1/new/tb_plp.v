`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2020 07:00:52 PM
// Design Name: 
// Module Name: tb_plp
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


module tb_plp;
    reg clk, PCrst;
    
    plp PLP (.clk(clk), .PCrst(PCrst));
    
    initial clk <= 0;
    always #5 clk <= ~clk; 
    initial begin
        PCrst = 1;
        #1;
        PCrst = 0;
        #1000;
        $finish;
    end
endmodule

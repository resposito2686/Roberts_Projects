`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 03:09:27 PM
// Design Name: 
// Module Name: scp
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


module scp(input clk, PCRst);
    
    parameter WORD_SIZE = 32;
    
    wire [WORD_SIZE - 1 : 0] PCIn, PCOut;
    pc_counter PC00(.PCIN(PCIn), .PCOUT(PCOut), .clk(clk), .rst(PCRst));
    
    wire [WORD_SIZE - 1 : 0] Inst;
    instruction_memory IM00 (.IMA(PCOut), .IMRD(Inst));
    
    wire RFWE, RFDSel, ALUInSel, Branch,
         DMWE, MtoRFSel, Jump;
    wire [3:0] ALUSel;
    
    control_unit CU00 (.Inst(Inst), .RFWE(RFWE), 
                       .RFDSel(RFDSel), .ALUInSel(ALUInSel), 
                       .Branch(Branch), .DMWE(DMWE), 
                       .MtoRFSel(MtoRFSel), .Jump(Jump), 
                       .ALUSel(ALUSel));
                     
    wire [WORD_SIZE - 1 : 0] RFWD, RFRD1, RFRD2;
    wire [4:0] rs, rt, rd, rtd;
    assign rs = Inst[25:21];
    assign rt = Inst[20:16];
    assign rd = Inst[15:11];
    
    mux MUXrtd (.a(rt), .b(rd), .sel(RFDSel), .z(rtd));
    
    register_file RF00 (.RFR1(rs), .RFR2(rt), .RFWA(rtd), .clk(clk), 
                        .we(RFWE), .RFRD1(RFRD1), .RFRD2(RFRD2), .RFWD(RFWD));
                        
    wire [WORD_SIZE - 1 : 0] SEImm;
    wire [15:0] Imm;
    assign Imm = Inst[15:0]; 
       
    sign_extender SE00 (.IMM(Imm), .SIMM(SEImm));
    
    wire [WORD_SIZE - 1 : 0] ALUIn2;
    mux MUXALUIn (.a(RFRD2), .b(SEImm), .sel(ALUInSel), .z(ALUIn2));
    
    wire [WORD_SIZE - 1 : 0] ALUIn1, ALUOut;
    wire [4:0] shamt;
    wire ALUZero;
    assign ALUIn1 = RFRD1;
    assign shamt = Inst[10:6];
    
    alu ALU00 (.a(ALUIn1), .b(ALUIn2), .shamt(shamt), .sel(ALUSel), 
               .zero(ALUZero), .z(ALUOut));
    
    wire PCSel;
    assign PCSel = Branch & ALUZero;
    
    wire [WORD_SIZE - 1 : 0] DMOut;
   
    data_memory #(32,512) DM00(.DMA(ALUOut), .DMWD(RFRD2), .we(DMWE), 
                      .clk(clk), .DMRD(DMOut));
    
    mux MUXMTORF (.a(ALUOut), .b(DMOut), .sel(MtoRFSel), .z(RFWD));
    
    wire [WORD_SIZE - 1 : 0] PCp1, PCBranch;
    
    adder ADDPCp1 (.a(PCOut), .b(32'h00000001), .z(PCp1));
    adder ADDPCBranch (.a(SEImm), .b(PCp1), .z(PCBranch));
    
    wire [WORD_SIZE - 1 : 0] PCBtoJ;
    
    mux MUXBRANCH (.a(PCp1), .b(PCBranch), .sel(PCSel), .z(PCBtoJ));
    
    wire [WORD_SIZE - 1 : 0] PCJump;
    assign PCJump = {PCOut[31:26],Inst[25:0]};
    
    mux MUXJump (.a(PCBtoJ), .b(PCJump), .sel(Jump), .z(PCIn));
endmodule

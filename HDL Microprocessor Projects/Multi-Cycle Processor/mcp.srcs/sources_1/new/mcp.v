`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 03:29:13 PM
// Design Name: 
// Module Name: mcp
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


module mcp #(parameter WORD_SIZE = 32)
            (input clk, PCrst, CUrst);
    
    //PROGRAM COUNTER      
    wire [WORD_SIZE - 1 : 0] PCIn, PCOut;
    wire PCWE, PCEn, Branch, BtoPC;
    
    //IDSEL MUX
    wire [WORD_SIZE - 1 : 0] Adr, ALUOutR;
    wire IDSel;
    
    //MEMORY
    wire [WORD_SIZE - 1 : 0] IRorDR;
    wire MWE;
    
    //IR REGISTER
    wire [WORD_SIZE - 1 : 0] IR;
    wire IRWE;
    
    //DR REGISTER
    wire [WORD_SIZE - 1 : 0] DR;
    
    //RFD SELECT MUX
    wire RFDSel;
    
    //MTORF SELECT MUX
    wire MtoRFSel;
    
    //REGISTER FILE
    wire [WORD_SIZE - 1 : 0] RFWD, RFRD1, RFRD2;
    wire [4:0] rs, rt, rd, rtd;
    assign rs = IR[25:21];
    assign rt = IR[20:16];
    assign rd = IR[15:11];
    
    //REGISTER FILE REGISTER
    wire [WORD_SIZE - 1 : 0] A, B;
    
    //ALU IN 1 MUX
    wire [WORD_SIZE - 1 : 0] ALUIn1;
    wire ALUIn1Sel;
    
    //SIGN EXTENDER
    wire [WORD_SIZE - 1 : 0] SIMM;
    
    //ALU IN 2 MUX
    wire [WORD_SIZE - 1 : 0] ALUIn2;
    wire [1:0] ALUIn2Sel;
    
    //ALU
    wire [WORD_SIZE - 1 : 0] ALUOut;
    wire [3:0] ALUSel;
    wire [4:0] shamt;
    wire ALUZero;
    assign shamt = IR[10:6];
    
    //PC SELECT MUX
    wire [1:0] PCSel;
    
    //BRANCH
    assign BtoPC = ALUZero & Branch;
    assign PCEn = PCWE | BtoPC;
    
    //JUMP
    wire [WORD_SIZE - 1 : 0] PCJump;
    assign PCJump = {PCOut[31:26],IR[25:0]};
    
    pc_counter PC (.PCIN(PCIn), .clk(clk), .rst(PCrst), .we(PCEn), .PCOUT(PCOut));
    
    mux IDSelMux (.a(PCOut), .b(ALUOutR), .sel(IDSel), .z(Adr));
    
    memory MEM (.MRA(Adr), .MWD(B), .clk(clk), .we(MWE), .MRD(IRorDR));
    
    register_we IRReg (.d(IRorDR), .clk(clk), .we(IRWE), .q(IR));
    
    register DRReg (.d(IRorDR), .clk(clk), .q(DR));
    
    mux #(5) RFDSelMux (.a(rt), .b(rd), .sel(RFDSel), .z(rtd));
    
    mux MtoRFSelMux (.a(ALUOutR), .b(DR), .sel(MtoRFSel), .z(RFWD));
    
    register_file RF (.RFR1(rs), .RFR2(rt), .RFWA(rtd), .RFWD(RFWD), .clk(clk), 
                      .we(RFWE), .RFRD1(RFRD1), .RFRD2(RFRD2));
                      
    register_twoinput ABReg (.d1(RFRD1), .d2(RFRD2), .clk(clk), .q1(A), .q2(B));
    
    mux ALUIn1SelMux (.a(PCOut), .b(A), .sel(ALUIn1Sel), .z(ALUIn1));
    
    sign_extender SEX (.IMM(IR[15:0]), .SIMM(SIMM));
    
    mux_fourway ALUIn2SelMux (.a(B), .b(32'h00000001), .c(SIMM), .d(32'hxxxxxxxx),
                              .sel(ALUIn2Sel), .z(ALUIn2));
                              
    alu ALU (.a(ALUIn1), .b(ALUIn2), .shamt(shamt), .sel(ALUSel), 
             .zero(ALUZero), .z(ALUOut));
             
    register ALUOutReg (.d(ALUOut), .clk(clk), .q(ALUOutR));
    
    mux_fourway PCSelMux (.a(ALUOut), .b(ALUOutR), .c(PCJump),
                          .d(32'hxxxxxxxx), .sel(PCSel), .z(PCIn)); 
    
    control_unit CTRLU (.Inst(IR), .clk(clk), .rst(CUrst), .IDSel(IDSel), 
                        .ALUIn1Sel(ALUIn1Sel), .RFDSel(RFDSel), .MtoRFSel(MtoRFSel), 
                        .IRWE(IRWE), .PCWE(PCWE), .RFWE(RFWE), .MWE(MWE), .Branch(Branch), 
                        .ALUIn2Sel(ALUIn2Sel), .PCSel(PCSel), .ALUSel(ALUSel));
                        
endmodule

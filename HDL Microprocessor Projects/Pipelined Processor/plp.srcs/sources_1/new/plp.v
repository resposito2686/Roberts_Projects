`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/30/2020 01:41:49 PM
// Design Name: 
// Module Name: plp
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


module plp(input clk, PCrst);
    parameter WL = 32;
    
    //Program Counter
    wire [WL - 1 : 0] PCIn, PCOut;
    
    //Instruction Memory
    wire [WL - 1 : 0] InstrF, InstrD;
    
    //PC+1, Branch, and Jump
    wire [WL - 1 : 0] PCp1F, PCp1D, PCp1E,
                      PCBranchM,
                      PCJump,
                      PCBtoJ;
    wire [25:0] Jaddr;
    assign Jaddr = InstrD[25:0];
    assign PCJump = {PCp1F[31:26], Jaddr};
    
    //Register File
    wire [4:0] rs, rt, 
               rtD, rdD, rtE, rdE, 
               rtdE, rtdM, rtdW;
    wire [WL - 1 : 0] ResultW, 
                      RFRD1D, RFRD1E, 
                      RFRD2D, RFRD2E;
    assign rs = InstrD[25:21];
    assign rt = InstrD[20:16];
    assign rtD = InstrD[20:16];
    assign rdD = InstrD[15:11];
    
    //Sign Extender
    wire [WL - 1 : 0] SImmD, SImmE;
    wire [15:0] Imm;
    assign Imm = InstrD[15:0];
    
    //Control Unit
    wire RFWED, RFWEE, RFWEM, RFWEW, 
         MtoRFSelD, MtoRFSelE, MtoRFSelM, MtoRFSelW,
         DMWED, DMWEE, DMWEM, 
         BranchD, BranchE, BranchW,
         ALUInSelD, ALUInSelE,
         RFDSelD, RFDSelE;
    wire [3:0] ALUSelD, ALUSelE;
    
    //ALU
    wire [WL - 1 : 0] ALUIn2,
                      ALUOutE, ALUOutM, ALUOutW;
    wire [4:0] shamtD, shamtE;
    wire zeroE, zeroM;
    assign shamtD = InstrD[10:6];
    
    //PC Select
    wire PCSelM;
    assign PCSelM = BranchM & zeroM;
    
    //Data Memory
    wire [WL - 1 : 0] DMInE, DMInM,
                      DMOutM, DMOutW;
    assign DMInE = RFRD2E;
                      
    
    program_counter PC (.clk(clk), .rst(PCrst), .PCIn(PCIn), .PCOut(PCOut));
    
    
    instruction_memory IM (.IMA(PCOut), .IMRD(InstrF));
    
    
    register_decode REGD (.clk(clk), .InstrF(InstrF), .PCp1F(PCp1F),
                          .InstrD(InstrD), .PCp1D(PCp1D));
    
    
    register_file RF (.clk(clk), .RFR1(rs), .RFR2(rt), .RFWA(rtdW), .RFWD(ResultW),
                      .we(RFWEW), .RFRD1(RFRD1D), .RFRD2(RFRD2D));
    
    
    sign_extender SE (.IMM(Imm), .SIMM(SImmD));
    
    
    control_unit CU (.Inst(InstrD), .RFWE(RFWED), .MtoRFSel(MtoRFSelD), 
                     .DMWE(DMWED), .Branch(BranchD), .ALUInSel(ALUInSelD),
                     .RFDSel(RFDSelD), .Jump(JumpD), .ALUSel(ALUSelD));
    
    
    register_execute REGE (.clk(clk), .RFWED(RFWED), .MtoRFSelD(MtoRFSelD), .DMWED(DMWED), 
                           .BranchD(BranchD), .ALUInSelD(ALUInSelD),
                           .RFDSelD(RFDSelD), .ALUSelD(ALUSelD),
                           .RFRD1D(RFRD1D), .RFRD2D(RFRD2D), .SImmD(SImmD), 
                           .PCp1D(PCp1D), .rtD(rtD), .rdD(rdD), .shamtD(shamtD),
                           .RFWEE(RFWEE), .MtoRFSelE(MtoRFSelE), .DMWEE(DMWEE), 
                           .BranchE(BranchE), .ALUInSelE(ALUInSelE),
                           .RFDSelE(RFDSelE), .ALUSelE(ALUSelE),
                           .RFRD1E(RFRD1E), .RFRD2E(RFRD2E), .SImmE(SImmE), 
                           .PCp1E(PCp1E), .rtE(rtE), .rdE(rdE), .shamtE(shamtE));
    
    mux RTD (.a(rtE), .b(rdE), .sel(RFDSelE), .z(rtdE));
    
                         
    mux ALUIN2 (.a(RFRD2E), .b(SImmE), .sel(ALUInSelE), .z(ALUIn2));
    alu ALU (.a(RFRD1E), .b(ALUIn2), .shamt(shamtE), .sel(ALUSelE), .zero(zeroE),
             .z(ALUOutE));       
             
             
    adder BRANCH_ADD (.a(SImmE), .b(PCp1E), .z(PCBranchE));
    
    
    register_memory REGM (.clk(clk), .RFWEE(RFWEE), .MtoRFSelE(MtoRFSelE), .DMWEE(DMWEE), 
                          .BranchE(BranchE), .zeroE(zeroE), .ALUOutE(ALUOutE), 
                          .DMInE(DMInE), .PCBranchE(PCBranchE), .rtdE(rtdE),
                          .RFWEM(RFWEM), .MtoRFSelM(MtoRFSelM), .DMWEM(DMWEM), 
                          .BranchM(BranchM), .zeroM(zeroM), .ALUOutM(ALUOutM), 
                          .DMInM(DMInM), .PCBranchM(PCBranchM), .rtdM(rtdM));
     
                          
    data_memory #(.MEMORY_SIZE(64)) DM (.clk(clk), .we(DMWEM), .DMA(ALUOutM), .DMWD(DMInM),
                    .DMRD(DMOutM));
                    
    register_writeback REGW (.clk(clk), .RFWEM(RFWEM), .MtoRFSelM(MtoRFSelM),
                             .ALUOutM(ALUOutM), .DMOutM(DMOutM), .rtdM(rtdM),
                             .RFWEW(RFWEW), .MtoRFSelW(MtoRFSelW),
                             .ALUOutW(ALUOutW), .DMOutW(DMOutW), .rtdW(rtdW));
                        
                       
    mux MTORF (.a(ALUOutW), .b(DMOutW), .sel(MtoRFSelW), .z(ResultW));
    
                                   
    adder PCP1_ADD (.a(PCOut), .b(32'h00000001), .z(PCp1F));
    mux BRANCH (.a(PCp1F), .b(PCBranchM), .sel(PCSelM), .z(PCBtoJ));
    mux JUMP (.a(PCBtoJ), .b(PCJump), .sel(JumpD), .z(PCIn));
    
endmodule

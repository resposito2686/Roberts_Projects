`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/13/2020 03:34:15 PM
// Design Name: 
// Module Name: control_unit
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


module control_unit #(parameter WORD_SIZE = 32)
                     (input [WORD_SIZE - 1 : 0] Inst,
                      input clk, rst,
                      output wire IDSel, ALUIn1Sel, RFDSel, MtoRFSel,
                      IRWE, PCWE, RFWE, MWE, Branch,
                      output wire [1:0] ALUIn2Sel, PCSel,
                      output wire [3:0] ALUSel);
    
    wire [1:0] ALUOp;
                      
    main_decoder MD00 (.OPCode(Inst[31:26]), .clk(clk), .rst(rst), .IDSel(IDSel),
                       .ALUIn1Sel(ALUIn1Sel), .RFDSel(RFDSel), .MtoRFSel(MtoRFSel),
                       .ALUIn2Sel(ALUIn2Sel), .PCSel(PCSel), 
                       .IRWE(IRWE), .PCWE(PCWE), .RFWE(RFWE), .MWE(MWE), 
                       .Branch(Branch), .ALUOp(ALUOp));
                      
    alu_decoder AD00 (.Funct(Inst[5:0]), .ALUOp(ALUOp), 
                      .ALUSel(ALUSel));

endmodule

module main_decoder (input [5:0] OPCode,
                     input clk, rst,
                     output reg IDSel, ALUIn1Sel, RFDSel, MtoRFSel,
                     IRWE, PCWE, RFWE, MWE, Branch,
                     output reg [1:0] ALUIn2Sel, PCSel, ALUOp);
                     
    reg [3:0] state;
    parameter s0 = 4'b0000, s1 = 4'b0001, 
              s2 = 4'b0010, s3 = 4'b0011,
              s4 = 4'b0100, s5 = 4'b0101,
              s6 = 4'b0110, s7 = 4'b0111,
              s8 = 4'b1000, s9 = 4'b1001,
              s10 = 4'b1010, s11 = 4'b1011;
    
    always @ (negedge clk) begin
        if (rst)
            state <= s0;
        else begin
            case (state)
                s0: begin        //FETCH
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'b0;
                    PCSel     <= 2'b00;
                    ALUIn1Sel <= 1'b0;
                    ALUIn2Sel <= 2'b01;
                    
                    //reg enable
                    IRWE   <= 1;
                    PCWE   <= 1;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s1;
                end
                s1: begin        //DECODE
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    case (OPCode)
                        6'b000000: state <= s6;
                        6'b000100: state <= s8;
                        6'b000010: state <= s9;
                        6'b001000: state <= s10;
                        default: state <= s2;
                    endcase
                end
                s2: begin        //MEM ADDR
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'b1;
                    ALUIn2Sel <= 2'b10;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    case (OPCode)
                        6'b100011: state <= s3;
                        6'b101011: state <= s5;
                    endcase
                end
                s3: begin        //MEM READ
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'b1;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s4;
                end
                s4: begin        //RF WRITEBACK
                    //selects
                    MtoRFSel  <= 1'b1;
                    RFDSel    <= 1'b0;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 1;
                    MWE    <= 0;
                    Branch <= 0;
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s0;
                end
                s5: begin        //DATA MEMORY WRITE
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'b1;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 1;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s0;
                end
                s6: begin        //EXECUTE R TYPE
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'b1;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'b1;
                    ALUIn2Sel <= 2'b00;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b10;
                    state <= s7;
                end
                s7: begin        //ALU WRITEBACK
                    //selects
                    MtoRFSel  <= 1'b0;
                    RFDSel    <= 1'b1;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 1;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s0;
                end
                s8: begin        //BRANCH
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'b01;
                    ALUIn1Sel <= 1'b1;
                    ALUIn2Sel <= 2'b00;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 1;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b01;
                    state <= s0;
                end
                s9: begin        //JUMP
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'b10;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 1;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s0;
                end
                s10: begin        //ADDI
                    //selects
                    MtoRFSel  <= 1'bx;
                    RFDSel    <= 1'bx;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'b1;
                    ALUIn2Sel <= 2'b10;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 0;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s11;
                end
                s11: begin        //ADDI PART 2
                    //selects
                    MtoRFSel  <= 1'b0;
                    RFDSel    <= 1'b0;
                    IDSel     <= 1'bx;
                    PCSel     <= 2'bxx;
                    ALUIn1Sel <= 1'bx;
                    ALUIn2Sel <= 2'bxx;
                    
                    //reg enable
                    IRWE   <= 0;
                    PCWE   <= 0;
                    RFWE   <= 1;
                    MWE    <= 0;
                    Branch <= 0;
                    
                    //ALUOp and stage change
                    ALUOp <= 2'b00;
                    state <= s0;
                end
                default: begin
                end
            endcase
        end     
    end        
endmodule

module alu_decoder (input [5:0] Funct,
                    input [1:0] ALUOp,
                    output reg [3:0] ALUSel);
                     
    always @ (*) begin
        case (ALUOp)
            2'b00: begin        //ADD
                ALUSel <= 0;
            end
            2'b01: begin        //SUB
                ALUSel <= 1;
            end
            2'b10: begin
                case (Funct)
                    6'b100000: begin  //ADD
                        ALUSel <= 0;
                    end
                    6'b100010: begin  //SUB
                        ALUSel <= 1;
                    end
                    6'b000000: begin  //SLL
                        ALUSel <= 2;
                    end
                    6'b000010: begin  //SRL
                        ALUSel <= 3;
                    end
                    6'b000100: begin  //SLLV
                        ALUSel <= 4;
                    end
                    6'b000111: begin  //SRAV
                        ALUSel <= 6;
                    end
                    6'b100100: begin  //AND
                        ALUSel <= 8;
                    end
                    6'b100101: begin  //OR
                        ALUSel <= 9;
                    end
                    default: begin
                        ALUSel <= 4'b0000;
                    end
                endcase
            end
            default: ALUSel <=  4'b0000;
        endcase
    end        
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2020 12:59:56 PM
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
                      output wire RFWE, RFDSel, ALUInSel, Branch,
                            DMWE, MtoRFSel, Jump,
                      output wire [3:0] ALUSel);
                      
    wire [1:0] ALUOp;
                      
    main_decoder MD00 (.OPCODE(Inst[31:26]), .RFWE(RFWE), .RFDSel(RFDSel),
                       .ALUInSel(ALUInSel), .Branch(Branch), .DMWE(DMWE),
                       .MtoRFSel(MtoRFSel), .Jump(Jump), .ALUOp(ALUOp));
                       
    alu_decoder AD00 (.FUNCT(Inst[5:0]), .ALUOp(ALUOp), 
                      .ALUSel(ALUSel));
    
endmodule

module main_decoder (input [5:0] OPCODE, 
                     output reg RFWE, RFDSel, ALUInSel, Branch,
                                DMWE, MtoRFSel, Jump,
                     output reg [1:0] ALUOp);
    initial begin
        RFWE     <= 0;
        RFDSel   <= 0;
        ALUInSel <= 0;
        Branch   <= 0;
        DMWE     <= 0;
        MtoRFSel <= 0;
        Jump     <= 0;
        ALUOp    <= 2'b00;
    end
                     
    always @ (OPCODE) begin
        case (OPCODE)
            6'b000000: begin   //R-Type
                RFWE     <= 1;
                RFDSel   <= 1;
                ALUInSel <= 0;
                Branch   <= 0;
                DMWE     <= 0;
                MtoRFSel <= 0;
                Jump     <= 0;
                ALUOp    <= 2'b10;
            end
            6'b100011: begin   //LOAD WORD
                RFWE     <= 1;
                RFDSel   <= 0;
                ALUInSel <= 1;
                Branch   <= 0;
                DMWE     <= 0;
                MtoRFSel <= 1;
                Jump     <= 0;
                ALUOp    <= 2'b00;
            end
            6'b101011: begin   //STORE WORD
                RFWE     <= 0;
                RFDSel   <= 1'bx;
                ALUInSel <= 1;
                Branch   <= 0;
                DMWE     <= 1;
                MtoRFSel <= 1'bx;
                Jump     <= 0;
                ALUOp    <= 2'b00;
            end
            6'b000100: begin   //BEQ
                RFWE     <= 0;
                RFDSel   <= 1'bx;
                ALUInSel <= 0;
                Branch   <= 1;
                DMWE     <= 0;
                MtoRFSel <= 1'bx;
                Jump     <= 0;
                ALUOp    <= 2'b01;
            end
            6'b001000: begin  //ADDI
                RFWE     <= 1;
                RFDSel   <= 0;
                ALUInSel <= 1;
                Branch   <= 0;
                DMWE     <= 0;
                MtoRFSel <= 0;
                Jump     <= 0;
                ALUOp    <= 2'b00;
            end
            6'b000010: begin  //JUMP
                RFWE     <= 0;
                RFDSel   <= 1'bx;
                ALUInSel <= 1'bx;
                Branch   <= 1'bx;
                DMWE     <= 0;
                MtoRFSel <= 1'bx;
                Jump     <= 1;
                ALUOp    <= 2'bxx;
            end     
         endcase
     end
endmodule

module alu_decoder (input [5:0] FUNCT,
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
                case (FUNCT)
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
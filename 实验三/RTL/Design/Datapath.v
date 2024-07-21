`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 11:15:36
// Design Name: 
// Module Name: Datapath
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


module Datapath(clk,rst,Branch,Jump,Inst,RegWrite,RegDst,MemtoReg,ReadData,AluSrc,ALUControl,PC,Inst_ce,ReadData2,ALUResult);
    input clk;
    input rst;//PC
    input Branch;
    input Jump;
    input [25:0] Inst;//Instruction
    input RegWrite;//Regfile
    input RegDst;
    input MemtoReg;
    input [31:0] ReadData;
    input AluSrc;//ALU
    input [2:0] ALUControl;

    output [31:0] PC;//PC
    output Inst_ce;
    output [31:0] ReadData2;//Regfile
    output [31:0] ALUResult;//ALU

    wire [31:0] PC_in;//PC
    wire [31:0] PCa4;
    wire [31:0] Branch_Addr;
    wire [31:0] Mux_ifbranch;
    wire [4:0] ReadReg1,ReadReg2,WriteReg;//Regfile
    wire [31:0] WriteData;
    wire [31:0] ReadData1;
    wire [31:0] SignExtend;//SignExtend
    wire [31:0] A,B;//ALU
    wire Zero;

    assign Branch_Addr=PCa4+{SignExtend[30:0],2'b00};//PC
    assign Mux_ifbranch=((Branch&Zero)==0)?PCa4:Branch_Addr;
    assign PC_in=(Jump==0)?Mux_ifbranch:{PCa4[31:28],Inst,2'b00};
    assign ReadReg1=Inst[25:21];//Regfile
    assign ReadReg2=Inst[20:16];
    assign WriteReg=(RegDst==0)?Inst[20:16]:Inst[15:11];
    assign WriteData=(MemtoReg==0)?ALUResult:ReadData;
    assign SignExtend={{16{Inst[15]}},Inst[15:0]};//SignExtend
    assign A=ReadData1;//ALU
    assign B=(AluSrc==0)?ReadData2:SignExtend;

    PC myPC(clk,rst,PC_in,PC,PCa4,Inst_ce);
    Regfile myRegfile(~clk,RegWrite,ReadReg1,ReadReg2,WriteReg,WriteData,ReadData1,ReadData2);
    ALU myALU(ALUControl,A,B,ALUResult,Zero);
endmodule

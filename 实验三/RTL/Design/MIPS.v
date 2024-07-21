`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 14:02:56
// Design Name: 
// Module Name: MIPS
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


module MIPS(clk,rst,Inst,ReadData,PC,Inst_ce,MemWrite,MemRead,ALUResult,ReadData2);
    input clk;
    input rst;//PC
    input [31:0] Inst;//InstMem
    input [31:0] ReadData;//DataMem

    output [31:0] PC;//PC
    output Inst_ce;
    output MemWrite;//DataMem
    output MemRead;
    output [31:0] ALUResult;
    output [31:0] ReadData2;

    wire [5:0] op,Funct;//Controller
    wire RegWrite;
    wire RegDst;
    wire AluSrc;
    wire Branch;
    wire MemtoReg;
    wire Jump;
    wire [2:0] ALUControl;

    assign op=Inst[31:26];//Controller
    assign Funct=Inst[5:0];

    Controller myController(op,Funct,RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUControl);
    Datapath myDatapath(clk,rst,Branch,Jump,Inst[25:0],RegWrite,RegDst,MemtoReg,ReadData,AluSrc,ALUControl,PC,Inst_ce,ReadData2,ALUResult);
endmodule

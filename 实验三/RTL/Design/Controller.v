`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:50:39
// Design Name: 
// Module Name: Controller
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


module Controller(op,Funct,RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUControl);
    input [5:0] op;
    input [5:0] Funct;
    output RegWrite;
    output RegDst;
    output AluSrc;
    output Branch;
    output MemWrite;
    output MemtoReg;
    output MemRead;
    output Jump;
    output [2:0] ALUControl;

    wire [1:0] ALUOp;
    
    Maindec myMaindec(op,RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUOp);
    Aludec myAludec(ALUOp,Funct,ALUControl);
endmodule

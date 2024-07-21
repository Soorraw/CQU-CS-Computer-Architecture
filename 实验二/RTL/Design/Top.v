`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:52:03
// Design Name: 
// Module Name: Top
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


module Top(clk,rst,RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUControl,enable,segs);
    input clk;
    input rst;
    output RegWrite;
    output RegDst;
    output AluSrc;
    output Branch;
    output MemWrite;
    output MemtoReg;
    output MemRead;
    output Jump;
    output [2:0] ALUControl;
    
    output [7:0] enable;
    output [6:0] segs;

    wire div;
    wire [31:0] pc;
    wire inst_en;
    wire [31:0] inst;

    Clock_1HZ myClock_1HZ(clk,div);
    PC myPC(div,rst,pc,inst_en);
    InstMem myInstMem(.addra(pc),.clka(clk),.douta(inst),.ena(inst_en));
    Controller myController(inst[31:26],inst[5:0],RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUControl);
    Display myDisplay(clk,1,inst,enable,segs);
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 15:01:18
// Design Name: 
// Module Name: top_tb
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


module top_tb();
    reg clk;
    reg rst;
    wire RegWrite;
    wire RegDst;
    wire AluSrc;
    wire Branch;
    wire MemWrite;
    wire MemtoReg;
    wire MemRead;
    wire Jump;
    wire [2:0] ALUControl;

    wire div;
    wire [31:0] pc;
    wire inst_en;
    wire [31:0] inst;

    Clock_1HZ myClock_1HZ(clk,div);
    PC myPC(div,rst,pc,inst_en);
    InstMem myInstMem(.addra(pc),.clka(clk),.douta(inst),.ena(inst_en));
    Controller myController(inst[31:26],inst[5:0],RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUControl);

    always begin 
    #5 clk=~clk;
    $display("RegWrite: %b,RegDst: %b,AluSrc: %b,Branch: %b,MemWrite: %b,MemtoReg: %b,MemRead: %b,Jump: %b,ALUControl: %b",RegWrite,RegDst,AluSrc,Branch,MemWrite,MemtoReg,MemRead,Jump,ALUControl);
    end
    
    initial begin
        clk<=1'b1;
        rst<=1'b0;
    end
endmodule

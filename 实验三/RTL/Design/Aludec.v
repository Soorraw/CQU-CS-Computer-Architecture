`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:52:30
// Design Name: 
// Module Name: Aludec
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


module Aludec(ALUOp,Funct,ALUControl);
    input [1:0] ALUOp;
    input [5:0] Funct;
    output [2:0] ALUControl;

    assign ALUControl=(ALUOp==2'b00)?3'b010://Add
                      (ALUOp==2'b01)?3'b110://Sub
                      (ALUOp==2'b10&&Funct==6'b10_0000)?3'b010://Add
                      (ALUOp==2'b10&&Funct==6'b10_0010)?3'b110://Sub
                      (ALUOp==2'b10&&Funct==6'b10_0100)?3'b000://And
                      (ALUOp==2'b10&&Funct==6'b10_0101)?3'b001://Or
                      (ALUOp==2'b10&&Funct==6'b10_1010)?3'b111:3'bXXX;//SLT
endmodule

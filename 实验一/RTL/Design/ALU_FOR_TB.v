`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 23:58:25
// Design Name: 
// Module Name: ALU_FOR_TB
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


module ALU_FOR_TB(clk,rst,op,num1,results);
    input wire clk;
    input wire rst;
    input wire [2:0] op;
    input wire [7:0] num1;
    output wire [31:0] results;
    
    wire [31:0] num2=32'h01;
    wire [31:0] A,B;
    
    assign A=num2;
    assign B={24'h0,num1};
    assign results=(op==3'b000)?A+B:
                    (op==3'b001)?A-B:
                    (op==3'b010)?A&B:
                    (op==3'b011)?A|B:
                    (op==3'b100)?~A:
                    (op==3'b101)?((A<B)?32'b1:32'b0):32'b0;
endmodule

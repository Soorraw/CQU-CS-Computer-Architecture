`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/27 23:39:40
// Design Name: 
// Module Name: alu_tb
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


module alu_tb();
    reg clk;
    reg rst;
    reg [2:0] op;
    reg [7:0] num1;
    wire [31:0] results;
    
    always #50 clk=~clk;
    
    initial
    begin
        clk<=1'b0;
        rst<=1'b0;
        op<=3'b000;
        num1<=8'b0000_0010;
        #100
        op<=3'b001;
        num1<=8'b1111_1111;
        #100
        op<=3'b010;
        num1<=8'b1111_1110;
        #100
        op<=3'b011;
        num1<=8'b1010_1010;
        #100
        op<=3'b100;
        num1<=8'b1111_0000;
        #100
        op<=3'b101;
        num1<=8'b1000_0001;
        #100
        op<=3'b110;
        #100
        rst<=1'b1;
    end
    
    ALU_FOR_TB myalu(clk,rst,op,num1,results);
endmodule

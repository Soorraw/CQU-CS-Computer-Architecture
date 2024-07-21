`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 08:52:43
// Design Name: 
// Module Name: PC
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


module PC(clk,rst,PC_in,PC,PCa4,Inst_ce);
    input clk;
    input rst;
    input [31:0] PC_in;
    output reg [31:0] PC=32'b0;
    output [31:0] PCa4;
    output Inst_ce;

    assign Inst_ce=1'b1;
    assign PCa4=PC+4;

    always@(posedge clk or posedge rst)
    begin
        if(rst)
            PC<=32'b0;
        else PC<=PC_in;
    end
endmodule

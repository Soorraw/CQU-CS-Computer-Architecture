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


module PC(clk,rst,pc,inst_ce);
    input clk;
    input rst;
    output reg [31:0] pc=32'b0;
    output inst_ce;

    assign inst_ce=1'b1;

    always@(posedge clk or posedge rst)
    begin
        if(rst) begin
            pc<=32'b0;
        end
        else begin
            pc<=pc+4;
        end
    end
endmodule

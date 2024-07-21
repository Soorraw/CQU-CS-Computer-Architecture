`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/21 21:16:43
// Design Name: 
// Module Name: PseudoLRU
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


module PseudoLRU(
    input clk,rst,enable,
    input [2:0] path,
    output [2:0] replace
    );

    reg root;
    reg [1:0] inner;
    reg [3:0] leaf;

    always@(negedge clk)
    begin
        if(rst)
        begin
            root<=1'b0;
            inner<=2'b0;
            leaf<=4'b0;
        end
        else if(enable)
        begin
            {root,inner[path[2]],leaf[path[2:1]]}<=~path;
        end
    end

    assign replace[2]=root;
    assign replace[1]=inner[replace[2]];
    assign replace[0]=leaf[replace[2:1]];
endmodule

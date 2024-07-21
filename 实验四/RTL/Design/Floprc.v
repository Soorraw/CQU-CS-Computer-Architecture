`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/15 20:19:41
// Design Name: 
// Module Name: Floprc
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


module Floprc #(parameter WIDTH=32)(clk,rst,clear,Datain,Dataout);
    input clk;
    input rst;
    input clear;
    input [WIDTH-1:0] Datain;
    output reg [WIDTH-1:0] Dataout=0;

    always@(posedge clk or posedge rst)
    begin
        if(rst)
            Dataout<=0;
        else if(clear)
            Dataout<=0;
        else Dataout<=Datain;
    end 
endmodule

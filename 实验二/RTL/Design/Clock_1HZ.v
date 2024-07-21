`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 10:41:05
// Design Name: 
// Module Name: Clock_1HZ
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


module Clock_1HZ(clk,clk_1hz);
    //parameter MAX_CNT = 32'd10;
    parameter MAX_CNT = 32'd1_0000_0000;
    
    input clk;
    output reg clk_1hz;

    integer cnt=0;

    always @(posedge clk)
    begin
        if(cnt==MAX_CNT)begin
            cnt<=0;
            clk_1hz<=1'b1;        
        end        
        else begin
            cnt<=cnt+1'b1;
            clk_1hz<=1'b0;
        end
    end
endmodule

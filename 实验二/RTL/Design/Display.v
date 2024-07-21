`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/09 16:36:22
// Design Name: 
// Module Name: Display
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


module Display(clk,rst,display,enable,segs);
    parameter MAX_CNT=32'h20000;

    input clk;
    input rst;
    input [31:0] display;
    output reg [7:0] enable;
    output reg [6:0] segs;

    reg div=1'b0;
    reg [2:0] cnt8=3'b0;
    reg [3:0] digits;

    integer cnt=0;

    always@(posedge clk or negedge rst)
    begin
        if(!rst)
        begin
            div=1'b0;
            cnt=0;
        end
        else
        begin
            if(cnt==MAX_CNT)
            begin
                div=1'b1;
                cnt=0;
            end
            else
            begin
                div=1'b0;
                cnt=cnt+1;
            end
        end
    end
    
    always@(posedge div or negedge rst)
    begin
        if(!rst)
        begin
            cnt8=3'b0;
            enable=8'b1111_1111;
        end
        else
        begin
             cnt8=cnt8+1'b1;
             case(cnt8)
                3'b000:enable=8'b1111_1110;
                3'b001:enable=8'b1111_1101;
                3'b010:enable=8'b1111_1011;
                3'b011:enable=8'b1111_0111;
                3'b100:enable=8'b1110_1111;
                3'b101:enable=8'b1101_1111;
                3'b110:enable=8'b1011_1111;
                3'b111:enable=8'b0111_1111;
                default:enable=8'b1111_1111;
             endcase 
        end
    end
    
    always@(cnt8 or display)
    begin
        case(cnt8)
        3'b000:digits=display[3:0];
        3'b001:digits=display[7:4];
        3'b010:digits=display[11:8];
        3'b011:digits=display[15:12];
        3'b100:digits=display[19:16];
        3'b101:digits=display[23:20];
        3'b110:digits=display[27:24];
        3'b111:digits=display[31:28];
        default:digits=4'b0;
        endcase
    end
    
    always@(digits)
    begin
        case(digits)
            4'h0:segs = 7'b000_0001;//0 
            4'h1:segs = 7'b100_1111;//1 
            4'h2:segs = 7'b001_0010;//2 
            4'h3:segs = 7'b000_0110;//3 
            4'h4:segs = 7'b100_1100;//4 
            4'h5:segs = 7'b010_0100;//5 
            4'h6:segs = 7'b010_0000;//6 
            4'h7:segs = 7'b000_1111;//7 
            4'h8:segs = 7'b000_0000;//8 
            4'h9:segs = 7'b000_0100;//9
            4'ha:segs = 7'b000_1000;//a 
            4'hb:segs = 7'b110_0000;//b 
            4'hc:segs = 7'b011_0001;//c 
            4'hd:segs = 7'b100_0010;//d 
            4'he:segs = 7'b011_0000;//e 
            4'hf:segs = 7'b011_1000;//f
            default:segs = 7'b111_1111;
        endcase
    end
endmodule

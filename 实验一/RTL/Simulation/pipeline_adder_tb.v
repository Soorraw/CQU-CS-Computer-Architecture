`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/25 11:03:48
// Design Name: 
// Module Name: pipeline_adder_tb
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


module pipeline_adder_tb();
    reg clk;
    reg rst;
    reg validin;
    reg [31:0] a;
    reg [31:0] b;
    reg carry_in;
    reg out_allow;
    reg [4:1] suspend;
    reg [4:1] refresh;
    wire validout;
    wire [31:0] sum_out;
    wire carry_out;
    
    always #25 clk=~clk;
    //在下行沿进行数据读入，读入的数据在紧随其后的上行沿参与运算
    //X表示该输入可以为任意值，对运算结果没有任何影响（无效输入）
    initial
    begin
        clk<=1'b0;
        rst<=1'b0;
        validin<=1'b1;
        out_allow<=1'b1;      
        a<=32'bXXXXXXXX_XXXXXXXX_XXXXXXXX_00000001;//第一次加法第一級读入
        b<=32'b00000000_00000000_00000000_00000000;
        carry_in<=1'b0;
        suspend<=4'b0000;
        refresh<=4'b0000;
        #50
        a<=32'bXXXXXXXX_XXXXXXXX_00000001_00000010;//第二次加法第一级读入
        #50
        a<=32'bXXXXXXXX_00000001_00000010_00000011;//第三次加法第一级读入
        #50
        a<=32'b00000001_00000010_00000011_00000100;//第一次加法结束，第四次加法第一级读入
        #50
        suspend<=4'b0001;//流水线第二级暂停      
        a<=32'b00000010_00000011_XXXXXXXX_XXXXXXXX;//第二次加法结束，第三次加法运算至第三级，第四次加法第二级运算暂停，读入无效,第五次加法第一级读入无效
        #50
        a<=32'b00000011_XXXXXXXX_XXXXXXXX_XXXXXXXX;//第三次加法结束，第三级读入无效，第四次加法第二级读入无效且运算暂停，第五次加法第一级读入无效
        #50
        suspend<=4'b0000;//流水线恢复流动    
        a<=32'bXXXXXXXX_XXXXXXXX_00000100_00000101;//第三、四级读入无效，第四次加法运算至第二层，第五次加法第一级读入     
        #50
        a<=32'bXXXXXXXX_00000100_00000101_00000110;//第四级读入无效，第四级加法运算至第三层，第五次加法运算至第二层，第六次加法第一级读入
        #50
        a<=32'b00000100_00000101_00000110_00000111;//第四次加法结束，第七次加法第一级读入，流水线完全恢复正常运转
        #50
        a<=32'b00000101_00000110_00000111_00001000;//第五次加法结束，第七次加法运算至第二级，第八次加法第一级读入
        #50
        refresh<=4'b0100;//流水线第三级清空
        a<=32'b00000110_00000111_00001000_XXXXXXXX;//第六次加法结束，第七次加法运算至第三级被清空,第八次加法运算至第二级
        #50
        refresh<=4'b0000;//流水线第三级不清空
        a<=32'b00000111_00001000_XXXXXXXX_XXXXXXXX;//第七次加法无有效输出结果，流水线继续输出第六次加法结果，第八次加法运算至第三层
        #50
        a<=32'b00001000_XXXXXXXX_XXXXXXXX_XXXXXXXX;//第八次加法结束并正常输出运算结果
        #50
        a<=32'bXXXXXXXX_XXXXXXXX_XXXXXXXX_XXXXXXXX;
    end
    
    Pipeline_adder myadder(clk,rst,validin,a,b,carry_in,out_allow,suspend,refresh,validout,sum_out,carry_out);
endmodule

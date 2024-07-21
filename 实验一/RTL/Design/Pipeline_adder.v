`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/22 18:34:37
// Design Name: 
// Module Name: Pipeline_adder
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


module Pipeline_adder(clk,rst,validin,a,b,carry_in,out_allow,suspend,refresh,validout,sum_out,carry_out);
    input clk;
    input rst;
    input validin;
    input [31:0] a;
    input [31:0] b;
    input carry_in;
    input out_allow;
    input [4:1] suspend;
    input [4:1] refresh;
    output validout;
    output reg [31:0] sum_out;
    output reg carry_out;
    
    reg carry_out_t1,carry_out_t2,carry_out_t3;
    reg pipe1_valid;
    reg pipe2_valid;
    reg pipe3_valid; 
    reg pipe4_valid;   
    reg [7:0] sum_out_t1;
    reg [15:0] sum_out_t2;
    reg [23:0] sum_out_t3;
    
    wire pipe1_allowin;
    wire pipe2_allowin;
    wire pipe3_allowin;
    wire pipe4_allowin;    
    wire pipe1_ready_go;
    wire pipe2_ready_go;
    wire pipe3_ready_go;
    wire pipe4_ready_go;
    wire pipe1_to_pipe2_valid;
    wire pipe2_to_pipe3_valid;
    wire pipe3_to_pipe4_valid;
    
    
    assign pipe1_ready_go=!suspend[1];
    assign pipe2_ready_go=!suspend[2];
    assign pipe3_ready_go=!suspend[3];
    assign pipe4_ready_go=!suspend[4];
    assign pipe1_allowin=!pipe1_valid||(pipe1_ready_go&&pipe2_allowin);
    assign pipe2_allowin=!pipe2_valid||(pipe2_ready_go&&pipe3_allowin); 
    assign pipe3_allowin=!pipe3_valid||(pipe3_ready_go&&pipe4_allowin);        
    assign pipe4_allowin=!pipe4_valid||(pipe4_ready_go&&out_allow);
    assign pipe1_to_pipe2_valid=pipe1_valid&&pipe1_ready_go;
    assign pipe2_to_pipe3_valid=pipe2_valid&&pipe2_ready_go;
    assign pipe3_to_pipe4_valid=pipe3_valid&&pipe3_ready_go;
    assign validout=pipe4_valid&&pipe4_ready_go;
        
    always@(posedge clk)
    begin
        if(rst||refresh[1])
        begin 
            pipe1_valid<=1'b0;
        end
        else if(pipe1_allowin)
        begin
            pipe1_valid<=validin;
        end
        if(validin&&pipe1_allowin) 
        begin
            {carry_out_t1,sum_out_t1}<={1'b0,a[7:0]}+{1'b0,b[7:0]}+carry_in;
        end    
    end      
    
    always@(posedge clk)
    begin
        if(rst||refresh[2])
        begin
            pipe2_valid<=1'b0;
        end
        else if(pipe2_allowin)
        begin
            pipe2_valid<=pipe1_to_pipe2_valid;
        end
        if(pipe1_to_pipe2_valid&&pipe2_allowin)
        begin
            {carry_out_t2,sum_out_t2}<={{1'b0,a[15:8]}+{1'b0,b[15:8]}+carry_out_t1,sum_out_t1};
        end
    end
    
    always@(posedge clk)
    begin
        if(rst||refresh[3])
        begin
            pipe3_valid<=1'b0;
        end
        else if(pipe2_allowin)
        begin
            pipe3_valid<=pipe2_to_pipe3_valid;
        end
        if(pipe2_to_pipe3_valid&&pipe3_allowin)
        begin
            {carry_out_t3,sum_out_t3}<={{1'b0,a[23:16]}+{1'b0,b[23:16]}+carry_out_t2,sum_out_t2};
        end
    end
    
    always@(posedge clk)
    begin
        if(rst||refresh[4])
        begin
            pipe4_valid<=1'b0;
        end
        else if(pipe4_allowin)
        begin
            pipe4_valid<=pipe3_to_pipe4_valid;
        end
        if(pipe3_to_pipe4_valid&&pipe4_allowin)
        begin
            {carry_out,sum_out}<={{1'b0,a[31:24]}+{1'b0,b[31:24]}+carry_out_t3,sum_out_t3};
        end
    end
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/14 14:57:36
// Design Name: 
// Module Name: CPU1
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


module CPU1();
    reg clk;
    reg rst;

    wire [31:0] Inst;
    wire [31:0] ReadData;
    wire [31:0] PC;
    wire Inst_ce;
    wire MemWrite;
    wire MemRead;
    wire [31:0] ALUResult;
    wire [31:0] ReadData2;

    always #30 clk=~clk;
    initial 
    begin
        clk<=0;
        rst<=0;
    end

	always @(negedge clk) begin
		if(MemWrite) begin
			/* code */
			if(ALUResult=== 84 & ReadData2 === 7) begin
				/* code */
				$display("Simulation succeeded");
				$stop;
			end else if(ALUResult !== 80) begin
				/* code */
				$display("Simulation Failed");
				$stop;
			end
		end
	end

    MIPS myMIPS(clk,rst,Inst,ReadData,PC,Inst_ce,MemWrite,MemRead,ALUResult,ReadData2);
    InstMem myInstMem(.clka(~clk),.ena(Inst_ce),.addra(PC),.douta(Inst));
    DataMem myDataMem(.clka(~clk),.ena(MemWrite|MemRead),.rsta(rst),.wea({4{MemWrite}}),.addra(ALUResult),.dina(ReadData2),.douta(ReadData));
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: alu
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


module alu
#(parameter DATA_WIDTH = 32)
(
    input [DATA_WIDTH-1:0] Regf_data1,
    input [4:0] sa,
    input [DATA_WIDTH-1:0] Regf_data2,
    input [DATA_WIDTH-1:0] s_z_extend,    
    input [2:0] ALU_op,
    input ALU_SrcA,
    input ALU_SrcB,
    
    output zero,
    output sign,
    output reg [DATA_WIDTH-1:0] Result
    );
	parameter _ADD=	3'b000;
	parameter _SUB=	3'b001;
	parameter _SLL=	3'b010;
	parameter _OR=	3'b011;
	parameter _AND=	3'b100;
	parameter _SLTU=	3'b101;
	parameter _SLT=	3'b110;
	parameter _XOR=	3'b111;

	assign zero=	Result==0;
	assign sign=	Result[31];    
	
wire [DATA_WIDTH-1:0] ALU_A;
wire [DATA_WIDTH-1:0] ALU_B;
assign ALU_A = ALU_SrcA? {27'b000000000000000000000000000,sa}:Regf_data1;
assign ALU_B = ALU_SrcB? s_z_extend:Regf_data2;



always@(*)
    case(ALU_op)
    _ADD: Result = ALU_A + ALU_B;
    _SUB: Result = ALU_A - ALU_B;
    _SLL: Result = ALU_B << ALU_A;
    _OR: Result = ALU_A | ALU_B;
    _AND: Result = ALU_A & ALU_B;
    _SLTU: Result = ALU_A < ALU_B;
    _SLT: Result = ALU_A[31]!=ALU_B[31]?ALU_A[31]>ALU_B[31]:ALU_A<ALU_B;
    _XOR: Result = ALU_A ^ ALU_B;
    default: Result = 0;
    endcase
endmodule

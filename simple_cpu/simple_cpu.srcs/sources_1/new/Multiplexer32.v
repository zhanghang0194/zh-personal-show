`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/11 17:24:22
// Design Name: 
// Module Name: Multiplexer32
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

module Multiplexer32(
	input Select,
	input[31:0] DataIn1,
	input[31:0] DataIn2,
	output[31:0] DataOut
);
	assign DataOut=	Select?DataIn2:DataIn1;
endmodule

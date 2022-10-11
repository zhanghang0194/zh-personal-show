`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/11 17:24:33
// Design Name: 
// Module Name: Multiplexer5
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


module Multiplexer5(
	input Select,
	input[4:0] DataIn1,
	input[4:0] DataIn2,
	output[4:0] DataOut
);
	assign DataOut=	Select?DataIn2:DataIn1;
endmodule
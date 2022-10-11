`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: i_mem
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


module i_mem
#(  parameter i_mem_addr_width = 32,
    parameter i_mem_data_width = 32
)
(
    input i_mem_rw,
    input [i_mem_addr_width-1:0]i_mem_addr,
    input [i_mem_data_width-1:0]i_mem_data_in,
    output [i_mem_data_width-1:0]i_mem_data_out
    );
reg[i_data_width-1:0] mem [i_addr_width-1:0];    
assign i_mem_data_out = mem[i_mem_addr];
assign mem[i_mem_addr] = (i_mem_rw)?i_mem_data_in:mem[i_mem_addr];
endmodule

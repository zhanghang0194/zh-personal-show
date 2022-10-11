`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: d_mem
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


module d_mem
#(  parameter d_addr_width = 32,
    parameter d_data_width = 32
)
(
    input clk,
    input d_mem_wr,
    input d_mem_rd,
    input [d_addr_width-1:0] d_addr,
    input [d_data_width-1:0] d_data_in,
    output[d_data_width-1:0] d_data_out
    );
reg[d_data_width-1:0] mem [d_addr_width-1:0];
always@(posedge clk)
    if(d_mem_wr) 
        mem[d_addr] <= d_data_in;
    else
        mem[d_addr] <=  mem[d_addr];
        
always@(posedge clk)
    if(d_mem_rd) 
        d_data_out <= mem[d_addr];
    else
        d_data_out <=  0;
endmodule

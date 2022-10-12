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
//              该部分控制内存存储，用于内存存储、读写。
//              用 255 大小的 8 位寄存器数组模拟内存，采用小端模式。
//              DataMenRW 控制内存读写。
//              由于指令为真实地址，所以不需要<<2。
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
reg[7:0] mem [255:0];   //用 255 大小的 8 位寄存器数组模拟内存，采用小端模式。
//写操作，在时钟下降沿写入数据
always@(negedge clk)
    if(d_mem_wr) begin
        mem[d_addr+3] <= d_data_in[7:0];
        mem[d_addr+2] <= d_data_in[15:8];
        mem[d_addr+1] <= d_data_in[23:16];
        mem[d_addr+0] <= d_data_in[31:24];
    end
//读操作，不受时序影响，当地址或读信号变化时读取数据        
always@(d_mem_rd or d_addr)     //电平触发？
    if(d_mem_rd) begin
        d_data_out[7:0]   = mem[d_addr+3];
        d_data_out[15:8]  = mem[d_addr+2];
        d_data_out[23:16] = mem[d_addr+1];
        d_data_out[31:24] = mem[d_addr+0];
    end
endmodule

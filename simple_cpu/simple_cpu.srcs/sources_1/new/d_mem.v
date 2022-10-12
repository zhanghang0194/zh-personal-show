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
//              �ò��ֿ����ڴ�洢�������ڴ�洢����д��
//              �� 255 ��С�� 8 λ�Ĵ�������ģ���ڴ棬����С��ģʽ��
//              DataMenRW �����ڴ��д��
//              ����ָ��Ϊ��ʵ��ַ�����Բ���Ҫ<<2��
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
reg[7:0] mem [255:0];   //�� 255 ��С�� 8 λ�Ĵ�������ģ���ڴ棬����С��ģʽ��
//д��������ʱ���½���д������
always@(negedge clk)
    if(d_mem_wr) begin
        mem[d_addr+3] <= d_data_in[7:0];
        mem[d_addr+2] <= d_data_in[15:8];
        mem[d_addr+1] <= d_data_in[23:16];
        mem[d_addr+0] <= d_data_in[31:24];
    end
//������������ʱ��Ӱ�죬����ַ����źű仯ʱ��ȡ����        
always@(d_mem_rd or d_addr)     //��ƽ������
    if(d_mem_rd) begin
        d_data_out[7:0]   = mem[d_addr+3];
        d_data_out[15:8]  = mem[d_addr+2];
        d_data_out[23:16] = mem[d_addr+1];
        d_data_out[31:24] = mem[d_addr+0];
    end
endmodule

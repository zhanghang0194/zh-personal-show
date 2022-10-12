`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: regfile
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


module regfile
#(  parameter REGF_WIDTH =5,
    parameter REGF_DATA_WIDTH =32
)
(
    input clk,
    input we,
    input [REGF_WIDTH-1:0] Read_Reg1,
    input [REGF_WIDTH-1:0] Read_Reg2,
    input [REGF_WIDTH-1:0] Write_Reg,
    input [REGF_DATA_WIDTH-1:0] Write_Data,
    
    output [REGF_DATA_WIDTH-1:0] Read_Data1,
    output [REGF_DATA_WIDTH-1:0] Read_Data2
    );
    reg [31:0] registers [0:31];//?Ϊɶд��[0:31]
    //��ʼʱ����32���Ĵ���ȫ����ֵΪ0
    integer i;
    initial begin
        for(i=0; i<32; i=i+1)registers[i]<=	0;
    end
    //���Ĵ���ֻ��Ҫ�ṩ��ַ������Ҫʱ��Ϳ����ź�
    assign Read_Data1 = Read_Reg1? registers[Read_Reg1]:0;
    assign Read_Data2 = Read_Reg2? registers[Read_Reg2]:0;
    //д�Ĵ�����Ҫ�ṩ��ַ�Ϳ����źţ������½��ؽ���д��
    always @(negedge clk)
        if(Write_Reg&&we)
            registers[Write_Reg] <= Write_Data;
endmodule

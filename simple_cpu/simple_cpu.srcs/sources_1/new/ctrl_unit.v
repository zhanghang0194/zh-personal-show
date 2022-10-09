`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/09 15:27:51
// Design Name: 
// Module Name: ctrl_unit
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//              ���幦�ܣ�����OPָ��ִ�и��������
//              ����1����ALU���мӼ��˳����ǣ���һ��һ�£����������ֲ�����Ҫ3bit�ܹ�����
//              ����2�����MUXѡ�����Ŀ��ƶ˿��ƣ�PCsrc��rt/rd��result/d_mem_out��ALUsrca��ALUsrcb��
//              ����3�����ݼĴ�����д�ź�wr,rd��ָ��Ĵ�����д�ź�rw��regfile�Ķ�д�ź�Regwre
//              ����4��S/Zextendģ��ѡ���ź�Extsel
//              ����5��PC�Ĵ�����д�ź�PC_wre
//              
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ctrl_unit(
input [5:0] op,
input zero,
input sign,
output [2:0]ALUop,      //ALU����ָ��Ӽ��˳����� ��7��
output [1:0]PCmux,      //PCָ���ѡ����PC+4��PC+ext��PC+addr
output ALUsrcA,         //ALU A�������ѡ RegD1 or sa
output ALUsrcB,         //ALU B�������ѡ RegD2 or ext
output regf_wri_reg,    //rt  or  rd
output regf_wri_data,   //result  or  d_mem_out
output d_mem_wr,
output d_mem_rd,
output i_mem_rw,
output regf_wre,
output Extsel,          //��ע��
output PC_wre
    );


endmodule

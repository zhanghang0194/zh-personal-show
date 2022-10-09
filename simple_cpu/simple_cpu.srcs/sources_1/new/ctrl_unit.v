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
//              ����1����ALU���м�/��/����/��/��/�����űȽ�/�������űȽ�/�����������ֲ�����Ҫ3bit�ܹ�����
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

parameter ADD = 6'b000000;//��
parameter SUB = 6'b000001;//��
parameter ADDIU = 6'b000010;//��
parameter ANDI = 6'b010000;//��
parameter AND = 6'b010001;//��
parameter ORI = 6'b010010;//��
parameter OR = 6'b010011;//��
parameter SLL = 6'b011000;//��λ

parameter SLTI = 6'b011100;//�Ƚ�
parameter SW = 6'b100110;//�Ĵ�����д
parameter LW = 6'b100111;//�Ĵ�����д
parameter BEQ = 6'b110000;//��֧1
parameter BNE = 6'b110001;//��֧2
parameter BLTZ = 6'b110010;//��֧3

parameter J = 6'b111000; //��ת

parameter HALT = 6'b111111;//ͣ��

parameter _ADD = 3'b000;
parameter _SUB = 3'b001;
parameter _SLL = 3'b010;
parameter _OR = 3'b011;
parameter _AND =3'b100;
parameter _SLTU = 3'b101;
parameter _SLT = 3'b110;
parameter _XOR = 3'b111;

assign PC_wre = op!=HALT;   //op������halt��PC��������


endmodule

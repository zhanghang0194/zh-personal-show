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
//              大体功能：根据OP指令执行各类操作；
//              具体1：让ALU进行加/减/左移/或/与/带符号比较/不带符号比较/异或操作，八种操作需要3bit能够覆盖
//              具体2：多个MUX选择器的控制端控制（PCsrc、rt/rd、result/d_mem_out、ALUsrca、ALUsrcb）
//              具体3：数据寄存器读写信号wr,rd；指令寄存器读写信号rw、regfile的读写信号Regwre
//              具体4：S/Zextend模块选择信号Extsel
//              具体5：PC寄存器读写信号PC_wre
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
output [2:0]ALUop,      //ALU功能指令：加减乘除与或非 ，7个
output [1:0]PCmux,      //PC指令多选器：PC+4、PC+ext、PC+addr
output ALUsrcA,         //ALU A口输入多选 RegD1 or sa
output ALUsrcB,         //ALU B口输入多选 RegD2 or ext
output regf_wri_reg,    //rt  or  rd
output regf_wri_data,   //result  or  d_mem_out
output d_mem_wr,
output d_mem_rd,
output i_mem_rw,
output regf_wre,
output Extsel,          //待注释
output PC_wre
    );

parameter ADD = 6'b000000;//加
parameter SUB = 6'b000001;//减
parameter ADDIU = 6'b000010;//加
parameter ANDI = 6'b010000;//与
parameter AND = 6'b010001;//与
parameter ORI = 6'b010010;//或
parameter OR = 6'b010011;//或
parameter SLL = 6'b011000;//移位

parameter SLTI = 6'b011100;//比较
parameter SW = 6'b100110;//寄存器读写
parameter LW = 6'b100111;//寄存器读写
parameter BEQ = 6'b110000;//分支1
parameter BNE = 6'b110001;//分支2
parameter BLTZ = 6'b110010;//分支3

parameter J = 6'b111000; //跳转

parameter HALT = 6'b111111;//停机

parameter _ADD = 3'b000;
parameter _SUB = 3'b001;
parameter _SLL = 3'b010;
parameter _OR = 3'b011;
parameter _AND =3'b100;
parameter _SLTU = 3'b101;
parameter _SLT = 3'b110;
parameter _XOR = 3'b111;

assign PC_wre = op!=HALT;   //op不等于halt，PC正常工作


endmodule

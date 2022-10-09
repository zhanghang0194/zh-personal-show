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
//              具体1：让ALU进行加减乘除与或非（不一定一致）操作，七种操作需要3bit能够覆盖
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


endmodule

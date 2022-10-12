`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: cpu_top
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


module cpu_top
#(  parameter DATA_WIDTH =32,
    parameter d_addr_width = 32,
    parameter d_data_width = 32,
    parameter i_mem_addr_width = 32,
    parameter i_mem_data_width = 32,
    parameter addr_width = 32,
    parameter REGF_WIDTH =5,
    parameter REGF_DATA_WIDTH =32,
    parameter IMME_WIDTH = 16,
    parameter EXTEND_WIDTH =32
)
(
    input clk,
    input rstn,
    
    output reg [addr_width-1:0]PC_addr,//当前指令地址
//	output[31:0] newaddress,	//下一个指令地址
	output[31:0] i_mem_data_out,	//rs,rt寄存器所在指令
	output[31:0] Read_Reg1,	//寄存器组rs寄存器的值
	output[31:0] Read_Reg2,	//寄存器组rt寄存器的值
	output[31:0] Result,	//ALU的result输出值
	output[31:0] Write_Data	//DB总线值
    );
wire [5:0] op;
wire [2:0] ALUop;
wire [1:0] PCmux;
wire zero,sign,ALU_SrcA,ALU_SrcB,regf_wri_reg,regf_wri_data,
d_mem_wr,d_mem_rd,i_mem_rw,regf_wre,Extsel,PC_wre;


ctrl_unit u_ctrl_unit(
.op(op),
.zero(zero),             //zero=1，运算结果为0
.sign(sign),             //sign=0, 运算结果为正数
.ALUop(ALUop),      //ALU功能指令：加/减/左移/或/与/sign比较/unsign比较/异或 ，8个
.PCmux(PCmux),      //PC指令多选器：PC+4、PC+ext、PC+addr
.ALUsrcA(ALUsrcA),         //ALU A口输入多选 RegD1 or sa
.ALUsrcB(ALUsrcB),         //ALU B口输入多选 RegD2 or ext
.regf_wri_reg(regf_wri_reg),    //rt  or  rd
.regf_wri_data(regf_wri_data),   //result  or  d_mem_out
.d_mem_wr(d_mem_wr),        //写数据寄存器SW
.d_mem_rd(d_mem_rd),        //读数据寄存器LW
.i_mem_rw(i_mem_rw),        //始终=0，写指令存储器
.regf_wre(regf_wre),        //寄存器组写使能信号
.Extsel(Extsel),          //Extsel 扩展选择信号，=0，0（zero）扩展，=1，符号(sign)扩展
.PC_wre(PC_wre)           //PC正常运行指令，halt时停止，其余状态正常工作
);

wire [DATA_WIDTH-1:0] Regf_data1;
wire [DATA_WIDTH-1:0] sa;
wire [DATA_WIDTH-1:0] Regf_data2;
wire [DATA_WIDTH-1:0] s_z_extend;
wire [DATA_WIDTH-1:0] Result;
alu u_alu(
.Regf_data1(Regf_data1),
.sa(sa),
.Regf_data2(Regf_data2),
.s_z_extend(s_z_extend),    
.ALU_op(ALUop),
.ALU_SrcA(ALU_SrcA),
.ALU_SrcB(ALU_SrcB),
    
.zero(zero),
.sign(sign),
.Result(Result)
);

wire [d_addr_width-1:0] d_addr;
wire [d_data_width-1:0] d_data_in;
wire [d_data_width-1:0] d_data_out;

d_mem u_d_mem(
.clk(clk),
.d_mem_wr(d_mem_wr),
.d_mem_rd(d_mem_rd),
.d_addr(d_addr),
.d_data_in(d_data_in),
.d_data_out(d_data_out)
);
wire [i_mem_addr_width-1:0]i_mem_addr;
wire [i_mem_data_width-1:0]i_mem_data_in;
wire [i_mem_data_width-1:0]i_mem_data_out;

i_mem u_i_mem(
.i_mem_rw(i_mem_rw),
.i_mem_addr(i_mem_addr),
.i_mem_data_in(i_mem_data_in),
.i_mem_data_out(i_mem_data_out)
);

wire [25:0]d_mem_out;      //addr
wire PC_wre;

wire [addr_width-1:0] PC_addr;
pc_reg u_pc_reg(
.clk(clk),
.rstn(rstn),
.PC_wre(PC_wre),
.PCMux(PCmux),
.d_mem_out(d_data_out),      //addr
.s_z_extend(s_z_extend),     //imme
.PC_addr(PC_addr)
);

Multiplexer5 u_Multiplexer5(
.Select(regf_wri_reg),
.DataIn1(i_mem_data_out[20:16]),
.DataIn2(i_mem_data_out[15:11]),
.DataOut(Write_Reg)
);

wire [REGF_WIDTH-1:0] Write_Reg;
wire [REGF_DATA_WIDTH-1:0] Write_Data;
    
wire [REGF_DATA_WIDTH-1:0] Read_Data1;
wire [REGF_DATA_WIDTH-1:0] Read_Data2;



regfile u_regfile(
.clk(clk),
.we(PC_wre),
.Read_Reg1(i_mem_data_out[25:21]),
.Read_Reg2(i_mem_data_out[20:16]),
.Write_Reg(Write_Reg),
.Write_Data(Write_Data),
    
.Read_Data1(Regf_data1),
.Read_Data2(Regf_data2)
);




SignZeroExtend u_SignZeroExtend(
.immediate(i_mem_data_out[IMME_WIDTH-1:0]),
.Extsel(Extsel),
    
.s_z_extend(s_z_extend)
);

Multiplexer32 u_Multiplexer32(
.Select(regf_wri_data),
.DataIn1(Result),
.DataIn2(d_mem_out),
.DataOut(Write_Data)
);
endmodule

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
    input rstn
    

    );

wire [2:0] ALUop;
wire [1:0] PCmux;
wire zero,sign,ALU_SrcA,ALU_SrcB,regf_wri_reg,regf_wri_data,
d_mem_wr,d_mem_rd,i_mem_rw,regf_wre,Extsel,PC_wre;
wire [i_mem_data_width-1:0]i_mem_data_in;
wire [i_mem_data_width-1:0]i_mem_data_out;

ctrl_unit u_ctrl_unit(
.op(i_mem_data_out[31:26]),
.zero(zero),             //zero=1��������Ϊ0
.sign(sign),             //sign=0, ������Ϊ����
.ALUop(ALUop),      //ALU����ָ���/��/����/��/��/sign�Ƚ�/unsign�Ƚ�/��� ��8��
.PCmux(PCmux),      //PCָ���ѡ����PC+4��PC+ext��PC+addr
.ALUsrcA(ALU_SrcA),         //ALU A�������ѡ RegD1 or sa
.ALUsrcB(ALU_SrcB),         //ALU B�������ѡ RegD2 or ext
.regf_wri_reg(regf_wri_reg),    //rt  or  rd
.regf_wri_data(regf_wri_data),   //result  or  d_mem_out
.d_mem_wr(d_mem_wr),        //д���ݼĴ���SW
.d_mem_rd(d_mem_rd),        //�����ݼĴ���LW
.i_mem_rw(i_mem_rw),        //ʼ��=0��дָ��洢��
.regf_wre(regf_wre),        //�Ĵ�����дʹ���ź�
.Extsel(Extsel),          //Extsel ��չѡ���źţ�=0��0��zero����չ��=1������(sign)��չ
.PC_wre(PC_wre)           //PC��������ָ�haltʱֹͣ������״̬��������
);

wire [DATA_WIDTH-1:0] Regf_data1;
wire [DATA_WIDTH-1:0] Regf_data2;
wire [DATA_WIDTH-1:0] s_z_extend;
wire [DATA_WIDTH-1:0] Result;
alu u_alu(
.Regf_data1(Regf_data1),
.sa(i_mem_data_out[10:6]),
.Regf_data2(Regf_data2),
.s_z_extend(s_z_extend),    
.ALU_op(ALUop),
.ALU_SrcA(ALU_SrcA),
.ALU_SrcB(ALU_SrcB),
    
.zero(zero),
.sign(sign),
.Result(Result)
);

wire [d_data_width-1:0] d_data_out;

d_mem u_d_mem(
.clk(clk),
.d_mem_wr(d_mem_wr),
.d_mem_rd(d_mem_rd),
.d_addr(Result),
.d_data_in(Regf_data2),
.d_data_out(d_data_out)
);



wire [25:0]d_mem_out;      //addr


wire [addr_width-1:0] PC_addr;
pc_reg u_pc_reg(
.clk(clk),
.rstn(rstn),
.PC_wre(PC_wre),
.PCMux(PCmux),
.i_mem_out(i_mem_data_out[25:0]),       //addr
.s_z_extend(s_z_extend),                //imme
.PC_addr(PC_addr)
);


i_mem u_i_mem(
.i_mem_rw(i_mem_rw),
.i_mem_addr(PC_addr),
.i_mem_data_in(i_mem_data_in),
.i_mem_data_out(i_mem_data_out)
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
.DataIn2(d_data_out),
.DataOut(Write_Data)
);
endmodule

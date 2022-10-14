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
input zero,             //zero=1，运算结果为0
input sign,             //sign=0, 运算结果为正数
output reg [2:0]ALUop,      //ALU功能指令：加/减/左移/或/与/sign比较/unsign比较/异或 ，8个
output reg [1:0]PCmux,      //PC指令多选器：PC+4、PC+ext、PC+addr
output ALUsrcA,         //ALU A口输入多选 RegD1 or sa
output ALUsrcB,         //ALU B口输入多选 RegD2 or ext
output regf_wri_reg,    //rt  or  rd
output regf_wri_data,   //result  or  d_mem_out
output d_mem_wr,        //写数据寄存器SW
output d_mem_rd,        //读数据寄存器LW
output i_mem_rw,        //始终=0，写指令存储器
output regf_wre,        //寄存器组写使能信号
output Extsel,          //Extsel 扩展选择信号，=0，0（zero）扩展，=1，符号(sign)扩展
output PC_wre           //PC正常运行指令，halt时停止，其余状态正常工作
    );

parameter ADD = 6'b000000;//加 rd<- rs+rt
parameter SUB = 6'b000001;//减 rd<- rs -rt
parameter ADDIU = 6'b000010;//加 rt<- rs+(s-e)imme
parameter ANDI = 6'b010000;//与 rt<- rs&(z-e)imme
parameter AND = 6'b010001;//与 rd<- rs&rt
parameter ORI = 6'b010010;//或 rt<- rs|(z-e)imme
parameter OR = 6'b010011;//或 rd<- rs|rt;
parameter SLL = 6'b011000;//移位 rd<- rt <<(z-e)sa

parameter SLTI = 6'b011100;//比较 if(rs<(s-e)imme) rt=1;else rt=0
parameter SW = 6'b100110;//寄存器读写 mem[rs+(s-e)imme]<-rt
parameter LW = 6'b100111;//寄存器读 rt<-mem[rs+(s-e)imme]
parameter BEQ = 6'b110000;//分支1 if(rs=rt) pc+4+((s-e)imme<<2);else pc+4
parameter BNE = 6'b110001;//分支2 if(rs!=rt) pc+4+((s-e)imme<<2);else pc+4
parameter BLTZ = 6'b110010;//分支3 if rs<$zero:pc+4+((s-e)imme<<2);else pc+4

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

assign PC_wre = op!=HALT;   //op不等于halt（停机），PCwre=1正常工作
assign ALUsrcA = op==SLL;    //op等于SLL（移位），则ALUsrcA=1
assign ALUsrcB = op==ADDIU||op==ANDI||op==ORI||op==SLTI||op==SW||op==LW;//op（立即数相关），=1
assign regf_wri_data = op== LW; //op（数据存储器的输出相关）
assign regf_wri_reg = op!=ADDIU && op!=ANDI && op!=ORI && op!=SLTI && op!=LW;//op(写寄存器组的地址，0来自rt（立即数相关），1来自rd)
always@(*)
    case(op)
        J: PCmux = 'b10;//pc <= {(pc+4)[31:28],addr[27:2],2'b00};
        BEQ:if(zero==1) PCmux = 'b01;//pc <= pc +4 +(sign-ext)imme <<2
        BNE:if(zero==0) PCmux = 'b01;
        BLTZ:if(sign==1) PCmux = 'b01;
        default: PCmux = 'b00;
    endcase
//assign PCmux[0]=	op==J;
//assign PCmux[1]=	op==BEQ&&zero==1||op==BNE&&zero==0||op==BLTZ&&sign==1;
assign d_mem_wr = op==SW;//数据存储器的输出相关(写)rt->（rs+imm）
assign d_mem_rd = op==LW;//数据存储器的输出相关(读)（rs+imm）->rt
assign i_mem_rw = 0;//始终写，指令寄存器不涉及读写逻辑变化？
assign regf_wre = op!=BEQ && op!=BNE && op!=BLTZ && op!=SW && op!= HALT;//寄存器组写使能信号
assign Extsel = op!=ANDI && op!=ORI;//=0:zero-extend,0扩展;=1:sign-extend 符号扩展
always@(*)
    case(op)
    SLTI:ALUop = _SLT;
    AND:ALUop = _AND;
    ANDI:ALUop = _AND;
    OR:ALUop = _OR;
    ORI:ALUop = _OR;
    SLL:ALUop = _SLL;
    SUB:ALUop = _SUB;
    BEQ:ALUop = _SUB;
    BNE:ALUop = _SUB;
    BLTZ:ALUop = _SUB;
    default:ALUop = _ADD;
    endcase
/*	assign ALUOp=	op==SUB||op==BNE||op==BEQ||op==BLTZ?_SUB:
					op==SLL?_SLL:
					op==ORI||op==OR?_OR:
					op==ANDI||op==AND?_AND:
					op==SLTI?_SLT:_ADD;
*/
endmodule

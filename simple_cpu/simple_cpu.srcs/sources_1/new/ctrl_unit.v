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
input zero,             //zero=1��������Ϊ0
input sign,             //sign=0, ������Ϊ����
output reg [2:0]ALUop,      //ALU����ָ���/��/����/��/��/sign�Ƚ�/unsign�Ƚ�/��� ��8��
output reg [1:0]PCmux,      //PCָ���ѡ����PC+4��PC+ext��PC+addr
output ALUsrcA,         //ALU A�������ѡ RegD1 or sa
output ALUsrcB,         //ALU B�������ѡ RegD2 or ext
output regf_wri_reg,    //rt  or  rd
output regf_wri_data,   //result  or  d_mem_out
output d_mem_wr,        //д���ݼĴ���SW
output d_mem_rd,        //�����ݼĴ���LW
output i_mem_rw,        //ʼ��=0��дָ��洢��
output regf_wre,        //�Ĵ�����дʹ���ź�
output Extsel,          //Extsel ��չѡ���źţ�=0��0��zero����չ��=1������(sign)��չ
output PC_wre           //PC��������ָ�haltʱֹͣ������״̬��������
    );

parameter ADD = 6'b000000;//�� rd<- rs+rt
parameter SUB = 6'b000001;//�� rd<- rs -rt
parameter ADDIU = 6'b000010;//�� rt<- rs+(s-e)imme
parameter ANDI = 6'b010000;//�� rt<- rs&(z-e)imme
parameter AND = 6'b010001;//�� rd<- rs&rt
parameter ORI = 6'b010010;//�� rt<- rs|(z-e)imme
parameter OR = 6'b010011;//�� rd<- rs|rt;
parameter SLL = 6'b011000;//��λ rd<- rt <<(z-e)sa

parameter SLTI = 6'b011100;//�Ƚ� if(rs<(s-e)imme) rt=1;else rt=0
parameter SW = 6'b100110;//�Ĵ�����д mem[rs+(s-e)imme]<-rt
parameter LW = 6'b100111;//�Ĵ����� rt<-mem[rs+(s-e)imme]
parameter BEQ = 6'b110000;//��֧1 if(rs=rt) pc+4+((s-e)imme<<2);else pc+4
parameter BNE = 6'b110001;//��֧2 if(rs!=rt) pc+4+((s-e)imme<<2);else pc+4
parameter BLTZ = 6'b110010;//��֧3 if rs<$zero:pc+4+((s-e)imme<<2);else pc+4

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

assign PC_wre = op!=HALT;   //op������halt��ͣ������PCwre=1��������
assign ALUsrcA = op==SLL;    //op����SLL����λ������ALUsrcA=1
assign ALUsrcB = op==ADDIU||op==ANDI||op==ORI||op==SLTI||op==SW||op==LW;//op����������أ���=1
assign regf_wri_data = op== LW; //op�����ݴ洢���������أ�
assign regf_wri_reg = op!=ADDIU && op!=ANDI && op!=ORI && op!=SLTI && op!=LW;//op(д�Ĵ�����ĵ�ַ��0����rt����������أ���1����rd)
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
assign d_mem_wr = op==SW;//���ݴ洢����������(д)rt->��rs+imm��
assign d_mem_rd = op==LW;//���ݴ洢����������(��)��rs+imm��->rt
assign i_mem_rw = 0;//ʼ��д��ָ��Ĵ������漰��д�߼��仯��
assign regf_wre = op!=BEQ && op!=BNE && op!=BLTZ && op!=SW && op!= HALT;//�Ĵ�����дʹ���ź�
assign Extsel = op!=ANDI && op!=ORI;//=0:zero-extend,0��չ;=1:sign-extend ������չ
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

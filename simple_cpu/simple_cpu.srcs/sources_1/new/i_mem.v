`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: i_mem
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
/*          �ò���Ϊָ��Ĵ�����ͨ��һ�� 256 ��С�� 8 λ�Ĵ���������������ļ������ȫ��ָ�
            Ȼ��ͨ������ĵ�ַ���ҵ���Ӧ��ָ������ IDataOut��
            ָ��洢���Ĺ����Ǵ洢��������� 32-bit λ���ָ�
            ���ݳ�������� PC �е�ָ���ַ����ȡָ���������ָ�����ͽ��з�����
            ͨ��ָ�����Ͷ���ȡָ��ĸ��ֶν�������ʶ����󽫶�Ӧ���ִ��ݸ�����ģ����к�������
            
            ָ��洢����ÿ����Ԫ��λ��Ϊ 8-bit��Ҳ���Ǵ洢ÿ�� 32-bit λ���ָ���Ҫռ�� 4 ����Ԫ��
            ���Ե� n��n ���ڻ���� 0����ָ������Ӧ����ʼ��ַΪ 4n����ռ�ݵ� 4n��4n+1��4n+2��4n+3 ���ĸ���Ԫ��
            ȡ��ָ����ǽ����ĸ���Ԫ�ֱ�ȡ������Ϊָ��Ĵ洢���Ӹ�λָ��洢�ڵ�λ��ַ�Ĺ���
            ���� 4n ��Ԫ�е��ֶ��Ǹ���ָ������ 8 λ�������Դ����ƣ���ͨ�����Ʋ�����ָ����ĸ���Ԫ�����ƶ������Ӧ��λ�ã�
            �Դ����õ�����ָ�
*/
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i_mem
#(  parameter i_mem_addr_width = 32,
    parameter i_mem_data_width = 32
)
(
    input i_mem_rw,
    input [i_mem_addr_width-1:0]i_mem_addr,
    input [i_mem_data_width-1:0]i_mem_data_in,
    output reg [i_mem_data_width-1:0]i_mem_data_out
    );
    reg[7:0] mem [255:0];
    //ͨ��һ�� 256 ��С�� 8 λ�Ĵ���������������ļ������ȫ��ָ�
    //Ȼ��ͨ������ĵ�ַ���ҵ���Ӧ��ָ������ IDataOut��
    
    //��ʼ��ָ��Ĵ���������Ӧ������ָ�����ƥ�䣬���������в�����д����
    
    initial begin //���Ե�ַ
        $readmemb("D:/Study_SOC/Simple_CPU/simple_cpu/simple_cpu.srcs/sources_1/new/ins_mem.txt",mem);
    end
    //��ַ�仯  or  �������ź����ͣ����ж�����
    always @(i_mem_addr or i_mem_rw)
        if(i_mem_rw ==0)i_mem_data_out = {mem[i_mem_addr],mem[i_mem_addr+1],mem[i_mem_addr+2],mem[i_mem_addr+3]};

endmodule

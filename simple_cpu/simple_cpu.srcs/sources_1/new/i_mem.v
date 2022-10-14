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
/*          该部分为指令寄存器，通过一个 256 大小的 8 位寄存器数组来保存从文件输入的全部指令。
            然后通过输入的地址，找到相应的指令，输出到 IDataOut。
            指令存储器的功能是存储读入的所有 32-bit 位宽的指令，
            根据程序计数器 PC 中的指令地址进行取指令操作并对指令类型进行分析，
            通过指令类型对所取指令的各字段进行区分识别，最后将对应部分传递给其他模块进行后续处理。
            
            指令存储器中每个单元的位宽为 8-bit，也就是存储每条 32-bit 位宽的指令都需要占据 4 个单元，
            所以第 n（n 大于或等于 0）条指令所对应的起始地址为 4n，且占据第 4n，4n+1，4n+2，4n+3 这四个单元。
            取出指令就是将这四个单元分别取出，因为指令的存储服从高位指令存储在低位地址的规则，
            所以 4n 单元中的字段是该条指令的最高 8 位，后面以此类推，并通过左移操作将指令的四个单元部分移动到相对应的位置，
            以此来得到所存指令。
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
    //通过一个 256 大小的 8 位寄存器数组来保存从文件输入的全部指令。
    //然后通过输入的地址，找到相应的指令，输出到 IDataOut。
    
    //初始化指令寄存器，将对应内容与指令进行匹配，工作过程中不进行写操作
    
    initial begin //绝对地址
        $readmemb("D:/Study_SOC/Simple_CPU/simple_cpu/simple_cpu.srcs/sources_1/new/ins_mem.txt",mem);
    end
    //地址变化  or  读控制信号拉低，进行读操作
    always @(i_mem_addr or i_mem_rw)
        if(i_mem_rw ==0)i_mem_data_out = {mem[i_mem_addr],mem[i_mem_addr+1],mem[i_mem_addr+2],mem[i_mem_addr+3]};

endmodule

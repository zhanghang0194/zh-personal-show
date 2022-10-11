`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/08 17:14:47
// Design Name: 
// Module Name: pc_reg
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


module pc_reg
#(parameter addr_width = 32)
(
    input clk,
    input rstn,
    input PC_wre,
    input [1:0]PCMux,
    input [25:0]d_mem_out,      //addr
    input [31:0]s_z_extend,     //imme
    
    output reg [addr_width-1:0] PC_addr
    );
parameter IDLE =32'H0000;  

always@(*)
    case(PCMux)
    00: PC = PC_4;
    01: PC = PC_4 + (s_z_extend<<2);
    10: PC = {PC_4[31:28],d_mem_out[27:2],0,0};
    default : PC_addr <= 'HX;
    endcase

always@(posedge clk or negedge rstn)
    if(!rstn)PC_addr <= IDLE;
    else if(!PC_wre) PC_addr <= PC_addr;
    else PC_addr <= PC;
    
assign PC_4 = PC_addr + 4;

endmodule

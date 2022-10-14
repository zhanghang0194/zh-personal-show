`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/11 17:12:49
// Design Name: 
// Module Name: SignZeroExtend
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


module SignZeroExtend
#(  parameter IMME_WIDTH = 16,
    parameter EXTEND_WIDTH =32
)
(
    input [IMME_WIDTH-1:0] immediate,
    input Extsel,
    
    output [EXTEND_WIDTH-1:0] s_z_extend
    );
    assign s_z_extend = {Extsel&&immediate[15]? 16'hffff:16'h0000,immediate};
    
endmodule

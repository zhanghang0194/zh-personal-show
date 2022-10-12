`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/10/12 13:53:52
// Design Name: 
// Module Name: Sim1
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


module Sim1();
logic clk;
logic rstn;
cpu_top u_cpu_top(clk,rstn);
always #30 clk = ~clk;

initial begin
    rstn = 0;
    
    #5 rstn = 1;   
    
end

endmodule

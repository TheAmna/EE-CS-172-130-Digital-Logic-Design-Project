`timescale 1ns / 1ps
// taking clock as input
// taking h_count and v_count as 10 bit outputs
module topmod(
input clk,
output [9:0] h_count,
output [9:0] v_count
);
wire n1 ,n3;
// instantiating the modules made in task a and b
clk_divider u0 (clk,n1);
h_counter u1 ( n1 ,h_count ,n3);
v_counter u2 (n1,n3,v_count) ;
endmodule
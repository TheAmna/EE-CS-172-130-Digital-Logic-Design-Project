`timescale 1ns / 1ps
module topmod_tb();
// input clock
reg clk;
// takes 10 bit h_count, v_count
wire [9:0] h_count;
wire [9:0] v_count;
topmod t (.clk(clk),.h_count(h_count),.v_count(v_count)); //called design file
initial
clk = 1'b0; //1 bit 0 and 1
always
#5 clk = ~clk;
initial
begin
$dumpfile("dump.vcd");
$dumpvars(1,topmod_tb);
// line to display timing signals / waveforms correctly
$monitor ("Time =%0d, clk=%1b, h_count=%10b , v_count=%10b \n ",$time, clk , h_count ,
v_count);
end
endmodule
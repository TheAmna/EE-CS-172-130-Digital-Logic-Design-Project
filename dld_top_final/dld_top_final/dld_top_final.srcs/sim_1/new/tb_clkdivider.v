`timescale 1ns / 1ps

module tb_clkdivider();
reg clk;
wire clk_d;

clk_divider tb (.clk(clk),.clk_d(clk_d)); //called design file
initial
begin
clk = 1'b0; //1 bit 0 and 1
end
always
#5 clk = ~clk;  //after delay value toggle between 0 and 1 

initial
begin
$dumpfile("dump.vcd"); 
$dumpvars(1,tb_clkdivider);
$monitor ("Time =%0d,clk=%1b ,clk_d=%1b \n ",$time, clk,clk_d);

 #11000 $finish; 
end
endmodule

`timescale 1ns / 1ps

module tb_hcounter();
reg clk;
wire [9:0] count;
wire trig_v;
h_counter tb (.clk(clk),.count(count),.trig_v(trig_v)); //called design file
initial
clk = 1'b0; //1 bit 0 and 1
always
#5 clk = ~clk;  //after delay value toggle between 0 and 1 

initial
begin
$dumpfile("dump.vcd"); 
$dumpvars(1,tb_hcounter);
$monitor ("Time =%0d, clk=%1b,count = %10d,trig_v = %1b \n ",$time, clk,count,trig_v);

 #8000 $finish; 
end
endmodule

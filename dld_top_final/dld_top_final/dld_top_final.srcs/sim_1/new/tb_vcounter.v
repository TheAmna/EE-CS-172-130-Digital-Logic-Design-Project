`timescale 1ns / 1ps

module tb_vcounter();
reg clk;
reg enable_v_signal ;
wire [9:0] count;

v_counter tb (.clk(clk),.enable_v_signal(enable_v_signal),.count(count)); //called design file
initial
begin
clk = 1'b0; //1 bit 0 and 1
enable_v_signal = 1'b0 ;// enable pin set to 0
end
always
#5 clk = ~clk;  //after delay value toggle between 0 and 1 
always #10 enable_v_signal=~enable_v_signal; //this toggle as well

initial
begin
$dumpfile("dump.vcd"); 
$dumpvars(1,tb_vcounter);
$monitor ("Time =%0d,clk=%1b ,enable_v_signal=%1b,count = %10d \n ",$time, clk,enable_v_signal,count);

 #11000 $finish; 
end
endmodule

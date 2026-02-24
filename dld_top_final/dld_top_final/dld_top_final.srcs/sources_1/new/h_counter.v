`timescale 1ns / 1ps

module h_counter (
input clk,
output [9:0] count,
output trig_v
); //input output for h_counter

reg [9:0] count; //register
reg trig_v;

initial count = 0; //count=0 initialized
always @ (posedge clk) //incrementing on postive edge
begin
if (count < 799) //count increment till 799 
begin
count <= count + 1;
trig_v<=0; 
end
else
begin
trig_v<=1; // as trig_v becomes 1 count is intialized to 0 again
count <= 0;
end
end
endmodule


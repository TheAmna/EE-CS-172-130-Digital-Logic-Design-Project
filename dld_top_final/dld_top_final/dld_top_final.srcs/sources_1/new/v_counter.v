`timescale 1ns / 1ps

module v_counter(
input clk ,
input enable_v_signal ,
output [9:0] count

    ); // inputs clk, enable_v_signal and output count

reg [9:0] count ;
initial count = 0; // initialized count to 1
always @ (posedge clk) //at positive edge count increment by 1 if count less than 524 and enable 1
begin
if (count < 524 )
begin
if (enable_v_signal==1)
begin
 count <= count + 1;
end
else
begin
count<= count ;
end
end
else
begin // initialized count to 1
count <= 0;
end
end
endmodule


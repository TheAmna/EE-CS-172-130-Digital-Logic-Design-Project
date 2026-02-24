`timescale 1ns / 1ps 

 module testbench_demux();
reg [1:0] S;
reg en;

wire enA;
wire enB;
wire enC;
wire enD;

demux_1_4 testbench_demux(S, en, enA, enB, enC, enD);

initial begin
// for outputs testbecnh
#100 S=2'b00; en = 1'b0;
#100 S=2'b01; en = 1'b0;
#100 S=2'b10; en = 1'b0;
#100 S=2'b11; en = 1'b0;
#100 S=2'b00; en = 1'b1;

$monitor ("Time=%0d, S=%2b,en=%1b , enA=%1b,enB=%1b ,enC=%1b , enD=%1b \n", $time,S,en,enA,enB,enC,enD);

end
endmodule
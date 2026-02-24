`timescale 1ns / 1ps module testbench_fa();

reg A,B, C;
wire SUM, CARRY;

fa module_u_test (A,B,C, SUM,CARRY);

      initial
     begin
#100 A = 1'b0; 
B = 1'b0;
C = 1'b0;

#100 A = 1'b0; 
B = 1'b0;
C = 1'b1;

#100 A = 1'b0; 
B = 1'b1;
C = 1'b0;

#100 A = 1'b0; 
B = 1'b1;
C = 1'b1;

#100 A = 1'b1; 
B = 1'b0;
C = 1'b0;

#100 A = 1'b1; 
B = 1'b0;
C = 1'b1;

#100 A = 1'b1; 
B = 1'b1;
C = 1'b0;

#100 A = 1'b1; 
B = 1'b1;
C = 1'b1;
end
endmodule
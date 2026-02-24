`timescale 1ns / 1ps module testnech_ha();

reg A,B;
wire myLED;

ha module_u_test (A,B,myLED);

      initial
     begin
#100 A = 1'b0; 
   B = 1'b0;

#100 A = 1'b0; 
   B = 1'b1;

#100 A = 1'b1; 
   B = 1'b0;

#100 A = 1'b1; 
   B = 1'b1;
   
end
endmodule
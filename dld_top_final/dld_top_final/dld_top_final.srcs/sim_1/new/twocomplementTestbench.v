`timescale 1ns / 1ps 
module twocomplementTestbench();

reg oO;
reg[2:0] bB;
wire [2:0]cC;

twocomplement test(bB, oO, cC);
// O being zero means + and O being 1 means -
initial begin 
$monitor("Time=%0d, bB=%3b ,oO=%1b,cC=%3b , \n", $time, bB, oO,cC  );
// b and c are 3 bit whereas o is 1 bit 
#100 bB = 3'b000; oO = 1'b0;
#100 bB = 3'b001; oO =  1'b0;
#100 bB = 3'b010; oO =  1'b0;
#100 bB = 3'b011; oO =  1'b0;
#100 bB = 3'b100; oO =  1'b0;
#100 bB = 3'b101; oO =  1'b0;
#100 bB = 3'b110; oO =  1'b0;
#100 bB = 3'b111; oO =  1'b0;

#100 bB = 3'b000; oO =  1'b1;
#100 bB = 3'b001; oO =  1'b1;
#100 bB = 3'b010; oO =  1'b1;
#100 bB = 3'b011; oO =  1'b1;
#100 bB = 3'b100; oO =  1'b1;
#100 bB = 3'b101; oO =  1'b1;
#100 bB = 3'b110; oO =  1'b1;
#100 bB = 3'b111; oO =  1'b1;

end
endmodule 

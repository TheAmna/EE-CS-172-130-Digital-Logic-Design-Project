`timescale 1ns / 1ps

module testbench_topmodule() ;
// registers
reg [3:0] A ;
reg [3:0] B ;
reg [3:0] C ;
reg [1:0] S ;
reg en ;
// giving wires to outputs of the demux
wire [6:0] X ;
wire EnA ;
wire EnB ;
wire EnC ;
wire EnD ;
wire [3:0] seven;

TopLevelModule testbench_topmodule (A,B,C,S,en,X,EnA,EnB,EnC,EnD,seven) ; 
initial begin
$monitor ("Time=%0d, A=%4b , B=%4b, C=%4b,S=%2b,en=%1b ,X=%7b, EnA=%1b,EnB=%1b ,EnC=%1b , EnD=%1b,seven=%4b \n", $time,S,en,X,EnA,EnB,EnC,EnD);
A= 4'b1001;
B=4'b0110;
C=4'b0010;
// assigning values to selecteor bit for output ID
#100 S=2'b00  ; en=1'b0 ;  //printing A
#100 S=2'b01 ; en=1'b0 ; //printing B
#100 S=2'b10  ; en=1'b0 ; //printing C
#100 S=2'b11  ; en=1'b0 ; //printing D
#100 S=2'b00 ; en=1'b1 ; 

end
endmodule


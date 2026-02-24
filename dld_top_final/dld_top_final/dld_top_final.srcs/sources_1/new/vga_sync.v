`timescale 1ns / 1ps
module vga_sync (
input [9:0] h_count,
input [9:0] v_count,
output h_sync,
output v_sync,
output video_on, // active area
output [9:0] x_loc, // current pixel x- location
output [9:0] y_loc // current pixel y-location
);
// horizontal
localparam HD = 640; 
localparam HF = 16; 
localparam HB = 48; 
localparam HR = 96;


// vertical
localparam VD = 480; 
localparam VF = 10; 
localparam VB = 33; 
localparam VR = 2;
 //add your code here
// Correct version for 640x480@60Hz
assign h_sync = (h_count >= (HD + HF) && h_count < (HD + HF + HR)) ? 1'b0 : 1'b1;  // active LOW
assign v_sync = (v_count >= (VD + VF) && v_count < (VD + VF + VR)) ? 1'b0 : 1'b1;  // active LOW
assign video_on = (h_count < HD) && (v_count<VD);
assign x_loc = h_count; 
assign y_loc = v_count;

endmodule // vga_sync
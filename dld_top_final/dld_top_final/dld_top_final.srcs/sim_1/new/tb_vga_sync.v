`timescale 1ns / 1ps

module tb_vga_sync;

// Inputs
reg [9:0] h_count;
reg [9:0] v_count;

// Outputs
wire h_sync;
wire v_sync;
wire video_on;
wire [9:0] x_loc;
wire [9:0] y_loc;

//// Parameters (same as in DUT)localparam HD = 640; 
//localparam HF = 16; 
//localparam HB = 48; 
//localparam HR = 96;
//localparam HMAX = HD + HF + HB + HR; // 800

//localparam VD = 480; 
//localparam VF = 10; 
//localparam VB = 33; 
//localparam VR = 2;
//localparam VMAX = VD + VF + VB + VR; // 525

// Instantiate the Unit Under Test (UUT)
vga_sync u1 (
    .h_count(h_count),
    .v_count(v_count),
    .h_sync(h_sync),
    .v_sync(v_sync),
    .video_on(video_on),
    .x_loc(x_loc),
    .y_loc(y_loc)
);

initial 
begin
    h_count=0;
    v_count=0;
    repeat(525) begin
    repeat(800) begin
    #5 h_count=h_count +1;
    if (h_count ==799)
    begin
    h_count=0;
    v_count=v_count+1;
    if ( v_count==524) 
    v_count=0;
    end
    end
    end
    $stop;
    end
endmodule
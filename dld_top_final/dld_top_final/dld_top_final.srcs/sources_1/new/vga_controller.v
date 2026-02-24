`timescale 1ns / 1ps


module vga_controller(
    input clk,
    output h_sync,
    output v_sync,
    output [3:0] red,
    output[3:0] green,
    output[3:0] blue
    );
    
    wire clk_d;
    wire [9:0] h_count;
    wire [9:0] v_count;
    wire video_on;
    wire [9:0] pixel_x, pixel_y;
    wire clk_25MHz;
    topmod tt1 (.clk(clk),.h_count(h_count),.v_count(v_count));

    clk_divider tt(.clk(clk) , .clk_d(clk_25MHz));
    vga_sync tt2 ( h_count , v_count , h_sync , v_sync , video_on, pixel_x , pixel_y);
    pixel_gen_module tt4( clk_25MHz ,pixel_x,pixel_y , video_on , red, green ,blue);
endmodule 
`timescale 1ns / 1ps
module music_player_controller (
    input clk_100MHz,          // Board clock
    input r1, t1, u1, w1, r3, // Switches = Song 1 to 5
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);

    wire clk_25MHz;
    wire [9:0] h_count, v_count;
    wire video_on;
    wire [9:0] pixel_x, pixel_y;
    wire enable_v;
    clk_divider_25MHz clk25 (.clk_100MHz(clk_100MHz), .clk_25MHz(clk_25MHz));
    h_counter   hcnt (.clk(clk_25MHz), .count(h_count), .trig_v(enable_v));
    v_counter   vcnt (.clk(clk_25MHz), .enable_v_signal(enable_v), .count(v_count));
    vga_sync    vsync (
        .h_count(h_count), .v_count(v_count),
        .h_sync(h_sync), .v_sync(v_sync),
        .video_on(video_on),
        .x_loc(pixel_x), .y_loc(pixel_y)
    );

    //generating pixels
    song_screen_pixel menu (
        .clk_25MHz(clk_25MHz),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .sw_song1(r1),
        .sw_song2(t1),
        .sw_song3(u1),
        .sw_song4(w1),
        .sw_song5(r3),
        .red(red),
        .green(green),
        .blue(blue)
    );

endmodule

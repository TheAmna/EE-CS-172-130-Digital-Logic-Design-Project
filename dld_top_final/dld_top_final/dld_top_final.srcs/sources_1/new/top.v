//`timescale 1ns / 1ps

//module top (
//    input  clk_100MHz,
//    input  [4:0] switches,  // SW[4:0] for song selection (maps to r1, t1, u1, w1, r3)
//    output h_sync,
//    output v_sync,
//    output [3:0] vga_r,
//    output [3:0] vga_g,
//    output [3:0] vga_b,
//    output pwm_out  // PWM output to Arduino (Pmod JC Pin 4)
//);
//    // ==========================================
//    // VGA TIMING
//    // ==========================================
//    wire clk_25MHz;
//    clk_divider_25MHz u_div (
//        .clk_100MHz(clk_100MHz),
//        .clk_25MHz(clk_25MHz)
//    );
    
//    wire [9:0] h_count, v_count;
//    wire trig_v;
//    h_counter u_h (.clk(clk_25MHz), .count(h_count), .trig_v(trig_v));
//    v_counter u_v (.clk(clk_25MHz), .enable_v_signal(trig_v), .count(v_count));
    
//    wire hsync_int, vsync_int, video_on;
//    wire [9:0] pixel_x, pixel_y;
//    vga_sync u_sync (
//        .h_count(h_count), .v_count(v_count),
//        .h_sync(hsync_int), .v_sync(vsync_int),
//        .video_on(video_on),
//        .x_loc(pixel_x), .y_loc(pixel_y)
//    );
    
//    assign h_sync = hsync_int;
//    assign v_sync = vsync_int;
    
//    // ==========================================
//    // SONG SELECTION & PWM ENCODING
//    // ==========================================
//    // Map switches to individual signals for clarity
//    wire r1 = switches[0];
//    wire t1 = switches[1];
//    wire u1 = switches[2];
//    wire w1 = switches[3];
//    wire r3 = switches[4];
    
//    // Song selection (priority encoded)
//    wire [2:0] song_sel;
//    assign song_sel = switches[0] ? 3'd0 :
//                      switches[1] ? 3'd1 :
//                      switches[2] ? 3'd2 :
//                      switches[3] ? 3'd3 :
//                      switches[4] ? 3'd4 : 3'd0;
    
//    // PWM Encoder - encodes song selection as pulse width
//    pwm_song_encoder #(.CLK_FREQ(100_000_000)) pwm_inst (
//        .clk(clk_100MHz),
//        .song_sel(song_sel),
//        .switches(switches),
//        .pwm_out(pwm_out)
//    );
    
//    // ==========================================
//    // SWITCH STATE DETECTION
//    // ==========================================
//    // Count how many song switches are active
//    wire [2:0] switch_count = r1 + t1 + u1 + w1 + r3;  // 0 to 5
//    wire no_switch     = (switch_count == 0);
//    wire one_switch    = (switch_count == 1);
//    wire multiple_switches = (switch_count >= 2);
    
//    // ==========================================
//    // VGA DISPLAY (song selection screen)
//    // ==========================================
//    wire [3:0] red_song, green_song, blue_song;
//    song_screen_pixel u_song (
//        .clk_25MHz(clk_25MHz),
//        .video_on(video_on),
//        .pixel_x(pixel_x), .pixel_y(pixel_y),
//        .sw_song1(r1), .sw_song2(t1), .sw_song3(u1),
//        .sw_song4(w1), .sw_song5(r3),
//        .red(red_song), .green(green_song), .blue(blue_song)
//    );
    
//    // ==========================================
//    // VISUALIZER (when song plays)
//    // ==========================================
//    wire [3:0] red_vis, green_vis, blue_vis;
//    visualizer_screen_pixel u_vis (
//        .clk_25MHz(clk_25MHz),
//        .clk_100MHz(clk_100MHz),
//        .video_on(video_on),
//        .pixel_x(pixel_x), .pixel_y(pixel_y),
//        .sw_song1(r1), .sw_song2(t1), .sw_song3(u1),
//        .sw_song4(w1), .sw_song5(r3),
//        .red(red_vis), .green(green_vis), .blue(blue_vis)
//    );
    
//    // ==========================================
//    // ERROR SCREEN (multiple switches pressed)
//    // ==========================================
//    wire [3:0] red_err, green_err, blue_err;
//    error_screen_pixel u_err (
//        .clk_25MHz(clk_25MHz),
//        .video_on(video_on),
//        .pixel_x(pixel_x), .pixel_y(pixel_y),
//        .red(red_err), .green(green_err), .blue(blue_err)
//    );
    
//    // ==========================================
//    // SCREEN SELECTION LOGIC
//    // ==========================================
//    // Priority: Error (multiple switches) > Visualizer (one switch) > Song Selection (no switch)
//    assign {vga_r, vga_g, vga_b} = multiple_switches ? {red_err, green_err, blue_err} :
//                                     one_switch        ? {red_vis, green_vis, blue_vis} :
//                                                       {red_song, green_song, blue_song};
    
//endmodule


`timescale 1ns / 1ps
module top (
    input clk_100MHz,
    input reset,             // Reset button
    input [4:0] switches,    // SW[4:0] for song selection
    output h_sync,
    output v_sync,
    output [3:0] vga_r,
    output [3:0] vga_g,
    output [3:0] vga_b,
    output pwm_out,          // PWM output to Arduino
    output ws2812_data       // WS2812 data output
);

    // VGA Timing
    wire clk_25MHz;
    clk_divider_25MHz u_div (
        .clk_100MHz(clk_100MHz),
        .clk_25MHz(clk_25MHz)
    );
   
    wire [9:0] h_count, v_count;
    wire trig_v;
    h_counter u_h (.clk(clk_25MHz), .count(h_count), .trig_v(trig_v));
    v_counter u_v (.clk(clk_25MHz), .enable_v_signal(trig_v), .count(v_count));
   
    wire hsync_int, vsync_int, video_on;
    wire [9:0] pixel_x, pixel_y;
    vga_sync u_sync (
        .h_count(h_count), .v_count(v_count),
        .h_sync(hsync_int), .v_sync(vsync_int),
        .video_on(video_on),
        .x_loc(pixel_x), .y_loc(pixel_y)
    );
   
    assign h_sync = hsync_int;
    assign v_sync = vsync_int;
   
    // Song selection & PWM
    wire r1 = switches[0];
    wire t1 = switches[1];
    wire u1 = switches[2];
    wire w1 = switches[3];
    wire r3 = switches[4];
   
    wire [2:0] song_sel = r1 ? 3'd0 :
                          t1 ? 3'd1 :
                          u1 ? 3'd2 :
                          w1 ? 3'd3 :
                          r3 ? 3'd4 : 3'd0;
   
    pwm_song_encoder #(.CLK_FREQ(100_000_000)) pwm_inst (
        .clk(clk_100MHz),
        .song_sel(song_sel),
        .switches(switches),
        .pwm_out(pwm_out)
    );
   
    // Switch state detection
    wire [2:0] switch_count = r1 + t1 + u1 + w1 + r3;
    wire no_switch = (switch_count == 0);
    wire one_switch = (switch_count == 1);
    wire multiple_switches = (switch_count >= 2);
   
    // VGA Song Selection Screen
    wire [3:0] red_song, green_song, blue_song;
    song_screen_pixel u_song (
        .clk_25MHz(clk_25MHz),
        .video_on(video_on),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .sw_song1(r1), .sw_song2(t1), .sw_song3(u1),
        .sw_song4(w1), .sw_song5(r3),
        .red(red_song), .green(green_song), .blue(blue_song)
    );
   
    // Visualizer Screen
    wire [3:0] red_vis, green_vis, blue_vis;
    visualizer_screen_pixel u_vis (
        .clk_25MHz(clk_25MHz),
        .clk_100MHz(clk_100MHz),
        .video_on(video_on),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .sw_song1(r1), .sw_song2(t1), .sw_song3(u1),
        .sw_song4(w1), .sw_song5(r3),
        .red(red_vis), .green(green_vis), .blue(blue_vis)
    );
   
    // Error Screen
    wire [3:0] red_err, green_err, blue_err;
    error_screen_pixel u_err (
        .clk_25MHz(clk_25MHz),
        .video_on(video_on),
        .pixel_x(pixel_x), .pixel_y(pixel_y),
        .red(red_err), .green(green_err), .blue(blue_err)
    );
   
    // Screen Selection
    assign {vga_r, vga_g, vga_b} = multiple_switches ? {red_err, green_err, blue_err} :
                                     one_switch ? {red_vis, green_vis, blue_vis} :
                                                  {red_song, green_song, blue_song};
   
    // WS2812 Driver for Songs 1-2
    ws2812_driver #(
        .LED_COUNT(30),
        .CLK_FREQ(100_000_000),
        .FRAME_RATE(30),
        .ADDR_WIDTH(13),
        .NUM_BARS(16)
    ) ws2812_inst (
        .clk(clk_100MHz),
        .reset(reset),
        .sw1(r1),  // Song 1
        .sw2(t1),  // Song 2
        .data_out(ws2812_data)
    );
   
endmodule
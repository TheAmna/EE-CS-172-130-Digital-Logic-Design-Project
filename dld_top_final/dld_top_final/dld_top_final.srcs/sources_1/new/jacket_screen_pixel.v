`timescale 1ns / 1ps

module jacket_screen_pixel (
    input clk_25MHz,
    input clk_100MHz,
    input video_on,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [2:0] song_sel,
    input flash_detect,  // For white flash overlay
    output reg [3:0] red = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue = 0
);

    // ==================== FRAME COUNTER ====================
    parameter FRAME_RATE = 30;
    parameter COUNTER_MAX = 100_000_000 / FRAME_RATE;
    parameter ADDR_WIDTH = 13;
    
    reg [31:0] frame_counter = 0;
    reg [ADDR_WIDTH-1:0] frame_addr = 1;
    reg [2:0] prev_song_sel = 3'b111;
    
    always @(posedge clk_100MHz) begin
        if (song_sel != prev_song_sel) begin
            frame_counter <= 0;
            frame_addr <= 1;
            prev_song_sel <= song_sel;
        end else begin
            frame_counter <= frame_counter + 1;
            if (frame_counter == COUNTER_MAX - 1) begin
                frame_counter <= 0;
                frame_addr <= frame_addr + 1;
            end
        end
    end
    
    // ==================== COLOR ROM ====================
    wire [23:0] current_color;
    
    color_rom color_rom_inst (
        .clk(clk_100MHz),
        .addr(frame_addr),
        .song_sel(song_sel),
        .color_out(current_color)
    );
    
    // Extract and scale RGB
    wire [3:0] color_r_raw = current_color[23:20];
    wire [3:0] color_g_raw = current_color[15:12];
    wire [3:0] color_b_raw = current_color[7:4];
    
    wire [3:0] color_r = (color_r_raw == 4'd0) ? 4'd0 : (color_r_raw << 1);
    wire [3:0] color_g = (color_g_raw == 4'd0) ? 4'd0 : (color_g_raw << 1);
    wire [3:0] color_b = (color_b_raw == 4'd0) ? 4'd0 : (color_b_raw << 1);
    
    // ==================== JACKET LED POSITIONS ====================
    // Define 16 LED positions on the jacket (symmetric design)
    // Format: {x_pos, y_pos, radius}
    
    // LED parameters
    localparam LED_RADIUS = 12;  // LED circle radius
    localparam NUM_LEDS = 16;
    
    // LED positions (x, y) - arranged in jacket pattern
    // Left shoulder strip (4 LEDs)
    localparam LED0_X = 200; localparam LED0_Y = 150;
    localparam LED1_X = 220; localparam LED1_Y = 170;
    localparam LED2_X = 240; localparam LED2_Y = 190;
    localparam LED3_X = 260; localparam LED3_Y = 210;
    
    // Right shoulder strip (4 LEDs)
    localparam LED4_X = 440; localparam LED4_Y = 150;
    localparam LED5_X = 420; localparam LED5_Y = 170;
    localparam LED6_X = 400; localparam LED6_Y = 190;
    localparam LED7_X = 380; localparam LED7_Y = 210;
    
    // Left chest strip (4 LEDs)
    localparam LED8_X = 240;  localparam LED8_Y = 250;
    localparam LED9_X = 250;  localparam LED9_Y = 280;
    localparam LED10_X = 260; localparam LED10_Y = 310;
    localparam LED11_X = 270; localparam LED11_Y = 340;
    
    // Right chest strip (4 LEDs)
    localparam LED12_X = 400; localparam LED12_Y = 250;
    localparam LED13_X = 390; localparam LED13_Y = 280;
    localparam LED14_X = 380; localparam LED14_Y = 310;
    localparam LED15_X = 370; localparam LED15_Y = 340;
    
    // ==================== JACKET OUTLINE ====================
    // Simple jacket silhouette using lines
    reg in_jacket_outline;
    reg [9:0] dx, dy;
    
    always @* begin
        in_jacket_outline = 0;
        
        // Shoulders (horizontal lines)
        if (pixel_y >= 140 && pixel_y < 145) begin
            if ((pixel_x >= 180 && pixel_x < 280) || (pixel_x >= 360 && pixel_x < 460))
                in_jacket_outline = 1;
        end
        
        // Collar/neck area
        if (pixel_y >= 120 && pixel_y < 140) begin
            if (pixel_x >= 290 && pixel_x < 350)
                in_jacket_outline = 1;
        end
        
        // Left side seam
        if (pixel_x >= 180 && pixel_x < 185) begin
            if (pixel_y >= 145 && pixel_y < 400)
                in_jacket_outline = 1;
        end
        
        // Right side seam
        if (pixel_x >= 455 && pixel_x < 460) begin
            if (pixel_y >= 145 && pixel_y < 400)
                in_jacket_outline = 1;
        end
        
        // Bottom hem
        if (pixel_y >= 395 && pixel_y < 400) begin
            if (pixel_x >= 180 && pixel_x < 460)
                in_jacket_outline = 1;
        end
        
        // Center zipper
        if (pixel_x >= 318 && pixel_x < 322) begin
            if (pixel_y >= 140 && pixel_y < 395)
                in_jacket_outline = 1;
        end
    end
    
    // ==================== LED RENDERING ====================
    reg in_led;
    reg [3:0] led_intensity;
    
    always @* begin
        in_led = 0;
        led_intensity = 4'hF;
        
        // Check distance from each LED center
        // LED 0
        dx = (pixel_x > LED0_X) ? (pixel_x - LED0_X) : (LED0_X - pixel_x);
        dy = (pixel_y > LED0_Y) ? (pixel_y - LED0_Y) : (LED0_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            // Gradient effect (brighter at center)
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 1
        dx = (pixel_x > LED1_X) ? (pixel_x - LED1_X) : (LED1_X - pixel_x);
        dy = (pixel_y > LED1_Y) ? (pixel_y - LED1_Y) : (LED1_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 2
        dx = (pixel_x > LED2_X) ? (pixel_x - LED2_X) : (LED2_X - pixel_x);
        dy = (pixel_y > LED2_Y) ? (pixel_y - LED2_Y) : (LED2_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 3
        dx = (pixel_x > LED3_X) ? (pixel_x - LED3_X) : (LED3_X - pixel_x);
        dy = (pixel_y > LED3_Y) ? (pixel_y - LED3_Y) : (LED3_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 4
        dx = (pixel_x > LED4_X) ? (pixel_x - LED4_X) : (LED4_X - pixel_x);
        dy = (pixel_y > LED4_Y) ? (pixel_y - LED4_Y) : (LED4_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 5
        dx = (pixel_x > LED5_X) ? (pixel_x - LED5_X) : (LED5_X - pixel_x);
        dy = (pixel_y > LED5_Y) ? (pixel_y - LED5_Y) : (LED5_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 6
        dx = (pixel_x > LED6_X) ? (pixel_x - LED6_X) : (LED6_X - pixel_x);
        dy = (pixel_y > LED6_Y) ? (pixel_y - LED6_Y) : (LED6_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 7
        dx = (pixel_x > LED7_X) ? (pixel_x - LED7_X) : (LED7_X - pixel_x);
        dy = (pixel_y > LED7_Y) ? (pixel_y - LED7_Y) : (LED7_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 8
        dx = (pixel_x > LED8_X) ? (pixel_x - LED8_X) : (LED8_X - pixel_x);
        dy = (pixel_y > LED8_Y) ? (pixel_y - LED8_Y) : (LED8_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 9
        dx = (pixel_x > LED9_X) ? (pixel_x - LED9_X) : (LED9_X - pixel_x);
        dy = (pixel_y > LED9_Y) ? (pixel_y - LED9_Y) : (LED9_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 10
        dx = (pixel_x > LED10_X) ? (pixel_x - LED10_X) : (LED10_X - pixel_x);
        dy = (pixel_y > LED10_Y) ? (pixel_y - LED10_Y) : (LED10_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 11
        dx = (pixel_x > LED11_X) ? (pixel_x - LED11_X) : (LED11_X - pixel_x);
        dy = (pixel_y > LED11_Y) ? (pixel_y - LED11_Y) : (LED11_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 12
        dx = (pixel_x > LED12_X) ? (pixel_x - LED12_X) : (LED12_X - pixel_x);
        dy = (pixel_y > LED12_Y) ? (pixel_y - LED12_Y) : (LED12_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 13
        dx = (pixel_x > LED13_X) ? (pixel_x - LED13_X) : (LED13_X - pixel_x);
        dy = (pixel_y > LED13_Y) ? (pixel_y - LED13_Y) : (LED13_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 14
        dx = (pixel_x > LED14_X) ? (pixel_x - LED14_X) : (LED14_X - pixel_x);
        dy = (pixel_y > LED14_Y) ? (pixel_y - LED14_Y) : (LED14_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
        
        // LED 15
        dx = (pixel_x > LED15_X) ? (pixel_x - LED15_X) : (LED15_X - pixel_x);
        dy = (pixel_y > LED15_Y) ? (pixel_y - LED15_Y) : (LED15_Y - pixel_y);
        if ((dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS)) begin
            in_led = 1;
            led_intensity = (dx * dx + dy * dy) < (LED_RADIUS * LED_RADIUS / 4) ? 4'hF : 4'hC;
        end
    end
    
    // ==================== PIXEL OUTPUT ====================
    always @* begin
        if (!video_on) begin
            {red, green, blue} = 12'h000;
        end else begin
            // Default: dark gray background
            red = 4'h2;
            green = 4'h2;
            blue = 4'h2;
            
            // Jacket outline (light gray)
            if (in_jacket_outline) begin
                red = 4'h8;
                green = 4'h8;
                blue = 4'h8;
            end
            
            // LEDs with ROM colors
            if (in_led) begin
                if (flash_detect) begin
                    // White flash override
                    red = 4'hF;
                    green = 4'hF;
                    blue = 4'hF;
                end else begin
                    // Apply ROM color with intensity gradient
                    red = (color_r * led_intensity) >> 4;
                    green = (color_g * led_intensity) >> 4;
                    blue = (color_b * led_intensity) >> 4;
                end
            end
        end
    end

endmodule
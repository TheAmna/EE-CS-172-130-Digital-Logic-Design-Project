/*module song_screen_pixel (
    input clk_25MHz,
    input video_on,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input sw_song1, sw_song2, sw_song3, sw_song4, sw_song5,
    output reg [3:0] red = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue = 0
);

    // Parameters
    localparam HEADER_Y0 = 40;
    localparam HEADER_Y1 = 92;
    localparam L_W = 30;
    localparam L_H = HEADER_Y1 - HEADER_Y0; // 52
    localparam SP = 8;
    localparam START_X = 115;
    localparam DIGIT_X = 220;
    localparam TITLE_X = 270;
    localparam LED_RADIUS = 5; // Radius for circular LEDs
    localparam LED_SPACING = 15; // Spacing between LED centers
    localparam LED_COUNT_H = 640 / LED_SPACING; // Approx LEDs horizontal
    localparam LED_COUNT_V = 480 / LED_SPACING; // Approx LEDs vertical

    // Highlight color - rainbow based on selected song
    wire [11:0] fg_color = sw_song1 ? 12'hF00 :  // Red
                           sw_song2 ? 12'hF80 :  // Orange
                           sw_song3 ? 12'hFF0 :  // Yellow
                           sw_song4 ? 12'h0FF :  // Cyan
                           sw_song5 ? 12'hF0F :  // Magenta
                           12'h000;              // None

    // Animation for LED lights
    wire [3:0] anim_offset = pixel_x[5:2] + pixel_y[5:2];

    // Temporary variables for calculations inside the block
    reg [9:0] rel_x;
    reg [9:0] rel_y;
    reg [15:0] prod;
    reg [9:0] center;
    reg [9:0] center_right;
    reg [9:0] rel_y_leg;
    reg [9:0] rel_y_upper;
    reg [11:0] led_color;

    always @* begin
        if (!video_on) begin
            {red, green, blue} = 12'h000;
        end else begin
            // Default white background
            {red, green, blue} = 12'hFFF;

            // Circular LED lights along borders (replacing solid borders)
            // Top border LEDs
            if (pixel_y < LED_SPACING) begin
                rel_x = pixel_x % LED_SPACING;
                center = LED_SPACING / 2;
                if ((rel_x - center) * (rel_x - center) + (pixel_y - center) * (pixel_y - center) <= LED_RADIUS * LED_RADIUS) begin
                    led_color = ((pixel_x / LED_SPACING + anim_offset) % 6 == 0) ? 12'hF00 :
                                ((pixel_x / LED_SPACING + anim_offset) % 6 == 1) ? 12'hFF0 :
                                ((pixel_x / LED_SPACING + anim_offset) % 6 == 2) ? 12'h0F0 :
                                ((pixel_x / LED_SPACING + anim_offset) % 6 == 3) ? 12'h0FF :
                                ((pixel_x / LED_SPACING + anim_offset) % 6 == 4) ? 12'h00F : 12'hF0F;
                    {red, green, blue} = led_color;
                end
            end
            // Bottom border LEDs
            else if (pixel_y >= 480 - LED_SPACING) begin
                rel_x = pixel_x % LED_SPACING;
                center = LED_SPACING / 2;
                if ((rel_x - center) * (rel_x - center) + ((pixel_y - (480 - center)) * (pixel_y - (480 - center))) <= LED_RADIUS * LED_RADIUS) begin
                    led_color = ((pixel_x / LED_SPACING - anim_offset) % 6 == 0) ? 12'hF0F :
                                ((pixel_x / LED_SPACING - anim_offset) % 6 == 1) ? 12'h00F :
                                ((pixel_x / LED_SPACING - anim_offset) % 6 == 2) ? 12'h0FF :
                                ((pixel_x / LED_SPACING - anim_offset) % 6 == 3) ? 12'h0F0 :
                                ((pixel_x / LED_SPACING - anim_offset) % 6 == 4) ? 12'hFF0 : 12'hF00;
                    {red, green, blue} = led_color;
                end
            end
            // Left border LEDs
            else if (pixel_x < LED_SPACING) begin
                rel_y = pixel_y % LED_SPACING;
                center = LED_SPACING / 2;
                if ((pixel_x - center) * (pixel_x - center) + (rel_y - center) * (rel_y - center) <= LED_RADIUS * LED_RADIUS) begin
                    led_color = ((pixel_y / LED_SPACING + anim_offset) % 6 == 0) ? 12'hF00 :
                                ((pixel_y / LED_SPACING + anim_offset) % 6 == 1) ? 12'hF80 :
                                ((pixel_y / LED_SPACING + anim_offset) % 6 == 2) ? 12'hFF0 :
                                ((pixel_y / LED_SPACING + anim_offset) % 6 == 3) ? 12'h0F0 :
                                ((pixel_y / LED_SPACING + anim_offset) % 6 == 4) ? 12'h0FF : 12'h00F;
                    {red, green, blue} = led_color;
                end
            end
            // Right border LEDs
            else if (pixel_x >= 640 - LED_SPACING) begin
                rel_y = pixel_y % LED_SPACING;
                center = LED_SPACING / 2;
                if (((pixel_x - (640 - center)) * (pixel_x - (640 - center))) + (rel_y - center) * (rel_y - center) <= LED_RADIUS * LED_RADIUS) begin
                    led_color = ((pixel_y / LED_SPACING - anim_offset) % 6 == 0) ? 12'h00F :
                                ((pixel_y / LED_SPACING - anim_offset) % 6 == 1) ? 12'h0FF :
                                ((pixel_y / LED_SPACING - anim_offset) % 6 == 2) ? 12'h0F0 :
                                ((pixel_y / LED_SPACING - anim_offset) % 6 == 3) ? 12'hFF0 :
                                ((pixel_y / LED_SPACING - anim_offset) % 6 == 4) ? 12'hF80 : 12'hF00;
                    {red, green, blue} = led_color;
                end
            end

            // Add more music notes (liked the top two, add similar at bottom and sides)
            // Top-left music note (original, blue)
            else if (pixel_x >= 25 && pixel_x < 55 && pixel_y >= 105 && pixel_y < 135) begin
                if (((pixel_x-25 >= 5 && pixel_x-25 < 15 && pixel_y-105 >= 20 && pixel_y-105 < 30)) ||
                    ((pixel_x-25 >= 13 && pixel_x-25 < 16 && pixel_y-105 >= 5 && pixel_y-105 < 25)) ||
                    ((pixel_x-25 >= 13 && pixel_x-25 < 22 && pixel_y-105 >= 5 && pixel_y-105 < 12)))
                    {red, green, blue} = 12'h00F;
            end
            // Top-right music note (original, magenta)
            else if (pixel_x >= 585 && pixel_x < 615 && pixel_y >= 105 && pixel_y < 135) begin
                if (((pixel_x-585 >= 15 && pixel_x-585 < 25 && pixel_y-105 >= 20 && pixel_y-105 < 30)) ||
                    ((pixel_x-585 >= 14 && pixel_x-585 < 17 && pixel_y-105 >= 5 && pixel_y-105 < 25)) ||
                    ((pixel_x-585 >= 8 && pixel_x-585 < 17 && pixel_y-105 >= 5 && pixel_y-105 < 12)))
                    {red, green, blue} = 12'hF0F;
            end
            // Add more: Mid-left music note (cyan)
            else if (pixel_x >= 25 && pixel_x < 55 && pixel_y >= 225 && pixel_y < 255) begin
                if (((pixel_x-25 >= 5 && pixel_x-25 < 15 && pixel_y-225 >= 20 && pixel_y-225 < 30)) ||
                    ((pixel_x-25 >= 13 && pixel_x-25 < 16 && pixel_y-225 >= 5 && pixel_y-225 < 25)) ||
                    ((pixel_x-25 >= 13 && pixel_x-25 < 22 && pixel_y-225 >= 5 && pixel_y-225 < 12)))
                    {red, green, blue} = 12'h0FF;
            end
            // Mid-right music note (yellow)
            else if (pixel_x >= 585 && pixel_x < 615 && pixel_y >= 225 && pixel_y < 255) begin
                if (((pixel_x-585 >= 15 && pixel_x-585 < 25 && pixel_y-225 >= 20 && pixel_y-225 < 30)) ||
                    ((pixel_x-585 >= 14 && pixel_x-585 < 17 && pixel_y-225 >= 5 && pixel_y-225 < 25)) ||
                    ((pixel_x-585 >= 8 && pixel_x-585 < 17 && pixel_y-225 >= 5 && pixel_y-225 < 12)))
                    {red, green, blue} = 12'hFF0;
            end
            // Bottom-left music note (green, replaced speaker with music note for consistency)
            else if (pixel_x >= 25 && pixel_x < 55 && pixel_y >= 435 && pixel_y < 465) begin
                if (((pixel_x-25 >= 5 && pixel_x-25 < 15 && pixel_y-435 >= 20 && pixel_y-435 < 30)) ||
                    ((pixel_x-25 >= 13 && pixel_x-25 < 16 && pixel_y-435 >= 5 && pixel_y-435 < 25)) ||
                    ((pixel_x-25 >= 13 && pixel_x-25 < 22 && pixel_y-435 >= 5 && pixel_y-435 < 12)))
                    {red, green, blue} = 12'h0F0;
            end
            // Bottom-right music note (orange, replaced waveform with music note, made larger/thicker for visibility)
            else if (pixel_x >= 565 && pixel_x < 615 && pixel_y >= 435 && pixel_y < 465) begin
                if (((pixel_x-565 >= 15 && pixel_x-565 < 25 && pixel_y-435 >= 20 && pixel_y-435 < 30)) ||
                    ((pixel_x-565 >= 14 && pixel_x-565 < 17 && pixel_y-435 >= 5 && pixel_y-435 < 25)) ||
                    ((pixel_x-565 >= 8 && pixel_x-565 < 17 && pixel_y-435 >= 5 && pixel_y-435 < 12)) ||
                    // Add extra thickness for visibility
                    ((pixel_x-565 >= 14 && pixel_x-565 < 18 && pixel_y-435 >= 5 && pixel_y-435 < 25)) ||
                    ((pixel_x-565 >= 8 && pixel_x-565 < 18 && pixel_y-435 >= 5 && pixel_y-435 < 12)))
                    {red, green, blue} = 12'hF80;
            end

            // Header "RAVE JACKET"
            else if (pixel_y >= HEADER_Y0 && pixel_y < HEADER_Y1) begin
                rel_y = pixel_y - HEADER_Y0;

                // R
                if (pixel_x >= START_X && pixel_x < START_X + L_W) begin
                    rel_x = pixel_x - START_X;
                    if (rel_x < 6) {red,green,blue} = 12'hF00;
                    if (rel_y < 10) {red,green,blue} = 12'hF00;
                    if ((rel_x >= L_W-8) && rel_y < 26) {red,green,blue} = 12'hF00;
                    if ((rel_y >= 22 && rel_y < 26) && rel_x < L_W-6) {red,green,blue} = 12'hF00;
                    if (rel_y >= 26) begin
                        rel_y_leg = rel_y - 26;
                        prod = rel_y_leg * 23;
                        center = 6 + (prod / 26);
                        if (rel_x > center - 3 && rel_x < center + 3) {red,green,blue} = 12'hF00;
                    end
                end
                // A (first)
                else if (pixel_x >= START_X + 1*(L_W+SP) && pixel_x < START_X + 1*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 1*(L_W+SP));
                    if (rel_x < 6 || rel_x >= L_W-6) {red,green,blue} = 12'hF80;
                    if (rel_y < 10) {red,green,blue} = 12'hF80;
                    if (rel_y >= 26 && rel_y < 30) {red,green,blue} = 12'hF80;
                end
                // V
                else if (pixel_x >= START_X + 2*(L_W+SP) && pixel_x < START_X + 2*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 2*(L_W+SP));
                    prod = rel_y * 15;
                    center = prod / 52;
                    if (rel_x > center - 3 && rel_x < center + 3) {red,green,blue} = 12'hFF0;
                    center_right = (L_W - 1) - center;
                    if (rel_x > center_right - 3 && rel_x < center_right + 3) {red,green,blue} = 12'hFF0;
                end
                // E (first)
                else if (pixel_x >= START_X + 3*(L_W+SP) && pixel_x < START_X + 3*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 3*(L_W+SP));
                    if (rel_x < 6) {red,green,blue} = 12'h0F0;
                    if (rel_y < 10) {red,green,blue} = 12'h0F0;
                    if (rel_y >= 26 && rel_y < 30) {red,green,blue} = 12'h0F0;
                    if (rel_y >= L_H - 12) {red,green,blue} = 12'h0F0;
                end
                // J
                else if (pixel_x >= START_X + 5*(L_W+SP) && pixel_x < START_X + 5*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 5*(L_W+SP));
                    if (rel_y < 10) {red,green,blue} = 12'h0FF;
                    if (rel_x >= L_W-8) {red,green,blue} = 12'h0FF;
                    if (rel_y >= L_H - 14 && rel_x < 12) {red,green,blue} = 12'h0FF;
                end
                // A (second)
                else if (pixel_x >= START_X + 6*(L_W+SP) && pixel_x < START_X + 6*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 6*(L_W+SP));
                    if (rel_x < 6 || rel_x >= L_W-6) {red,green,blue} = 12'h00F;
                    if (rel_y < 10) {red,green,blue} = 12'h00F;
                    if (rel_y >= 26 && rel_y < 30) {red,green,blue} = 12'h00F;
                end
                // C
                else if (pixel_x >= START_X + 7*(L_W+SP) && pixel_x < START_X + 7*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 7*(L_W+SP));
                    if (rel_x < 8) {red,green,blue} = 12'h80F;
                    if (rel_y < 10) {red,green,blue} = 12'h80F;
                    if (rel_y >= L_H - 12) {red,green,blue} = 12'h80F;
                end
                // K
                else if (pixel_x >= START_X + 8*(L_W+SP) && pixel_x < START_X + 8*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 8*(L_W+SP));
                    if (rel_x < 6) {red,green,blue} = 12'hF0F;
                    if (rel_y <= 26) begin
                        rel_y_upper = 26 - rel_y;
                        prod = rel_y_upper * 23;
                        center = 6 + (prod / 26);
                        if (rel_x > center - 3 && rel_x < center + 3) {red,green,blue} = 12'hF0F;
                    end
                    if (rel_y >= 26) begin
                        rel_y_leg = rel_y - 26;
                        prod = rel_y_leg * 23;
                        center = 6 + (prod / 26);
                        if (rel_x > center - 3 && rel_x < center + 3) {red,green,blue} = 12'hF0F;
                    end
                end
                // E (second)
                else if (pixel_x >= START_X + 9*(L_W+SP) && pixel_x < START_X + 9*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 9*(L_W+SP));
                    if (rel_x < 6) {red,green,blue} = 12'hFF8;
                    if (rel_y < 10) {red,green,blue} = 12'hFF8;
                    if (rel_y >= 26 && rel_y < 30) {red,green,blue} = 12'hFF8;
                    if (rel_y >= L_H - 12) {red,green,blue} = 12'hFF8;
                end
                // T
                else if (pixel_x >= START_X + 10*(L_W+SP) && pixel_x < START_X + 10*(L_W+SP) + L_W) begin
                    rel_x = pixel_x - (START_X + 10*(L_W+SP));
                    if (rel_y < 10) {red,green,blue} = 12'h8FF;
                    if (rel_x >= L_W/2 - 3 && rel_x < L_W/2 + 3) {red,green,blue} = 12'h8FF;
                end
            end

            // Song 1: FADED
            else if (pixel_y >= 140 && pixel_y < 180) begin
                // Digit 1
                if (pixel_x >= DIGIT_X && pixel_x < DIGIT_X + 30) begin
                    if ((pixel_y >= 145 && pixel_y < 150 && pixel_x >= DIGIT_X + 8 && pixel_x < DIGIT_X + 18) ||
                        (pixel_y >= 145 && pixel_y < 175 && pixel_x >= DIGIT_X + 12 && pixel_x < DIGIT_X + 22) ||
                        (pixel_y >= 170 && pixel_y < 175 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 28))
                        {red, green, blue} = fg_color;
                end
                // Title FADED (black)
                if (pixel_y >= 152 && pixel_y < 170) begin
                    rel_y = pixel_y - 152;
                    // F
                    if (pixel_x >= TITLE_X && pixel_x < TITLE_X + 15) begin
                        rel_x = pixel_x - TITLE_X;
                        if (rel_x < 3 || rel_y < 3 || (rel_y >= 8 && rel_y < 11 && rel_x < 12))
                            {red, green, blue} = 12'h000;
                    end
                    // A
                    else if (pixel_x >= TITLE_X + 20 && pixel_x < TITLE_X + 35) begin
                        rel_x = pixel_x - (TITLE_X + 20);
                        if (rel_x < 3 || rel_x >= 12 || rel_y < 3 || (rel_y >= 8 && rel_y < 11))
                            {red, green, blue} = 12'h000;
                    end
                    // D
                    else if (pixel_x >= TITLE_X + 40 && pixel_x < TITLE_X + 55) begin
                        rel_x = pixel_x - (TITLE_X + 40);
                        if (rel_x < 3 || rel_y < 3 || rel_y >= 15 ||
                            (rel_x >= 12 && rel_y >= 3 && rel_y < 15))
                            {red, green, blue} = 12'h000;
                    end
                    // E
                    else if (pixel_x >= TITLE_X + 60 && pixel_x < TITLE_X + 75) begin
                        rel_x = pixel_x - (TITLE_X + 60);
                        if (rel_x < 3 || rel_y < 3 || rel_y >= 15 || (rel_y >= 8 && rel_y < 11))
                            {red, green, blue} = 12'h000;
                    end
                    // D
                    else if (pixel_x >= TITLE_X + 80 && pixel_x < TITLE_X + 95) begin
                        rel_x = pixel_x - (TITLE_X + 80);
                        if (rel_x < 3 || rel_y < 3 || rel_y >= 15 ||
                            (rel_x >= 12 && rel_y >= 3 && rel_y < 15))
                            {red, green, blue} = 12'h000;
                    end
                end
            end

            // Song 2: B
            else if (pixel_y >= 200 && pixel_y < 240) begin
                // Digit "2"
                if (pixel_x >= DIGIT_X && pixel_x < DIGIT_X + 30) begin
                    if ((pixel_y >= 205 && pixel_y < 210 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 205 && pixel_y < 220 && pixel_x >= DIGIT_X + 20 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 218 && pixel_y < 223 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 220 && pixel_y < 235 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 10) ||
                        (pixel_y >= 235 && pixel_y < 240 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25))
                        {red, green, blue} = fg_color;
                end
                // Title: "B"
                if (pixel_y >= 212 && pixel_y < 230) begin
                    rel_y = pixel_y - 212;
                    if (pixel_x >= TITLE_X && pixel_x < TITLE_X + 15) begin
                        rel_x = pixel_x - TITLE_X;
                        if (rel_x < 3 || rel_y < 3 || (rel_y >= 8 && rel_y < 11) || rel_y >= 15 ||
                            (rel_x >= 10 && ((rel_y >= 3 && rel_y < 8) || (rel_y >= 11 && rel_y < 15))))
                            {red, green, blue} = 12'h000;
                    end
                end
            end

            // Song 3: C
            else if (pixel_y >= 260 && pixel_y < 300) begin
                // Digit "3"
                if (pixel_x >= DIGIT_X && pixel_x < DIGIT_X + 30) begin
                    if ((pixel_y >= 265 && pixel_y < 270 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 265 && pixel_y < 295 && pixel_x >= DIGIT_X + 20 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 278 && pixel_y < 283 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 295 && pixel_y < 300 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25))
                        {red, green, blue} = fg_color;
                end
                // Title: "C"
                if (pixel_y >= 272 && pixel_y < 290) begin
                    rel_y = pixel_y - 272;
                    if (pixel_x >= TITLE_X && pixel_x < TITLE_X + 15) begin
                        rel_x = pixel_x - TITLE_X;
                        if (rel_x < 3 || rel_y < 3 || rel_y >= 15)
                            {red, green, blue} = 12'h000;
                    end
                end
            end

            // Song 4: D
            else if (pixel_y >= 320 && pixel_y < 360) begin
                // Digit "4"
                if (pixel_x >= DIGIT_X && pixel_x < DIGIT_X + 30) begin
                    if ((pixel_y >= 325 && pixel_y < 340 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 10) ||
                        (pixel_y >= 325 && pixel_y < 355 && pixel_x >= DIGIT_X + 20 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 338 && pixel_y < 343 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25))
                        {red, green, blue} = fg_color;
                end
                // Title: "D"
                if (pixel_y >= 332 && pixel_y < 350) begin
                    rel_y = pixel_y - 332;
                    if (pixel_x >= TITLE_X && pixel_x < TITLE_X + 15) begin
                        rel_x = pixel_x - TITLE_X;
                        if (rel_x < 3 || rel_y < 3 || rel_y >= 15 ||
                            (rel_x >= 12 && rel_y >= 3 && rel_y < 15))
                            {red, green, blue} = 12'h000;
                    end
                end
            end

            // Song 5: E
            else if (pixel_y >= 380 && pixel_y < 420) begin
                // Digit "5"
                if (pixel_x >= DIGIT_X && pixel_x < DIGIT_X + 30) begin
                    if ((pixel_y >= 385 && pixel_y < 390 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 385 && pixel_y < 400 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 10) ||
                        (pixel_y >= 398 && pixel_y < 403 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 400 && pixel_y < 415 && pixel_x >= DIGIT_X + 20 && pixel_x < DIGIT_X + 25) ||
                        (pixel_y >= 415 && pixel_y < 420 && pixel_x >= DIGIT_X + 5 && pixel_x < DIGIT_X + 25))
                        {red, green, blue} = fg_color;
                end
                // Title: "E"
                if (pixel_y >= 392 && pixel_y < 410) begin
                    rel_y = pixel_y - 392;
                    if (pixel_x >= TITLE_X && pixel_x < TITLE_X + 15) begin
                        rel_x = pixel_x - TITLE_X;
                        if (rel_x < 3 || rel_y < 3 || rel_y >= 15 || (rel_y >= 8 && rel_y < 11))
                            {red, green, blue} = 12'h000;
                    end
                end
            end
        end
    end
endmodule*/
`timescale 1ns / 1ps

`timescale 1ns / 1ps

module song_screen_pixel (
    input clk_25MHz,
    input video_on,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input sw_song1, sw_song2, sw_song3, sw_song4, sw_song5,
    output reg [3:0] red   = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue  = 0
);

    // ============================================
    // LAYOUT PARAMETERS (centered on 640x480)
    // ============================================
    localparam HEADER_X = 188;  // (640 - 11*8*3)/2 = 188 - perfect center
    localparam HEADER_Y = 40;

    localparam NUM_X    = 240;  // Big numbers
    localparam TITLE_X  = 280;  // Titles start after number + space

    // ============================================
    // STRING RENDERERS
    // ============================================
    wire text_on_header;
    string_renderer #(.TEXT_LENGTH(11), .SCALE(3)) header (
        .clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y),
        .text_string("RAVE JACKET"),
        .X_POS(HEADER_X), .Y_POS(HEADER_Y),
        .text_on(text_on_header)
    );

    // Numbers (scale 3x - huge and bold)
    wire num1_on, num2_on, num3_on, num4_on, num5_on;
    string_renderer #(.TEXT_LENGTH(1), .SCALE(3)) num1 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("1"), .X_POS(NUM_X), .Y_POS(140), .text_on(num1_on));
    string_renderer #(.TEXT_LENGTH(1), .SCALE(3)) num2 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("2"), .X_POS(NUM_X), .Y_POS(200), .text_on(num2_on));
    string_renderer #(.TEXT_LENGTH(1), .SCALE(3)) num3 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("3"), .X_POS(NUM_X), .Y_POS(260), .text_on(num3_on));
    string_renderer #(.TEXT_LENGTH(1), .SCALE(3)) num4 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("4"), .X_POS(NUM_X), .Y_POS(320), .text_on(num4_on));
    string_renderer #(.TEXT_LENGTH(1), .SCALE(3)) num5 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("5"), .X_POS(NUM_X), .Y_POS(380), .text_on(num5_on));

    // Titles (scale 2x) - UPDATED SONG NAMES
    wire title1_on, title2_on, title3_on, title4_on, title5_on;
    string_renderer #(.TEXT_LENGTH(5),  .SCALE(2)) t1 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("FADED"),     .X_POS(TITLE_X), .Y_POS(148), .text_on(title1_on));
    string_renderer #(.TEXT_LENGTH(9),  .SCALE(2)) t2 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("WAKA WAKA"), .X_POS(TITLE_X), .Y_POS(208), .text_on(title2_on));
    string_renderer #(.TEXT_LENGTH(4),  .SCALE(2)) t3 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("BASS"),      .X_POS(TITLE_X), .Y_POS(268), .text_on(title3_on));
    string_renderer #(.TEXT_LENGTH(4),  .SCALE(2)) t4 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("SFOS"),      .X_POS(TITLE_X), .Y_POS(328), .text_on(title4_on));
    string_renderer #(.TEXT_LENGTH(8),  .SCALE(2)) t5 (.clk(clk_25MHz), .pixel_x(pixel_x), .pixel_y(pixel_y), .text_string("TITANIUM"),  .X_POS(TITLE_X), .Y_POS(388), .text_on(title5_on));

    // ============================================
    // RAINBOW HEADER COLORS (one per letter!)
    // ============================================
    reg [11:0] header_rgb;
    wire [3:0] header_char_idx = (pixel_x - HEADER_X) / 24; // 8px * 3 = 24px per char

    always @* begin
        case (header_char_idx)
            4'd0:  header_rgb = 12'hF00; // R - Red
            4'd1:  header_rgb = 12'hF80; // A - Orange
            4'd2:  header_rgb = 12'hFF0; // V - Yellow
            4'd3:  header_rgb = 12'h0F0; // E - Green
            4'd4:  header_rgb = 12'h0FF; // space - Cyan (or 12'h000 for invisible)
            4'd5:  header_rgb = 12'h0FF; // J - Cyan
            4'd6:  header_rgb = 12'h00F; // A - Blue
            4'd7:  header_rgb = 12'h80F; // C - Purple
            4'd8:  header_rgb = 12'hF0F; // K - Magenta
            4'd9:  header_rgb = 12'hFF8; // E - Peach
            4'd10: header_rgb = 12'h8FF; // T - Light blue
            default: header_rgb = 12'hFFF;
        endcase
    end

    // ============================================
    // NUMBER COLORS - Rich Gold when selected
    // ============================================
    wire [11:0] num_color = sw_song1 && num1_on ? 12'hFD0 :  // Bright gold
                            sw_song2 && num2_on ? 12'hFD0 :
                            sw_song3 && num3_on ? 12'hFD0 :
                            sw_song4 && num4_on ? 12'hFD0 :
                            sw_song5 && num5_on ? 12'hFD0 :
                                                  12'h666;  // Dim gray when not selected

    // ============================================
    // FINAL PIXEL OUTPUT
    // ============================================
    always @* begin
        if (!video_on) begin
            {red, green, blue} = 12'h000;
        end else begin
            {red, green, blue} = 12'h000;  // Black background

            // Priority: Header - Numbers - Titles
            if (text_on_header)
                {red, green, blue} = header_rgb;

            else if (num1_on || num2_on || num3_on || num4_on || num5_on)
                {red, green, blue} = num_color;

            else if (title1_on || title2_on || title3_on || title4_on || title5_on)
                {red, green, blue} = 12'hFFF;  // White titles
        end
    end

endmodule
//`timescale 1ns / 1ps
//module error_screen_pixel (
//    input clk_25MHz,
//    input video_on,
//    input [9:0] pixel_x,
//    input [9:0] pixel_y,
//    output reg [3:0] red = 0,
//    output reg [3:0] green = 0,
//    output reg [3:0] blue = 0
//);

//    // Parameters for blinking effect
//    reg [24:0] blink_counter = 0;
//    reg blink_state = 0;
   
//    // Blink at ~2Hz (25MHz / 12500000 = 2Hz)
//    always @(posedge clk_25MHz) begin
//        if (blink_counter == 25'd12_500_000) begin
//            blink_counter <= 0;
//            blink_state <= ~blink_state;
//        end else begin
//            blink_counter <= blink_counter + 1;
//        end
//    end

//    // Helper registers
//    reg [9:0] rel_x, rel_y;
   
//    always @* begin
//        if (!video_on) begin
//            {red, green, blue} = 12'h000;
//        end else begin
//            // Red background (darker when blinking off)
//            if (blink_state) begin
//                red = 4'hC;
//                green = 4'h0;
//                blue = 4'h0;
//            end else begin
//                red = 4'h8;
//                green = 4'h0;
//                blue = 4'h0;
//            end
           
//            // ==================== ERROR TEXT ====================
//            // Centered higher on screen (moved up)
//            // ERROR is ~210px wide, 70px tall, centered at y=180
//            if (pixel_y >= 145 && pixel_y < 215) begin
//                rel_y = pixel_y - 145;
               
//                // Letter E (x=215-240)
//                if (pixel_x >= 215 && pixel_x < 240) begin
//                    rel_x = pixel_x - 215;
//                    // Left vertical bar
//                    if (rel_x < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Top horizontal
//                    if (rel_y < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Middle horizontal
//                    if (rel_y >= 32 && rel_y < 37) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Bottom horizontal
//                    if (rel_y >= 65) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // Letter R (x=250-280)
//                if (pixel_x >= 250 && pixel_x < 280) begin
//                    rel_x = pixel_x - 250;
//                    // Left vertical bar
//                    if (rel_x < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Top horizontal
//                    if (rel_y < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Upper right vertical (forming P shape)
//                    if (rel_x >= 25 && rel_y < 35) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Middle horizontal
//                    if (rel_y >= 30 && rel_y < 35) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Diagonal leg
//                    if (rel_y >= 35) begin
//                        if (rel_x >= (rel_y - 35)/2 + 3 && rel_x <= (rel_y - 35)/2 + 8) begin
//                            {red, green, blue} = 12'hFFF;
//                        end
//                    end
//                end
               
//                // Letter R (x=290-320) - second R
//                if (pixel_x >= 290 && pixel_x < 320) begin
//                    rel_x = pixel_x - 290;
//                    if (rel_x < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_x >= 25 && rel_y < 35) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y >= 30 && rel_y < 35) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y >= 35) begin
//                        if (rel_x >= (rel_y - 35)/2 + 3 && rel_x <= (rel_y - 35)/2 + 8) begin
//                            {red, green, blue} = 12'hFFF;
//                        end
//                    end
//                end
               
//                // Letter O (x=330-365)
//                if (pixel_x >= 330 && pixel_x < 365) begin
//                    rel_x = pixel_x - 330;
//                    // Left vertical
//                    if (rel_x < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Right vertical
//                    if (rel_x >= 30) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Top horizontal
//                    if (rel_y < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Bottom horizontal
//                    if (rel_y >= 65) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // Letter R (x=375-405) - third R
//                if (pixel_x >= 375 && pixel_x < 405) begin
//                    rel_x = pixel_x - 375;
//                    if (rel_x < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y < 5) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_x >= 25 && rel_y < 35) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y >= 30 && rel_y < 35) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y >= 35) begin
//                        if (rel_x >= (rel_y - 35)/2 + 3 && rel_x <= (rel_y - 35)/2 + 8) begin
//                            {red, green, blue} = 12'hFFF;
//                        end
//                    end
//                end
               
//                // Exclamation mark ! (x=415-425)
//                if (pixel_x >= 415 && pixel_x < 425) begin
//                    // Vertical part
//                    if (rel_y < 50) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    // Dot at bottom
//                    if (rel_y >= 60 && rel_y < 70) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
//            end
           
//            // ==================== SUBTITLE TEXT ====================
//            // "Select one song only!" centered below ERROR
//            // Starting at y=235, centered horizontally
//            if (pixel_y >= 235 && pixel_y < 265) begin
//                rel_y = pixel_y - 235;
               
//                // S (x=205)
//                if (pixel_x >= 205 && pixel_x < 220 && (rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26)) begin
//                    {red, green, blue} = 12'hFFF;
//                end
//                if ((pixel_x >= 205 && pixel_x < 209 && rel_y < 17) || (pixel_x >= 216 && pixel_x < 220 && rel_y >= 13)) begin
//                    {red, green, blue} = 12'hFFF;
//                end
               
//                // e (x=225)
//                if (pixel_x >= 225 && pixel_x < 240) begin
//                    if (pixel_x < 229 || rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // l (x=245)
//                if (pixel_x >= 245 && pixel_x < 260) begin
//                    if (pixel_x < 249 || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // e (x=265)
//                if (pixel_x >= 265 && pixel_x < 280) begin
//                    if (pixel_x < 269 || rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // c (x=285)
//                if (pixel_x >= 285 && pixel_x < 300) begin
//                    if (pixel_x < 289 || rel_y < 4 || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // t (x=305)
//                if (pixel_x >= 305 && pixel_x < 320) begin
//                    if (rel_y < 4 || (pixel_x >= 311 && pixel_x < 315)) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // Space
               
//                // o (x=330)
//                if (pixel_x >= 330 && pixel_x < 345) begin
//                    if (pixel_x < 334 || pixel_x >= 341 || rel_y < 4 || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // n (x=350)
//                if (pixel_x >= 350 && pixel_x < 365) begin
//                    if (pixel_x < 354 || pixel_x >= 361) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // e (x=370)
//                if (pixel_x >= 370 && pixel_x < 385) begin
//                    if (pixel_x < 374 || rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // Space
               
//                // s (x=395)
//                if (pixel_x >= 395 && pixel_x < 410 && (rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26)) begin
//                    {red, green, blue} = 12'hFFF;
//                end
//                if ((pixel_x >= 395 && pixel_x < 399 && rel_y < 17) || (pixel_x >= 406 && pixel_x < 410 && rel_y >= 13)) begin
//                    {red, green, blue} = 12'hFFF;
//                end
               
//                // o (x=415)
//                if (pixel_x >= 415 && pixel_x < 430) begin
//                    if (pixel_x < 419 || pixel_x >= 426 || rel_y < 4 || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // n (x=435)
//                if (pixel_x >= 435 && pixel_x < 450) begin
//                    if (pixel_x < 439 || pixel_x >= 446) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // g (x=455)
//                if (pixel_x >= 455 && pixel_x < 470) begin
//                    if (pixel_x < 459 || rel_y < 4 || rel_y >= 26 || (pixel_x >= 466 && rel_y >= 13)) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // Space
               
//                // o (x=480)
//                if (pixel_x >= 480 && pixel_x < 495) begin
//                    if (pixel_x < 484 || pixel_x >= 491 || rel_y < 4 || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // n (x=500)
//                if (pixel_x >= 500 && pixel_x < 515) begin
//                    if (pixel_x < 504 || pixel_x >= 511) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // l (x=520)
//                if (pixel_x >= 520 && pixel_x < 535) begin
//                    if (pixel_x < 524 || rel_y >= 26) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
               
//                // y (x=540)
//                if (pixel_x >= 540 && pixel_x < 555) begin
//                    if (rel_y < 15 && (pixel_x < 544 || pixel_x >= 551)) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                    if (rel_y >= 15 && pixel_x >= 546 && pixel_x < 550) begin
//                        {red, green, blue} = 12'hFFF;
//                    end
//                end
                

//            end
//        end
//    end

//endmodule

/*`timescale 1ns / 1ps
module error_screen_pixel (
    input clk_25MHz,
    input video_on,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output reg [3:0] red = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue = 0
);

    // Parameters for blinking effect
    reg [24:0] blink_counter = 0;
    reg blink_state = 0;
   
    // Blink at ~2Hz (25MHz / 12500000 = 2Hz)
    always @(posedge clk_25MHz) begin
        if (blink_counter == 25'd12_500_000) begin
            blink_counter <= 0;
            blink_state <= ~blink_state;
        end else begin
            blink_counter <= blink_counter + 1;
        end
    end

    // Helper registers
    reg [9:0] rel_x, rel_y;
   
    always @* begin
        if (!video_on) begin
            {red, green, blue} = 12'h000;
        end else begin
            // Red background (darker when blinking off)
            if (blink_state) begin
                red = 4'hC;
                green = 4'h0;
                blue = 4'h0;
            end else begin
                red = 4'h8;
                green = 4'h0;
                blue = 4'h0;
            end
           
            // ==================== ERROR TEXT ====================
            // Centered higher on screen (moved up)
            // ERROR is ~210px wide, 70px tall, centered at y=180
            if (pixel_y >= 145 && pixel_y < 215) begin
                rel_y = pixel_y - 145;
               
                // Letter E (x=215-240)
                if (pixel_x >= 215 && pixel_x < 240) begin
                    rel_x = pixel_x - 215;
                    // Left vertical bar
                    if (rel_x < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Top horizontal
                    if (rel_y < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Middle horizontal
                    if (rel_y >= 32 && rel_y < 37) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Bottom horizontal
                    if (rel_y >= 65) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // Letter R (x=250-280)
                if (pixel_x >= 250 && pixel_x < 280) begin
                    rel_x = pixel_x - 250;
                    // Left vertical bar
                    if (rel_x < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Top horizontal
                    if (rel_y < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Upper right vertical (forming P shape)
                    if (rel_x >= 25 && rel_y < 35) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Middle horizontal
                    if (rel_y >= 30 && rel_y < 35) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Diagonal leg
                    if (rel_y >= 35) begin
                        if (rel_x >= (rel_y - 35)/2 + 3 && rel_x <= (rel_y - 35)/2 + 8) begin
                            {red, green, blue} = 12'hFFF;
                        end
                    end
                end
               
                // Letter R (x=290-320) - second R
                if (pixel_x >= 290 && pixel_x < 320) begin
                    rel_x = pixel_x - 290;
                    if (rel_x < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_x >= 25 && rel_y < 35) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y >= 30 && rel_y < 35) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y >= 35) begin
                        if (rel_x >= (rel_y - 35)/2 + 3 && rel_x <= (rel_y - 35)/2 + 8) begin
                            {red, green, blue} = 12'hFFF;
                        end
                    end
                end
               
                // Letter O (x=330-365)
                if (pixel_x >= 330 && pixel_x < 365) begin
                    rel_x = pixel_x - 330;
                    // Left vertical
                    if (rel_x < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Right vertical
                    if (rel_x >= 30) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Top horizontal
                    if (rel_y < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Bottom horizontal
                    if (rel_y >= 65) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // Letter R (x=375-405) - third R
                if (pixel_x >= 375 && pixel_x < 405) begin
                    rel_x = pixel_x - 375;
                    if (rel_x < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y < 5) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_x >= 25 && rel_y < 35) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y >= 30 && rel_y < 35) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y >= 35) begin
                        if (rel_x >= (rel_y - 35)/2 + 3 && rel_x <= (rel_y - 35)/2 + 8) begin
                            {red, green, blue} = 12'hFFF;
                        end
                    end
                end
               
                // Exclamation mark ! (x=415-425)
                if (pixel_x >= 415 && pixel_x < 425) begin
                    // Vertical part
                    if (rel_y < 50) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    // Dot at bottom
                    if (rel_y >= 60 && rel_y < 70) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
            end
           
            // ==================== SUBTITLE TEXT ====================
            // "Select one song only" centered below ERROR (no exclamation mark)
            // Starting at y=235, centered horizontally
            // "Select one song only" is approximately 285px wide (without exclamation)
            // Screen is 640px wide, so center at (640-285)/2 = 177px
            if (pixel_y >= 235 && pixel_y < 265) begin
                rel_y = pixel_y - 235;
               
                // Calculate centered starting position
                // Base x-position for centered text: 177
                
                // S (x=177-192)
                if (pixel_x >= 177 && pixel_x < 192) begin
                    if (rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if ((pixel_x >= 177 && pixel_x < 181 && rel_y < 17) || (pixel_x >= 188 && pixel_x < 192 && rel_y >= 13)) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // e (x=197-212)
                if (pixel_x >= 197 && pixel_x < 212) begin
                    if (pixel_x < 201 || rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // l (x=217-232)
                if (pixel_x >= 217 && pixel_x < 232) begin
                    if (pixel_x < 221 || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // e (x=237-252)
                if (pixel_x >= 237 && pixel_x < 252) begin
                    if (pixel_x < 241 || rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // c (x=257-272)
                if (pixel_x >= 257 && pixel_x < 272) begin
                    if (pixel_x < 261 || rel_y < 4 || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // t (x=277-292)
                if (pixel_x >= 277 && pixel_x < 292) begin
                    if (rel_y < 4 || (pixel_x >= 283 && pixel_x < 287)) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // Space (x=297-302)
               
                // o (x=307-322)
                if (pixel_x >= 307 && pixel_x < 322) begin
                    if (pixel_x < 311 || pixel_x >= 318 || rel_y < 4 || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // n (x=327-342)
                if (pixel_x >= 327 && pixel_x < 342) begin
                    if (pixel_x < 331 || pixel_x >= 338) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // e (x=347-362)
                if (pixel_x >= 347 && pixel_x < 362) begin
                    if (pixel_x < 351 || rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // Space (x=367-372)
               
                // s (x=377-392)
                if (pixel_x >= 377 && pixel_x < 392) begin
                    if (rel_y < 4 || (rel_y >= 13 && rel_y < 17) || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if ((pixel_x >= 377 && pixel_x < 381 && rel_y < 17) || (pixel_x >= 388 && pixel_x < 392 && rel_y >= 13)) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // o (x=397-412)
                if (pixel_x >= 397 && pixel_x < 412) begin
                    if (pixel_x < 401 || pixel_x >= 408 || rel_y < 4 || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // n (x=417-432)
                if (pixel_x >= 417 && pixel_x < 432) begin
                    if (pixel_x < 421 || pixel_x >= 428) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // g (x=437-452)
                if (pixel_x >= 437 && pixel_x < 452) begin
                    if (pixel_x < 441 || rel_y < 4 || rel_y >= 26 || (pixel_x >= 448 && rel_y >= 13)) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // Space (x=457-462)
               
                // o (x=467-482)
                if (pixel_x >= 467 && pixel_x < 482) begin
                    if (pixel_x < 471 || pixel_x >= 478 || rel_y < 4 || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // n (x=487-502)
                if (pixel_x >= 487 && pixel_x < 502) begin
                    if (pixel_x < 491 || pixel_x >= 498) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // l (x=507-522)
                if (pixel_x >= 507 && pixel_x < 522) begin
                    if (pixel_x < 511 || rel_y >= 26) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
               
                // y (x=527-542)
                if (pixel_x >= 527 && pixel_x < 542) begin
                    if (rel_y < 15 && (pixel_x < 531 || pixel_x >= 538)) begin
                        {red, green, blue} = 12'hFFF;
                    end
                    if (rel_y >= 15 && pixel_x >= 533 && pixel_x < 537) begin
                        {red, green, blue} = 12'hFFF;
                    end
                end
            end
        end
    end

endmodule*/

`timescale 1ns / 1ps

module error_screen_pixel (
    input clk_25MHz,
    input video_on,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    output reg [3:0] red = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue = 0
);

    // ============================================
    // BLINKING BACKGROUND EFFECT
    // ============================================
    reg [24:0] blink_counter = 0;
    reg blink_state = 0;
    
    // Blink at ~2Hz (25MHz / 12500000 = 2Hz)
    always @(posedge clk_25MHz) begin
        if (blink_counter == 25'd12_500_000) begin
            blink_counter <= 0;
            blink_state <= ~blink_state;
        end else begin
            blink_counter <= blink_counter + 1;
        end
    end

    // ============================================
    // STRING RENDERER OUTPUTS
    // ============================================
    wire text_on_error;
    wire text_on_line1;
    wire text_on_line2;
    
    // ============================================
    // TEXT: "ERROR!" - CENTERED
    // ============================================
    // "ERROR!" = 6 characters
    // Width: 6 × 8 × 4 = 192 pixels
    // Center: (640 - 192) / 2 = 224
    localparam ERROR_X = 224;
    localparam ERROR_Y = 180;
    
    string_renderer #(.TEXT_LENGTH(6), .SCALE(4)) error_text (
        .clk(clk_25MHz),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .text_string("ERROR!"),
        .X_POS(ERROR_X),
        .Y_POS(ERROR_Y),
        .text_on(text_on_error)
    );
    
    // ============================================
    // TEXT: "SELECT ONE" - CENTERED
    // ============================================
    // "SELECT ONE" = 10 characters
    // Width: 10 × 8 × 2 = 160 pixels
    // Center: (640 - 160) / 2 = 240
    localparam LINE1_X = 240;
    localparam LINE1_Y = 280;
    
    string_renderer #(.TEXT_LENGTH(10), .SCALE(2)) line1_text (
        .clk(clk_25MHz),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .text_string("SELECT ONE"),
        .X_POS(LINE1_X),
        .Y_POS(LINE1_Y),
        .text_on(text_on_line1)
    );
    
    // ============================================
    // TEXT: "SONG ONLY!" - CENTERED
    // ============================================
    // "SONG ONLY!" = 10 characters
    // Width: 10 × 8 × 2 = 160 pixels
    // Center: (640 - 160) / 2 = 240
    localparam LINE2_X = 240;
    localparam LINE2_Y = 320;
    
    string_renderer #(.TEXT_LENGTH(10), .SCALE(2)) line2_text (
        .clk(clk_25MHz),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .text_string("SONG ONLY!"),
        .X_POS(LINE2_X),
        .Y_POS(LINE2_Y),
        .text_on(text_on_line2)
    );
    
    // ============================================
    // PIXEL OUTPUT
    // ============================================
    always @* begin
        if (!video_on) begin
            {red, green, blue} = 12'h000;
        end else begin
            // BLINKING RED BACKGROUND
            if (blink_state) begin
                // Bright red
                red = 4'hC;
                green = 4'h0;
                blue = 4'h0;
            end else begin
                // Dark red
                red = 4'h8;
                green = 4'h0;
                blue = 4'h0;
            end
            
            // WHITE TEXT ON TOP OF RED BACKGROUND
            if (text_on_error) begin
                {red, green, blue} = 12'hFFF;  // White "ERROR!"
            end
            else if (text_on_line1) begin
                {red, green, blue} = 12'hFFF;  // White "SELECT ONE"
            end
            else if (text_on_line2) begin
                {red, green, blue} = 12'hFFF;  // White "SONG ONLY!"
            end
        end
    end

endmodule
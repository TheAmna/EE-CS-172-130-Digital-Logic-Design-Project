module visualizer_screen_pixel (
    input clk_25MHz,
    input clk_100MHz,
    input video_on,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input sw_song1, sw_song2, sw_song3, sw_song4, sw_song5,
    output reg [3:0] red = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue = 0
);

    // Parameters
    parameter FRAME_RATE = 30;
    parameter COUNTER_MAX = 100_000_000 / FRAME_RATE;  // 3,333,333
    parameter ADDR_WIDTH = 13;
    parameter NUM_BARS = 16;
    
    // Song selection
    wire [2:0] song_sel;
    assign song_sel = sw_song1 ? 3'd0 :
                     sw_song2 ? 3'd1 :
                     sw_song3 ? 3'd2 :
                     sw_song4 ? 3'd3 :
                     sw_song5 ? 3'd4 : 3'd0;
    
    // Frame counter
    reg [31:0] frame_counter_100 = 0;
    reg [ADDR_WIDTH-1:0] frame_addr = 1;  // Start at 1 (skip frame count)
    reg [2:0] prev_song_sel = 3'b111;
    
    always @(posedge clk_100MHz) begin
        if (song_sel != prev_song_sel) begin
            frame_counter_100 <= 0;
            frame_addr <= 1;
            prev_song_sel <= song_sel;
        end else begin
            frame_counter_100 <= frame_counter_100 + 1;
            if (frame_counter_100 == COUNTER_MAX - 1) begin
                frame_counter_100 <= 0;
                frame_addr <= frame_addr + 1;
            end
        end
    end
    
    // ============================================
    // COLOR ROM (24-bit RGB)
    // ============================================
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
    
    // Scale colors up (4x) for visibility
    wire [3:0] color_r = (color_r_raw == 4'd0) ? 4'd0 : 
                         (color_r_raw << 2);
    wire [3:0] color_g = (color_g_raw == 4'd0) ? 4'd0 : 
                         (color_g_raw << 2);
    wire [3:0] color_b = (color_b_raw == 4'd0) ? 4'd0 : 
                         (color_b_raw << 2);
    
    // ============================================
    // BAR HEIGHT ROM (64-bit packed)
    // ============================================
    wire [63:0] bar_heights_packed;
    
    bar_height_rom #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_BARS(NUM_BARS)
    ) bar_rom_inst (
        .clk(clk_100MHz),
        .frame_addr(frame_addr),
        .song_sel(song_sel),
        .bar_heights_packed(bar_heights_packed)
    );
    
    // ============================================
    // VISUALIZATION PARAMETERS - FIXED FOR 16 BARS
    // ============================================
    // For 16 bars with no spacing and some margins
    localparam MARGIN_LR = 16;       // Reduced from 40 to 16 for wider bars
    localparam MARGIN_TOP = 60;
    localparam USABLE_WIDTH = 640 - (2 * MARGIN_LR);  // 608 pixels
    localparam USABLE_HEIGHT = 480 - MARGIN_TOP;      // 420 pixels
    
    // Calculate exact bar width for 16 bars
    // 608 / 16 = 38 pixels per bar (exact division)
    localparam BAR_WIDTH = 38;      // 608 / 16 = 38 exactly
    
    // Since we want the pattern to maintain consistent width as it goes up,
    // we need to ensure each bar uses the FULL 38 pixels
    localparam NUM_SEGMENTS = 10;   // 10 segments
    localparam SEGMENT_HEIGHT = 42; // 420/10 = 42
    localparam BLOCK_GAP = 3;       // Gap within each segment
    
    // ============================================
    // PIXEL RENDERING - FIXED FOR CONSISTENT BAR WIDTH
    // ============================================
    reg [9:0] adjusted_x, adjusted_y;
    reg [4:0] bar_idx;
    reg [9:0] bar_x_start;
    reg [3:0] num_blocks;
    reg [3:0] segment_idx;
    reg [9:0] segment_pos;  // DECLARED HERE instead of inside the always block
    reg in_block;
    
    always @* begin
        // Default: black
        {red, green, blue} = 12'h000;
        
        if (video_on) begin
            // Check if we're in the visualizer area
            if (pixel_x >= MARGIN_LR && pixel_x < (640 - MARGIN_LR) && pixel_y >= MARGIN_TOP) begin
                adjusted_x = pixel_x - MARGIN_LR;
                adjusted_y = pixel_y - MARGIN_TOP;
                
                // Calculate bar index with exact boundaries
                // Each bar gets exactly BAR_WIDTH pixels
                bar_idx = adjusted_x / BAR_WIDTH;
                
                // Make sure we don't go beyond NUM_BARS
                if (bar_idx < NUM_BARS) begin
                    // Calculate exact starting pixel for this bar
                    bar_x_start = bar_idx * BAR_WIDTH;
                    
                    // Check if pixel is within this specific bar's boundaries
                    // Using < instead of <= ensures no overlap
                    if (adjusted_x >= bar_x_start && adjusted_x < (bar_x_start + BAR_WIDTH)) begin
                        // Get bar height (0-10) for this bar
                        // Bar 0 = bits 63:60, Bar 1 = bits 59:56, etc.
                        num_blocks = bar_heights_packed[(bar_idx*4)+3 -: 4];
                        
                        // Calculate which segment (0-9 from bottom)
                        // Note: segment 0 is bottom, segment 9 is top
                        segment_idx = 9 - (adjusted_y / SEGMENT_HEIGHT);
                        
                        // Calculate position within current segment
                        segment_pos = adjusted_y % SEGMENT_HEIGHT;
                        
                        // Check if we're in an active block
                        // The block should be active if segment_idx < num_blocks
                        // AND we're not in the gap area within the segment
                        if (segment_idx < num_blocks && segment_pos >= BLOCK_GAP) begin
                            // Use scaled ROM color
                            red = color_r;
                            green = color_g;
                            blue = color_b;
                        end
                    end
                end
            end
        end
    end
    
endmodule
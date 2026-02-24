//module ws2812_test (
//    input wire clk,       // System clock, e.g., 100 MHz
//    input wire reset_n,   // Active-low reset
//    output reg data_out   // Data output to WS2812 LED
//);

//// Parameters for timing (assuming 100 MHz clock)
//// Bit period: ~1.25 us -> 125 cycles
//parameter CLK_FREQ = 100_000_000;
//parameter BIT_PERIOD = CLK_FREQ / 800_000;  // Approx 1.25 us per bit
//parameter T0H = (CLK_FREQ * 400) / 1_000_000_000;  // 0.4 us high -> ~40 cycles
//parameter T0L = BIT_PERIOD - T0H;                  // Remaining low
//parameter T1H = (CLK_FREQ * 800) / 1_000_000_000;  // 0.8 us high -> ~80 cycles
//parameter T1L = BIT_PERIOD - T1H;                  // Remaining low
//parameter RESET_TIME = CLK_FREQ / 20_000;          // >50 us low -> ~5000 cycles

//// Fixed color: Red (GRB order: 8'h00 Green, 8'hFF Red, 8'h00 Blue)
//reg [23:0] color_data = 24'h00FF00;  // GRB format

//reg [7:0] bit_cnt;       // Bit counter (0-23)
//reg [15:0] cycle_cnt;    // Cycle counter for timing
//reg [15:0] reset_cnt;    // Reset low counter
//reg sending;             // Flag for sending data

//always @(posedge clk or negedge reset_n) begin
//    if (!reset_n) begin
//        data_out <= 0;
//        bit_cnt <= 0;
//        cycle_cnt <= 0;
//        reset_cnt <= 0;
//        sending <= 1;  // Start sending on reset release
//    end else begin
//        if (sending) begin
//            if (bit_cnt < 24) begin
//                // Send current bit (inline bit value, MSB first)
//                if (cycle_cnt < (color_data[23 - bit_cnt] ? T1H : T0H)) begin
//                    data_out <= 1;
//                    cycle_cnt <= cycle_cnt + 1;
//                end else if (cycle_cnt < BIT_PERIOD) begin
//                    data_out <= 0;
//                    cycle_cnt <= cycle_cnt + 1;
//                end else begin
//                    // Bit done
//                    cycle_cnt <= 0;
//                    bit_cnt <= bit_cnt + 1;
//                end
//            end else begin
//                // All bits sent, start reset
//                data_out <= 0;
//                sending <= 0;
//                reset_cnt <= 1;  // Start counting reset
//            end
//        end else begin
//            // Reset period
//            if (reset_cnt > 0 && reset_cnt < RESET_TIME) begin
//                reset_cnt <= reset_cnt + 1;
//                data_out <= 0;
//            end else if (reset_cnt == RESET_TIME) begin
//                // Reset done, loop to send again (or stop, but loop for visibility)
//                bit_cnt <= 0;
//                cycle_cnt <= 0;
//                reset_cnt <= 0;
//                sending <= 1;
//            end
//        end
//    end
//end

//endmodule








//module ws2812_final(
//    input wire clk,        // 100MHz system clock
//    output reg data_out    // Connect to PMOD J1
//);

//// Timing for 100MHz (10ns period)
//parameter T0H = 4;        // 0.4us = 40 cycles
//parameter T1H = 8;        // 0.8us = 80 cycles
//parameter T0L = 8;        // 0.8us = 80 cycles
//parameter T1L = 4;        // 0.4us = 40 cycles
//parameter RESET_CYCLES = 6000; // 60us reset

//reg [31:0] counter = 0;
//reg [7:0] bit_count = 0;
//reg [7:0] led_count = 0;
//reg [23:0] color_data = 24'h00FF00; // GREEN color (G=0, R=255, B=0)

//always @(posedge clk) begin
//    if (led_count < 30) begin  // For your 30 LEDs
//        if (bit_count < 24) begin
//            // Send one bit
//            if (color_data[23 - bit_count]) begin // Send '1'
//                if (counter < T1H) 
//                    data_out <= 1'b1;
//                else if (counter < T1H + T1L) 
//                    data_out <= 1'b0;
//                else begin
//                    counter <= 0;
//                    bit_count <= bit_count + 1;
//                end
//            end else begin // Send '0'
//                if (counter < T0H) 
//                    data_out <= 1'b1;
//                else if (counter < T0H + T0L) 
//                    data_out <= 1'b0;
//                else begin
//                    counter <= 0;
//                    bit_count <= bit_count + 1;
//                end
//            end
//            counter <= counter + 1;
//        end else begin
//            // Move to next LED
//            bit_count <= 0;
//            led_count <= led_count + 1;
//            counter <= 0;
//        end
//    end else begin
//        // All LEDs done, send reset
//        data_out <= 1'b0;
//        if (counter < RESET_CYCLES) begin
//            counter <= counter + 1;
//        end else begin
//            // Restart sequence
//            counter <= 0;
//            bit_count <= 0;
//            led_count <= 0;
//        end
//    end
//end
//endmodule

//module ws2812_driver #(
//    parameter integer LED_COUNT = 30,
//    parameter integer CLK_FREQ  = 100_000_000
//)(
//    input  wire clk,
//    input  wire reset,
//    output reg  data_out
//);

//    // Timing parameters for 800 kHz WS2812 protocol
//    localparam integer BIT_CYCLES = CLK_FREQ / 800_000;        // ~125 cycles
//    localparam integer T0H_CYCLES = CLK_FREQ * 4  / 10_000_000; // ~0.4 탎 ? ~40 cycles
//    localparam integer T1H_CYCLES = CLK_FREQ * 8  / 10_000_000; // ~0.8 탎 ? ~80 cycles
//    localparam integer RESET_CYCLES = CLK_FREQ / 16_000;      // >60 탎 low ? safe

//    // Color buffers (GRB order: full green = G=255, R=0, B=0)
//    reg [7:0] G [0:LED_COUNT-1];
//    reg [7:0] R [0:LED_COUNT-1];
//    reg [7:0] B [0:LED_COUNT-1];

//    reg [ 4:0] led_idx;     // 0..29
//    reg [ 4:0] bit_idx;     // 0..23
//    reg [15:0] cycle_cnt;
//    reg        sending;

//    integer i;

//    // ------------------------------------------------------------
//    // Fixed function - use 'reg' instead of 'bit' for Verilog compatibility (Vivado may be in Verilog mode, not SystemVerilog)
//    // ------------------------------------------------------------
//    function automatic reg get_current_bit;
//        input integer led;
//        input integer bitpos;   // 0..23
//        begin
//            if (bitpos < 8)                      // Green bits first
//                get_current_bit = G[led][7-bitpos];
//            else if (bitpos < 16)                // Red
//                get_current_bit = R[led][15-bitpos];
//            else                                 // Blue
//                get_current_bit = B[led][23-bitpos];
//        end
//    endfunction

//    // ------------------------------------------------------------
//    // Main state machine
//    // ------------------------------------------------------------
//    always @(posedge clk or posedge reset) begin
//        if (reset) begin
//            data_out  <= 1'b0;
//            led_idx   <= 0;
//            bit_idx   <= 0;
//            cycle_cnt <= 0;
//            sending   <= 0;

//            for (i = 0; i < LED_COUNT; i = i+1) begin
//                R[i] <= 0; G[i] <= 0; B[i] <= 0;
//            end
//        end
//        else begin
//            // ----------------------------------------------------
//            // Set all LEDs to green (once per frame)
//            // ----------------------------------------------------
//            if (led_idx == 0 && bit_idx == 0 && cycle_cnt == 0 && sending == 0) begin
//                for (i = 0; i < LED_COUNT; i = i+1) begin
//                    {R[i],G[i],B[i]} <= {8'd0, 8'd255, 8'd0};  // Full green
//                end
//            end

//            // ----------------------------------------------------
//            // Reset state (long low >50탎)
//            // ----------------------------------------------------
//            if (sending == 0) begin
//                data_out <= 1'b0;
//                if (cycle_cnt < RESET_CYCLES-1)
//                    cycle_cnt <= cycle_cnt + 1;
//                else begin
//                    cycle_cnt <= 0;
//                    sending   <= 1;           // start sending next frame
//                end
//            end

//            // ----------------------------------------------------
//            // Sending one bit
//            // ----------------------------------------------------
//            else begin
//                if (cycle_cnt == 0) begin
//                    data_out <= 1'b1;             // start of high pulse
//                end

//                if (data_out == 1'b1) begin
//                    if (cycle_cnt < (get_current_bit(led_idx, bit_idx) ? T1H_CYCLES : T0H_CYCLES))
//                        cycle_cnt <= cycle_cnt + 1;
//                    else
//                        data_out <= 1'b0;           // end high pulse
//                end
//                else begin
//                    if (cycle_cnt < BIT_CYCLES-1)
//                        cycle_cnt <= cycle_cnt + 1;
//                    else begin
//                        // bit finished
//                        cycle_cnt <= 0;
//                        if (bit_idx < 23) begin
//                            bit_idx <= bit_idx + 1;
//                        end
//                        else begin
//                            bit_idx <= 0;
//                            if (led_idx < LED_COUNT-1) begin
//                                led_idx <= led_idx + 1;
//                            end
//                            else begin
//                                led_idx <= 0;
//                                sending <= 0;       // go to reset state
//                            end
//                        end
//                    end
//                end
//            end
//        end
//    end

//endmodule

`timescale 1ns / 1ps
module ws2812_driver #(
    parameter integer LED_COUNT = 30,
    parameter integer CLK_FREQ = 100_000_000,
    parameter integer FRAME_RATE = 30,
    parameter integer ADDR_WIDTH = 13,
    parameter integer NUM_BARS = 16
)(
    input wire clk,
    input wire reset,
    input wire sw1, sw2,  // Switches for songs 1-2
    output reg data_out
);
    // Timing parameters
    localparam integer BIT_CYCLES = CLK_FREQ / 800_000;
    localparam integer T0H_CYCLES = CLK_FREQ * 4 / 10_000_000;
    localparam integer T1H_CYCLES = CLK_FREQ * 8 / 10_000_000;
    localparam integer RESET_CYCLES = CLK_FREQ / 16_000;
    localparam integer DELAY_CYCLES = CLK_FREQ / FRAME_RATE;
    // Beat effect timing
    localparam integer BEAT_FLASH_CYCLES = CLK_FREQ / 1000;
    localparam integer BEAT_STROBE_CYCLES = CLK_FREQ / 2000;
    // Song selection (2 songs)
    wire [1:0] song_sel = sw1 ? 2'd0 :
                          sw2 ? 2'd1 : 2'd0;
    reg [1:0] prev_song_sel = 2'b11;
    // Frame timing
    reg [31:0] frame_counter = 0;
    reg [ADDR_WIDTH-1:0] frame_addr = 1;
    reg frame_ready = 0;
    reg [31:0] total_frames [0:1];  // 2 songs
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            frame_counter <= 0;
            frame_addr <= 1;
            frame_ready <= 0;
            prev_song_sel <= 2'b11;
        end else begin
            frame_ready <= 0;
            if (song_sel != prev_song_sel) begin
                frame_addr <= 1;
                frame_counter <= 0;
                prev_song_sel <= song_sel;
            end else begin
                frame_counter <= frame_counter + 1;
                if (frame_counter == DELAY_CYCLES - 1) begin
                    frame_counter <= 0;
                    frame_ready <= 1;
                    if (frame_addr >= total_frames[song_sel] - 1) begin
                        frame_addr <= 1;
                    end else begin
                        frame_addr <= frame_addr + 1;
                    end
                end
            end
        end
    end
    // SHARED ROMS (2 songs)
    localparam SONGS = 2;
    localparam TOTAL_DEPTH = (1 << ADDR_WIDTH) * SONGS;
    localparam OFFSET_BITS = 1;
    // Color ROM
    reg [23:0] color_rom [0:TOTAL_DEPTH-1];
    reg [23:0] frame_color;  // reg because clocked assignment
    initial begin
        $readmemh("colors_song1.mem", color_rom, 0*(1<<ADDR_WIDTH), 1*(1<<ADDR_WIDTH)-1);
        $readmemh("colors_song2.mem", color_rom, 1*(1<<ADDR_WIDTH), 2*(1<<ADDR_WIDTH)-1);
        total_frames[0] = color_rom[0*(1<<ADDR_WIDTH)];
        total_frames[1] = color_rom[1*(1<<ADDR_WIDTH)];
    end
    wire [ADDR_WIDTH + OFFSET_BITS - 1 : 0] color_full_addr = (song_sel << ADDR_WIDTH) + frame_addr;
    always @(posedge clk) begin
        frame_color <= color_rom[color_full_addr];
    end
    // Bar heights ROM
    reg [63:0] bars_rom [0:TOTAL_DEPTH-1];
    reg [63:0] bar_heights_packed;  // reg
    initial begin
        $readmemh("colors_song1_bars.mem", bars_rom, 0*(1<<ADDR_WIDTH), 1*(1<<ADDR_WIDTH)-1);
        $readmemh("colors_song2_bars.mem", bars_rom, 1*(1<<ADDR_WIDTH), 2*(1<<ADDR_WIDTH)-1);
    end
    wire [ADDR_WIDTH + OFFSET_BITS - 1 : 0] bars_full_addr = (song_sel << ADDR_WIDTH) + frame_addr;
    always @(posedge clk) begin
        bar_heights_packed <= bars_rom[bars_full_addr];
    end
    // Beat ROM
    reg [3:0] beat_rom [0:TOTAL_DEPTH-1];
    reg [3:0] beat_intensity;  // reg
    initial begin
        $readmemh("colors_song1_beats.mem", beat_rom, 0*(1<<ADDR_WIDTH), 1*(1<<ADDR_WIDTH)-1);
        $readmemh("colors_song2_beats.mem", beat_rom, 1*(1<<ADDR_WIDTH), 2*(1<<ADDR_WIDTH)-1);
    end
    wire [ADDR_WIDTH + OFFSET_BITS - 1 : 0] beat_full_addr = (song_sel << ADDR_WIDTH) + frame_addr;
    always @(posedge clk) begin
        beat_intensity <= beat_rom[beat_full_addr];
    end
    wire beat_detected = (beat_intensity > 10);
    // LED buffers
    reg [7:0] G [0:LED_COUNT-1];
    reg [7:0] R [0:LED_COUNT-1];
    reg [7:0] B [0:LED_COUNT-1];
    reg [4:0] led_idx;
    reg [4:0] bit_idx;
    reg [15:0] cycle_cnt;
    reg [31:0] delay_cnt;
    reg [31:0] beat_flash_cnt;
    reg beat_flash_active;
    reg beat_strobe_phase;
    reg sending;
    integer i, j;
    reg [3:0] max_bar;
    reg [3:0] bar_val;
    reg [3:0] height;
    reg [7:0] intensity;
    reg [15:0] temp_r, temp_g, temp_b;
    reg [7:0] white_level;
    reg [3:0] all_bars [0:15];
    integer vga_led_threshold;
    function automatic reg get_current_bit;
        input integer led;
        input integer bitpos;
        begin
            if (bitpos < 8) get_current_bit = G[led][7-bitpos];
            else if (bitpos < 16) get_current_bit = R[led][15-bitpos];
            else get_current_bit = B[led][23-bitpos];
        end
    endfunction
    // Beat effect FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            beat_flash_cnt <= 0;
            beat_flash_active <= 0;
            beat_strobe_phase <= 0;
        end else begin
            if (frame_ready && beat_detected) begin
                beat_flash_active <= 1;
                beat_flash_cnt <= 0;
                beat_strobe_phase <= 1;
            end
            if (beat_flash_active) begin
                beat_flash_cnt <= beat_flash_cnt + 1;
                if (beat_flash_cnt % BEAT_STROBE_CYCLES == 0) beat_strobe_phase <= ~beat_strobe_phase;
                if (beat_flash_cnt >= BEAT_FLASH_CYCLES) begin
                    beat_flash_active <= 0;
                    beat_strobe_phase <= 0;
                end
            end
        end
    end
    // Main LED update and transmission FSM
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 0;
            led_idx <= 0;
            bit_idx <= 0;
            cycle_cnt <= 0;
            delay_cnt <= 0;
            sending <= 0;
            max_bar <= 0;
            bar_val <= 0;
            white_level <= 0;
            for (i = 0; i < LED_COUNT; i = i+1) {R[i], G[i], B[i]} <= 0;
            for (j = 0; j < 16; j = j+1) all_bars[j] <= 0;
        end else begin
            if (!sending) begin
                data_out <= 0;
                if (delay_cnt < RESET_CYCLES - 1) delay_cnt <= delay_cnt + 1;
                else begin
                    // Update colors
                    max_bar = 0;
                    for (j = 0; j < 16; j = j+1) begin
                        all_bars[j] = bar_heights_packed[j*4 +: 4];
                        if (all_bars[j] > max_bar) max_bar = all_bars[j];
                    end
                    if (beat_flash_active) begin
                        if (beat_strobe_phase) begin
                            white_level = beat_intensity * 17;
                            for (i = 0; i < LED_COUNT; i = i+1) begin
                                R[i] <= white_level;
                                G[i] <= white_level;
                                B[i] <= white_level;
                            end
                        end else begin
                            for (i = 0; i < LED_COUNT; i = i+1) {R[i], G[i], B[i]} <= 0;
                        end
                    end else if (max_bar > 0) begin
                        for (i = 0; i < LED_COUNT; i = i+1) begin
                            vga_led_threshold = (i * 15) / (LED_COUNT - 1) + 1;
                            bar_val = max_bar;
                            if (bar_val > 0) begin
                                if (bar_val < 4) bar_val = bar_val * 2;
                                if (bar_val < 2) bar_val = 4;
                                if (bar_val > 15) bar_val = 15;
                            end
                            height = (bar_val >= vga_led_threshold) ? bar_val : 0;
                            if (height > 0) begin
                                intensity = height * 17;
                                temp_r = frame_color[23:16] * intensity;
                                temp_g = frame_color[15:8] * intensity;
                                temp_b = frame_color[7:0] * intensity;
                                R[i] <= temp_r[15:8];
                                G[i] <= temp_g[15:8];
                                B[i] <= temp_b[15:8];
                            end else {R[i], G[i], B[i]} <= 0;
                        end
                    end else begin
                        for (i = 0; i < LED_COUNT; i = i+1) {R[i], G[i], B[i]} <= 0;
                    end
                    delay_cnt <= 0;
                    sending <= 1;
                end
            end else begin
                if (cycle_cnt == 0) data_out <= 1;
                if (data_out) begin
                    if (cycle_cnt < (get_current_bit(led_idx, bit_idx) ? T1H_CYCLES : T0H_CYCLES))
                        cycle_cnt <= cycle_cnt + 1;
                    else data_out <= 0;
                end else begin
                    if (cycle_cnt < BIT_CYCLES - 1) cycle_cnt <= cycle_cnt + 1;
                    else begin
                        cycle_cnt <= 0;
                        if (bit_idx < 23) bit_idx <= bit_idx + 1;
                        else begin
                            bit_idx <= 0;
                            if (led_idx < LED_COUNT-1) led_idx <= led_idx + 1;
                            else begin
                                led_idx <= 0;
                                sending <= 0;
                                delay_cnt <= 0;
                            end
                        end
                    end
                end
            end
        end
    end
endmodule
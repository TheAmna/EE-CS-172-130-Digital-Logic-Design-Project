// WS2812B Controller for Basys 3 (100 MHz clock)
// Controls any number of LEDs, maps frequency/beat to colors
module ws2812b_controller #(
    parameter NUM_LEDS = 60  // Change to your strip length
) (
    input clk_100m,
    input reset,
    input [7:0] low, mid, high,  // From your frequency analyzer (0-255)
    input beat_pulse,            // From beat detector
    output reg dout              // To LED strip DIN (add level shifter if needed)
);

    // Color buffer: GRB format per LED
    reg [7:0] leds [0:NUM_LEDS-1] [2:0];  // [led][0=G, 1=R, 2=B]

    // Update colors based on audio (runs every clock cycle)
    always @(posedge clk_100m) begin
        integer i;
        if (beat_pulse) begin
            // Beat: Flash all white
            for (i = 0; i < NUM_LEDS; i = i + 1) begin
                leds[i][0] <= 255;  // G
                leds[i][1] <= 255;  // R
                leds[i][2] <= 255;  // B
            end
        end else begin
            // Normal mode: Map bands to sections
            for (i = 0; i < NUM_LEDS/3; i = i + 1) begin
                leds[i][1] <= low;  // Bass -> Red on first third
                leds[i][0] <= 0;
                leds[i][2] <= 0;
            end
            for (i = NUM_LEDS/3; i < 2*NUM_LEDS/3; i = i + 1) begin
                leds[i][0] <= mid;  // Mid -> Green
                leds[i][1] <= 0;
                leds[i][2] <= 0;
            end
            for (i = 2*NUM_LEDS/3; i < NUM_LEDS; i = i + 1) begin
                leds[i][2] <= high; // High -> Blue
                leds[i][0] <= 0;
                leds[i][1] <= 0;
            end
        end
    end

    // Bit-banging FSM for WS2812B protocol
    localparam T1H = 80;   // 800 ns high for '1'
    localparam T0H = 40;   // 400 ns high for '0'
    localparam TL  = 45;   // Common low time
    localparam RESET_CYCLES = 5000;  // >50 us reset

    reg [23:0] current_grb;
    reg [10:0] bit_count;   // 24 bits * NUM_LEDS
    reg [12:0] timer;
    reg [7:0] led_idx;
    reg [2:0] color_idx;    // 0=G,1=R,2=B
    reg sending;

    always @(posedge clk_100m or posedge reset) begin
        if (reset) begin
            dout <= 0;
            sending <= 0;
            timer <= RESET_CYCLES;
        end else if (timer > 0) begin
            timer <= timer - 1;
            dout <= 0;
        end else if (!sending) begin
            sending <= 1;
            led_idx <= 0;
            color_idx <= 0;
            bit_count <= 0;
            timer <= 0;
        end else begin
            if (bit_count[0] == 0) begin  // Start of bit
                current_grb = {leds[led_idx][0], leds[led_idx][1], leds[led_idx][2]};
                dout <= 1;  // High start
                if (current_grb[23 - bit_count[10:1]])  // MSB first
                    timer <= T1H + TL;
                else
                    timer <= T0H + TL;
            end else begin
                dout <= 0;  // Low part
            end

            bit_count <= bit_count + 1;
            if (bit_count == 24 * NUM_LEDS) begin
                sending <= 0;
                timer <= RESET_CYCLES;  // Reset pulse
            end else if (bit_count[0] == 1) begin
                // Move to next bit/color/LED
                if (color_idx == 2 && bit_count[2:0] == 7) begin
                    color_idx <= 0;
                    led_idx <= led_idx + 1;
                end else if (bit_count[2:0] == 7) begin
                    color_idx <= color_idx + 1;
                end
            end
        end
    end
endmodule

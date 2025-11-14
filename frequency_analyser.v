// Frequency Analyzer: Splits into low/mid/high bands using simple filters
// For better accuracy, use Xilinx FFT IP; this is a basic IIR approximation
module frequency_analyzer (
    input clk,
    input signed [23:0] audio_in,
    output reg [7:0] low_band,   // Bass (e.g., 20-200 Hz)
    output reg [7:0] mid_band,   // Mid (200-2000 Hz)
    output reg [7:0] high_band   // High (2000+ Hz)
);

    // Simple IIR low-pass for bass (alpha = 0.1)
    reg signed [23:0] low_filt;
    always @(posedge clk) begin
        low_filt <= low_filt + ((audio_in - low_filt) >>> 4);  // Approx 0.0625 gain
    end

    // Band-pass for mid: high-pass then low-pass
    reg signed [23:0] high_temp, mid_filt;
    always @(posedge clk) begin
        high_temp <= audio_in - low_filt;  // High-pass = input - low-pass
        mid_filt <= mid_filt + ((high_temp - mid_filt) >>> 3);  // Low-pass on high
    end

    // High-pass for treble
    reg signed [23:0] high_filt;
    always @(posedge clk) begin
        high_filt <= high_temp - mid_filt;
    end

    // Energy levels (rectify and average)
    reg [31:0] low_acc, mid_acc, high_acc;
    reg [9:0] cnt;
    always @(posedge clk) begin
        low_acc <= low_acc + (low_filt < 0 ? -low_filt : low_filt);
        mid_acc <= mid_acc + (mid_filt < 0 ? -mid_filt : mid_filt);
        high_acc <= high_acc + (high_filt < 0 ? -high_filt : high_filt);
        cnt <= cnt + 1;
        if (cnt == 1023) begin  // Average over 1024 samples
            low_band <= low_acc[23:16];   // Scale to 8 bits
            mid_band <= mid_acc[23:16];
            high_band <= high_acc[23:16];
            low_acc <= 0; mid_acc <= 0; high_acc <= 0;
            cnt <= 0;
        end
    end

endmodule

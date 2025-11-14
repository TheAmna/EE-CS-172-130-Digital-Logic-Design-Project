// Beat Detector: Threshold on low-band energy
module beat_detector (
    input clk,
    input [7:0] bass_energy,
    output reg beat_pulse
);

    reg [7:0] avg_energy;
    reg [15:0] refractory_cnt;  // Counter for min time between beats

    always @(posedge clk) begin
        // Running average
        avg_energy <= (avg_energy * 31 + bass_energy) / 32;  // Slow update

        if (refractory_cnt > 0) begin
            refractory_cnt <= refractory_cnt - 1;
            beat_pulse <= 0;
        end else begin
            if (bass_energy > (avg_energy + (avg_energy >> 1))) begin  // > 1.5x avg
                beat_pulse <= 1;
                refractory_cnt <= 24000;  // ~0.5s at 48 kHz sample rate
            end else begin
                beat_pulse <= 0;
            end
        end
    end

endmodule

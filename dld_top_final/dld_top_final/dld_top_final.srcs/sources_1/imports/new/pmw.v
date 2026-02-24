module pwm_song_encoder #(
    parameter CLK_FREQ = 100_000_000
) (
    input clk,
    input [2:0] song_sel,
    input [4:0] switches,
    output reg pwm_out = 1
);

    // Simple direct comparison - no fancy math
    // At 100MHz: 1us = 100 cycles
    // Pulse widths needed:
    // Song 0: 500us = 50,000 cycles
    // Song 1: 1000us = 100,000 cycles
    // Song 2: 1500us = 150,000 cycles
    // Song 3: 2000us = 200,000 cycles
    // Song 4: 2500us = 250,000 cycles
    
    reg [31:0] counter = 0;
    wire any_switch_on = (switches != 5'b00000);
    
    always @(posedge clk) begin
        if (!any_switch_on) begin
            pwm_out <= 1;  // Idle HIGH
            counter <= 0;
        end else begin
            // Simple pulse generation with direct comparisons
            case (song_sel)
                3'd0: pwm_out <= (counter < 50_000) ? 0 : 1;    // 500us
                3'd1: pwm_out <= (counter < 100_000) ? 0 : 1;   // 1000us
                3'd2: pwm_out <= (counter < 150_000) ? 0 : 1;   // 1500us
                3'd3: pwm_out <= (counter < 200_000) ? 0 : 1;   // 2000us
                3'd4: pwm_out <= (counter < 250_000) ? 0 : 1;   // 2500us
                default: pwm_out <= 1;
            endcase
            
            // Counter for 10ms period (1,000,000 cycles)
            counter <= counter + 1;
            if (counter >= 1_000_000) begin
                counter <= 0;
            end
        end
    end

endmodule
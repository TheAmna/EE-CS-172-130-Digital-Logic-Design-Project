`timescale 1ns / 1ps

module beat_rom #(
    parameter ADDR_WIDTH = 13
) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] frame_addr,
    input wire [2:0] song_sel,
    output reg [3:0] beat_intensity,      // 0-15 beat strength
    output reg beat_pulse                 // 1 when beat > threshold
);

// Beat intensity memory (4-bit per frame)
reg [3:0] rom0 [0:(1<<ADDR_WIDTH)-1];
reg [3:0] rom1 [0:(1<<ADDR_WIDTH)-1];
reg [3:0] rom2 [0:(1<<ADDR_WIDTH)-1];
reg [3:0] rom3 [0:(1<<ADDR_WIDTH)-1];
reg [3:0] rom4 [0:(1<<ADDR_WIDTH)-1];

initial begin
    // Load beat data
    $readmemh("colors_song1_beats.mem", rom0);
    $readmemh("colors_song2_beats.mem", rom1);
    $readmemh("colors_song3_beats.mem", rom2);
    $readmemh("colors_song4_beats.mem", rom3);
    $readmemh("colors_song5_beats.mem", rom4);
end

always @(posedge clk) begin
    // Read beat intensity for current frame
    case (song_sel)
        3'd0: beat_intensity <= rom0[frame_addr];
        3'd1: beat_intensity <= rom1[frame_addr];
        3'd2: beat_intensity <= rom2[frame_addr];
        3'd3: beat_intensity <= rom3[frame_addr];
        3'd4: beat_intensity <= rom4[frame_addr];
        default: beat_intensity <= 4'd0;
    endcase
    
    // Generate pulse when beat is strong (threshold = 12)
    beat_pulse <= (beat_intensity > 4'd12);
end

endmodule
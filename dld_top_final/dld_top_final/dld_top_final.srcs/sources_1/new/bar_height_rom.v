`timescale 1ns / 1ps

module bar_height_rom #(
    parameter ADDR_WIDTH = 13,
    parameter NUM_BARS = 16
) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] frame_addr,
    input wire [2:0] song_sel,
    output reg [63:0] bar_heights_packed
);

// Memory for bar heights
// Each address stores 8 bytes = 64 bits = 16 bars × 4 bits
reg [63:0] rom0 [0:(1<<ADDR_WIDTH)-1];
reg [63:0] rom1 [0:(1<<ADDR_WIDTH)-1];
reg [63:0] rom2 [0:(1<<ADDR_WIDTH)-1];
reg [63:0] rom3 [0:(1<<ADDR_WIDTH)-1];
reg [63:0] rom4 [0:(1<<ADDR_WIDTH)-1];

initial begin
    $readmemh("colors_song1_bars.mem", rom0);
    $readmemh("colors_song2_bars.mem", rom1);
    $readmemh("colors_song3_bars.mem", rom2);
    $readmemh("colors_song4_bars.mem", rom3);
    $readmemh("colors_song5_bars.mem", rom4);
end

always @(posedge clk) begin
    case (song_sel)
        3'd0: bar_heights_packed <= rom0[frame_addr];
        3'd1: bar_heights_packed <= rom1[frame_addr];
        3'd2: bar_heights_packed <= rom2[frame_addr];
        3'd3: bar_heights_packed <= rom3[frame_addr];
        3'd4: bar_heights_packed <= rom4[frame_addr];
        default: bar_heights_packed <= 64'b0;
    endcase
end

endmodule
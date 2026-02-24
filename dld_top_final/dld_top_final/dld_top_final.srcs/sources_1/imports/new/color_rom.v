//module color_rom #(
//    parameter ADDR_WIDTH = 13,
//    parameter DATA_WIDTH = 24
//) (
//    input wire clk,
//    input wire [ADDR_WIDTH-1:0] addr,
//    input wire [2:0] song_sel,          // Dynamic input (not parameter)
//    output reg [DATA_WIDTH-1:0] color_out
//);

//reg [DATA_WIDTH-1:0] rom0 [0:(1<<ADDR_WIDTH)-1];
//reg [DATA_WIDTH-1:0] rom1 [0:(1<<ADDR_WIDTH)-1];
//reg [DATA_WIDTH-1:0] rom2 [0:(1<<ADDR_WIDTH)-1];
//reg [DATA_WIDTH-1:0] rom3 [0:(1<<ADDR_WIDTH)-1];
//reg [DATA_WIDTH-1:0] rom4 [0:(1<<ADDR_WIDTH)-1];

//initial begin
//    $readmemh("colors_song1.mem", rom0);
//    $readmemh("colors_song5.mem", rom1);
//    $readmemh("colors_song3.mem", rom2);
//    $readmemh("colors_song4.mem", rom3);
//    $readmemh("colors_song5.mem", rom4);
//end

//always @(posedge clk) begin
//    case (song_sel)
//        0: color_out <= rom0[addr];
//        1: color_out <= rom1[addr];
//        2: color_out <= rom2[addr];
//        3: color_out <= rom3[addr];
//        4: color_out <= rom4[addr];
//        default: color_out <= 24'b0;
//    endcase
//end

//endmodule

`timescale 1ns / 1ps

module color_rom #(
    parameter ADDR_WIDTH = 13,
    parameter DATA_WIDTH = 24
) (
    input wire clk,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [2:0] song_sel,
    output reg [DATA_WIDTH-1:0] color_out,
    output reg [12:0] frame_count_out  // Optional: song length
);

// 24-bit RGB ROMs (8 bits per channel)
reg [DATA_WIDTH-1:0] rom0 [0:8191];
reg [DATA_WIDTH-1:0] rom1 [0:8191];
reg [DATA_WIDTH-1:0] rom2 [0:8191];
reg [DATA_WIDTH-1:0] rom3 [0:8191];
reg [DATA_WIDTH-1:0] rom4 [0:8191];

// Frame counts (from first line of each file)
reg [12:0] frame_counts [0:4];

initial begin
    // Load color data
    $readmemh("colors_song1.mem", rom0);
    $readmemh("colors_song2.mem", rom1);
    $readmemh("colors_song3.mem", rom2);
    $readmemh("colors_song4.mem", rom3);
    $readmemh("colors_song5.mem", rom4);
    
    // Extract frame counts (first entry)
    frame_counts[0] = rom0[0][12:0];
    frame_counts[1] = rom1[0][12:0];
    frame_counts[2] = rom2[0][12:0];
    frame_counts[3] = rom3[0][12:0];
    frame_counts[4] = rom4[0][12:0];
    
    // Set output
    frame_count_out = frame_counts[song_sel];
end

always @(posedge clk) begin
    // Skip address 0 (contains frame count)
    if (addr == 0) begin
        color_out <= 24'h000000;
    end else begin
        case (song_sel)
            3'd0: color_out <= rom0[addr];
            3'd1: color_out <= rom1[addr];
            3'd2: color_out <= rom2[addr];
            3'd3: color_out <= rom3[addr];
            3'd4: color_out <= rom4[addr];
            default: color_out <= 24'h000000;
        endcase
    end
end

endmodule
`timescale 1ns / 1ps
module string_renderer #(
    parameter TEXT_LENGTH = 11,
    parameter SCALE = 1,
    parameter CHAR_WIDTH = 8,
    parameter CHAR_HEIGHT = 16
)(
    input clk,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input [TEXT_LENGTH*8-1:0] text_string,
    input [9:0] X_POS,
    input [9:0] Y_POS,
    output reg text_on
);
    // Scaled dimensions
    localparam SCALED_WIDTH  = CHAR_WIDTH * SCALE;
    localparam SCALED_HEIGHT = CHAR_HEIGHT * SCALE;

    wire [9:0] text_x_end = X_POS + (TEXT_LENGTH * SCALED_WIDTH);
    wire [9:0] text_y_end = Y_POS + SCALED_HEIGHT;

    // Check if in text region
    wire in_text_region = (pixel_x >= X_POS) && (pixel_x < text_x_end) &&
                          (pixel_y >= Y_POS) && (pixel_y < text_y_end);

    // Calculate position within text
    wire [9:0] x_offset = pixel_x - X_POS;
    wire [9:0] y_offset = pixel_y - Y_POS;

    wire [4:0] char_index = x_offset / SCALED_WIDTH;
    wire [2:0] bit_offset = (x_offset % SCALED_WIDTH) / SCALE;   // corrected
    wire [3:0] row_offset = y_offset / SCALE;

    // Get current ASCII character
    reg [7:0] current_ascii;
    always @(*) begin
        if (char_index < TEXT_LENGTH) begin
            current_ascii = text_string[(TEXT_LENGTH - 1 - char_index) * 8 +: 8];
        end else begin
            current_ascii = 7'h20; // space
        end
    end

    // ASCII ROM lookup
    wire [10:0] rom_addr;
    wire [7:0] rom_data;

    ascii_rom rom_inst(
        .clk(clk),
        .addr(rom_addr),
        .data(rom_data)
    );

    assign rom_addr = {current_ascii, row_offset};

    // Corrected bit indexing: MSB is leftmost pixel
    wire rom_bit = rom_data[8 - bit_offset];

    // Pipeline registers
    reg rom_bit_reg;
    reg in_text_region_reg;

    always @(posedge clk) begin
        rom_bit_reg <= rom_bit;
        in_text_region_reg <= in_text_region;
    end

    always @(posedge clk) begin
        text_on <= in_text_region_reg && rom_bit_reg;
    end
endmodule
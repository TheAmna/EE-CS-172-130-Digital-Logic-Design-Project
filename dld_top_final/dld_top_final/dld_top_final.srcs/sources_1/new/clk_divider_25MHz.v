// clk_divider_25MHz.v
`timescale 1ns / 1ps
module clk_divider_25MHz (
    input clk_100MHz,
    output reg clk_25MHz = 0
);
    reg [1:0] counter = 0;
    always @(posedge clk_100MHz) begin
        counter <= counter + 1;
        clk_25MHz <= counter[1];        // 100 MHz ? divide by 4 ? 25 MHz
    end
endmodule
`timescale 1ns / 1ps


module pixel_gen_module(

//input clk_d, // pixel clock
//input [9:0] pixel_x,
//input [9:0] pixel_y,
//input video_on,
//output reg [3:0] red=0,
//output reg [3:0] green=0,
//output reg [3:0] blue=0
//);
//always @(posedge clk_d)
//begin
//    if ((pixel_x ==0)|| (pixel_x ==639)|| (pixel_y==0)||(pixel_y==479)) begin
//        red <= 4'hF; 
//        green <= 4'hF; 
//        blue <= 4'hF;
//        end
//    else begin
//        red <= video_on?(pixel_y>240? 4'hF:4'h0):(4'h0);
//        green <= video_on?(pixel_y >240?4'h0:4'hF):(4'h0);
//        blue <= 4'h0;
//        end
//    end
//endmodule


    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg [3:0] red  = 0,
    output reg [3:0] green= 0,
    output reg [3:0] blue = 0
);

parameter size = 480; 
parameter grid_size = 8;
parameter square_size = size / grid_size;

localparam LEFT   = (640 - size)/2;
localparam RIGHT  = (640 + size)/2;
localparam TOP    = (480 - size)/2;
localparam BOTTOM = (480 + size)/2;

always @(posedge clk_d) begin
    if (!video_on) begin
        red   <= 0;
        green <= 0;
        blue  <= 0;
    end else begin
        // draw border
        if ((pixel_x == LEFT) || (pixel_x == RIGHT-1) ||
            (pixel_y == TOP)  || (pixel_y == BOTTOM-1)) begin
            red <= 4'hF; green <= 4'hF; blue <= 4'hF;
        end

        // inside the 480×480 square
        else if ((pixel_x >= LEFT) && (pixel_x < RIGHT) &&
                 (pixel_y >= TOP)  && (pixel_y < BOTTOM)) begin

            // chessboard pattern
            if (((pixel_x - LEFT) / square_size) % 2 ^
                ((pixel_y - TOP ) / square_size) % 2) begin
                red <= 4'hF; green <= 4'hF; blue <= 4'hF;  // white
            end
            else begin
                red <= 0; green <= 0; blue <= 0;          // black
            end
        end

        else begin
            red <= 0; green <= 0; blue <= 0;              // background black
        end
    end
end

endmodule

         

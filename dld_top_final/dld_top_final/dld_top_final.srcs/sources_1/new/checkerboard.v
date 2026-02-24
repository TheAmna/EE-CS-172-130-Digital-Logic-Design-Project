
`timescale 1ns / 1ps
module checkerboard(
    input clk_d, // pixel clock
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg [3:0] red=0,
    output reg [3:0] green=0,
    output reg [3:0] blue=0
    );
    
parameter size = 480; 
parameter grid_size=8;
parameter square_size=size/grid_size;
localparam LEFT=(640-size)/2;
localparam RIGHT = (640+ size)/2;
localparam TOP= (480 - size)/2;
localparam BOTTOM= (480+size)/2;

always@ (posedge clk_d) begin
    if (video_on) begin
        if(( pixel_x==LEFT) || (pixel_x==RIGHT-1) || (pixel_y == TOP) || (pixel_y == BOTTOM -1)) begin
            red <=4'hF;
            green <=4'hF;
            blue <=4'hF;
         end
         else if (( pixel_x>=LEFT) && (pixel_x < RIGHT) && ( pixel_y >=TOP ) && ( pixel_y < BOTTOM)) begin
            if ((((pixel_x -LEFT) / square_size) %2 )^ (((pixel_y -TOP)/square_size)%2)) begin
                red <=4'hF;
                green <=4'hF;
                blue <=4'hF;
            end
            else
                begin 
                red <=4'hF;
                green <=4'hF;
                blue <=4'hF;
            end
        end
        else
            begin
            red <=4'hF;
            green <=4'hF;
            blue <=4'hF;
            end
        end
    else
    begin
    red <=4'hF;
    green <=4'hF;
    blue <=4'hF;
    end
       
end
endmodule            
         
         

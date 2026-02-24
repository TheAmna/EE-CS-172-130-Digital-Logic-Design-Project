`timescale 1ns/1ps
module pix_gentb;
    reg clk_d; // pixel clock
    reg[9:0] pixel_x;
    reg [9:0] pixel_y;
    reg video_on;
    wire [3:0] red=0;
    wire [3:0] green=0;
    wire [3:0] blue=0;
    
    pixel_gen_module u0 (.clk_d(clk_d),.pixel_y(pixel_y),.video_on(video_on),.red(red),.green(green), .blue(blue));
    initial 
    begin
        clk_d=0;
        forever #5 clk_d=~clk_d;
    end
    
    initial
    begin
        pixel_x=0;
        pixel_y=0;
        video_on=1;
        
        repeat(480) begin
            repeat (640) begin
                #10 pixel_x=pixel_x +1;
                if (pixel_x ==639) begin
                    pixel_x=0;
                    pixel_y=pixel_y+1;
                    if (pixel_y==479) pixel_y=0;
                 end
             
            end               
        end
         $stop;
    end
endmodule    


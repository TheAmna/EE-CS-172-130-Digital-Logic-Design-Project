`timescale 1ns / 1ps

module vga_cont_tb;

    reg clk;
    wire h_sync , v_sync;
    wire [3:0] red , green , blue;
    
    vga_controller tb(clk , h_sync , v_sync , red , green, blue);
    initial
    begin
        clk=0;
        forever #5 clk=~clk;
    end
    initial
    begin
        #100000;
        $stop;
    end

endmodule    
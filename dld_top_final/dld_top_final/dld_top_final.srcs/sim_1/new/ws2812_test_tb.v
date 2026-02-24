//`timescale 1ns / 1ps

//module ws2812_test_tb;

//    // Inputs
//    reg clk;
//    reg reset_n;

//    // Outputs
//    wire data_out;

//    // Instantiate the Unit Under Test (UUT)
//    ws2812_test uut (
//        .clk(clk),
//        .reset_n(reset_n),
//        .data_out(data_out)
//    );

//    // Clock generation (100 MHz -> 10 ns period)
//    always #5 clk = ~clk;  // Toggle every 5 ns for 100 MHz

//    initial begin
//        // Initialize Inputs
//        clk = 0;
//        reset_n = 0;  // Assert reset

//        // Wait 100 ns for global reset to finish
//        #100;
//        reset_n = 1;  // Release reset

//        // Run simulation for a while to observe multiple cycles
//        #100000;  // Simulate for 100 us (enough for a few full data sends)

//        $finish;  // End simulation
//    end

//    // Optional: Dump waveforms for viewing in simulator
//    initial begin
//        $dumpfile("ws2812_test_tb.vcd");
//        $dumpvars(0, ws2812_test_tb);
//    end

//endmodule






//`timescale 1ns / 1ps
//module tb_ws2812;
//    reg clk;
//    wire data_out;
    
//    ws2812_final uut(.clk(clk), .data_out(data_out));
    
//    initial begin
//        clk = 0;
//        forever #5 clk = ~clk; // 100MHz clock
//    end
    
//    initial begin
//        #1000000; // Run for 1ms
//        $finish;
//    end
//endmodule



`timescale 1ns / 1ps

module ws2812_driver_tb;

    reg clk = 0;
    reg reset = 1;
    wire data_out;

    ws2812_driver uut (
        .clk(clk),
        .reset(reset),
        .data_out(data_out)
    );

    always #5 clk = ~clk;  // 100MHz clock (10ns period)

    initial begin
        #20 reset = 0;  // Release reset
        #100_000_000;   // Simulate for some time (adjust as needed)
        $finish;
    end

    initial begin
        $dumpfile("ws2812_driver_tb.vcd");
        $dumpvars(0, ws2812_driver_tb);
    end

endmodule
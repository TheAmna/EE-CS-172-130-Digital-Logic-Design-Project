`timescale 1ns / 1ps

module tb_top();

    // Inputs
    reg clk_100MHz;
    reg r1;
    reg t1;
    reg u1;
    reg w1;
    reg r3;

    // Outputs
    wire h_sync;
    wire v_sync;
    wire [3:0] red;
    wire [3:0] green;
    wire [3:0] blue;

    // Instantiate the Unit Under Test (UUT)
    top uut (
        .clk_100MHz(clk_100MHz),
        .r1(r1),
        .t1(t1),
        .u1(u1),
        .w1(w1),
        .r3(r3),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // Clock generation: 100 MHz clock (period 10 ns)
    always #5 clk_100MHz = ~clk_100MHz;

    initial begin
        // Initialize Inputs
        clk_100MHz = 0;
        r1 = 0;
        t1 = 0;
        u1 = 0;
        w1 = 0;
        r3 = 0;

        // Wait for global reset
        #100;

        // Test case 1: No song selected (song selection screen)
        #100000;  // Run for some time to simulate frames

        // Test case 2: Select song 1 (switch to visualizer)
        r1 = 1;
        #10000000;  // Run longer to see bar fluctuations

        // Test case 3: Select another song
        r1 = 0;
        t1 = 1;
        #10000000;

        // End simulation
        $finish;
    end

    // Optional: Monitor outputs (for waveform viewing)
    initial begin
        $monitor("Time=%t | h_sync=%b | v_sync=%b | red=%h | green=%h | blue=%h", $time, h_sync, v_sync, red, green, blue);
    end

endmodule
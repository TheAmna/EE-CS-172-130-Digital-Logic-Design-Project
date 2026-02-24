//`timescale 1ns / 1ps

//module music_player_tb;

//    // Inputs
//    reg clk;
//    reg R2, T1, U1, W2, R3;
    
//    // Outputs
//    wire h_sync;
//    wire v_sync;
//    wire [3:0] red;
//    wire [3:0] green;
//    wire [3:0] blue;
    
//    // Instantiate the unit under test (UUT)
//    music_player_controller uut (
//        .clk(clk),
//        .R2(R2),
//        .T1(T1),
//        .U1(U1),
//        .W2(W2),
//        .R3(R3),
//        .h_sync(h_sync),
//        .v_sync(v_sync),
//        .red(red),
//        .green(green),
//        .blue(blue)
//    );
    
//    // Clock generation (100MHz clock)
//    initial begin
//        clk = 0;
//        forever #5 clk = ~clk;
//    end
    
//    // Test stimulus
//    initial begin
//        // Initialize all switches to OFF
//        R2 = 0; T1 = 0; U1 = 0; W2 = 0; R3 = 0;
        
//        #100;
        
//        $display("Starting Music Player Simulation...");
//        $display("Time\t\tSwitches\tSelected Song");
//        $display("----------------------------------------");
        
//        // Test each switch individually
//        #100000 R2 = 1;  // Select Song 1
//        $display("%0t\t\tR2=1\t\tSong 1", $time);
        
//        #100000 R2 = 0; T1 = 1;  // Select Song 2
//        $display("%0t\t\tT1=1\t\tSong 2", $time);
        
//        #100000 T1 = 0; U1 = 1;  // Select Song 3
//        $display("%0t\t\tU1=1\t\tSong 3", $time);
        
//        #100000 U1 = 0; W2 = 1;  // Select Song 4
//        $display("%0t\t\tW2=1\t\tSong 4", $time);
        
//        #100000 W2 = 0; R3 = 1;  // Select Song 5
//        $display("%0t\t\tR3=1\t\tSong 5", $time);
        
//        #100000 R3 = 0;  // No selection
//        $display("%0t\t\tNone\t\tNo selection", $time);
        
//        $display("\nSimulation completed!");
//        $stop;
//    end

//endmodule


`timescale 1ns / 1ps
module tb_music_player;

    reg clk_100MHz;
    reg r1, t1, u1, w1, r3;

    wire h_sync, v_sync;
    wire [3:0] red, green, blue;

    // Instantiate your top module
    music_player_controller dut (
        .clk_100MHz(clk_100MHz),
        .r1(r1), .t1(t1), .u1(u1), .w1(w1), .r3(r3),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    // 100 MHz clock
    always #5 clk_100MHz = ~clk_100MHz;

    initial begin
        clk_100MHz = 0;
        r1=0; t1=0; u1=0; w1=0; r3=0;

        #100000;        // wait a few frames

        // Test song 1 selection
        r1 = 1;
        #20000000;      // hold for many frames ? you will see digit 1 turn red

        // Test song 3
        r1 = 0; u1 = 1;
        #20000000;

        // Test song 5
        u1 = 0; r3 = 1;
        #20000000;

        $display("Simulation finished - check waveform!");
        $finish;
    end

    // Optional: monitor color changes
    always @(posedge dut.clk_25MHz) begin
        if (red == 4'hF && green == 4'h0 && blue == 4'h0)
            $display("Time %t : RED pixel detected ? selection active!", $time);
    end

endmodule
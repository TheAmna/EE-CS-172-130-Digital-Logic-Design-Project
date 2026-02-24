//module bram_reader (
//    input clk, rst,
//    output reg [7:0] freq[0:15],
//    output reg beat,
//    output reg valid
//);
//    (* ram_style = "block" *)
//    reg [31:0] mem [0:131071];
//    initial $readmemh("audio_data.mem", mem);

//    reg [18:0] addr = 0;
//    reg [23:0] cnt = 0;
//    localparam CLK_PER_FRAME = 100_000_000 / 60;

//    always @(posedge clk) begin
//        valid <= 0;
//        if (rst) begin addr <= 0; cnt <= 0; end
//        else begin
//            cnt <= cnt + 1;
//            if (cnt == CLK_PER_FRAME-1) begin
//                cnt <= 0; valid <= 1;
//                beat <= mem[addr][24];
//                freq[0]  <= mem[addr][23:16];
//                freq[1]  <= mem[addr][15:8];
//                freq[2]  <= mem[addr][7:0];
//                freq[3]  <= mem[addr+1][31:24];
//                freq[4]  <= mem[addr+1][23:16];
//                freq[5]  <= mem[addr+1][15:8];
//                freq[6]  <= mem[addr+1][7:0];
//                freq[7]  <= mem[addr+2][31:24];
//                freq[8]  <= mem[addr+2][23:16];
//                freq[9]  <= mem[addr+2][15:8];
//                freq[10] <= mem[addr+2][7:0];
//                freq[11] <= mem[addr+3][31:24];
//                freq[12] <= mem[addr+3][23:16];
//                freq[13] <= mem[addr+3][15:8];
//                freq[14] <= mem[addr+3][7:0];
//                freq[15] <= mem[addr+4][7:0];
//                addr <= addr + 5;
//                if (addr > 130000) addr <= 0;
//            end
//        end
//    end
//endmodule
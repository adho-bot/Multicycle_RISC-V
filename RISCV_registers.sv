module RISCV_registers(
    input  logic        [31:0] WD3,       // Data to be written
    input  logic               WD3_en,    // High for write, low for read
    input  logic               clk,       // System clock
    input  logic               rst,       // Master Reset
    input  logic        [4:0]  A1_addr,   // Read rs1
    input  logic        [4:0]  A2_addr,   // Read rs2
    input  logic        [4:0]  A3_addr,   // Writeback rd
    output logic       [31:0]  RD1,
    output logic       [31:0]  RD2
);

    logic [31:0] register [0:31];

    // Asynchronous Read. 0 for x0 register
    assign RD1 = (A1_addr == 5'b00000) ? 32'd0 : register[A1_addr];
    assign RD2 = (A2_addr == 5'b00000) ? 32'd0 : register[A2_addr];

    // Synchronous Write & Reset
    always_ff @(posedge clk) begin
        if (rst) begin
            register[0]  <= 32'd0;
            register[1]  <= 32'd0;
            register[2]  <= 32'd0;
            register[3]  <= 32'd0;
            register[4]  <= 32'd0;
            register[5]  <= 32'd0;
            register[6]  <= 32'd0;
            register[7]  <= 32'd0;
            register[8]  <= 32'd0;
            register[9]  <= 32'd0;
            register[10] <= 32'd0;
            register[11] <= 32'd0;
            register[12] <= 32'd0;
            register[13] <= 32'd0;
            register[14] <= 32'd0;
            register[15] <= 32'd0;
            register[16] <= 32'd0;
            register[17] <= 32'd0;
            register[18] <= 32'd0;
            register[19] <= 32'd0;
            register[20] <= 32'd0;
            register[21] <= 32'd0;
            register[22] <= 32'd0;
            register[23] <= 32'd0;
            register[24] <= 32'd0;
            register[25] <= 32'd0;
            register[26] <= 32'd0;
            register[27] <= 32'd0;
            register[28] <= 32'd0;
            register[29] <= 32'd0;
            register[30] <= 32'd0;
            register[31] <= 32'd0;
        end else if (WD3_en && (A3_addr != 5'd0)) begin
            register[A3_addr] <= WD3;
        end
    end

endmodule

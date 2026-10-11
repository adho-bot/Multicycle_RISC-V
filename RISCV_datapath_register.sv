module RISCV_datapath_register(
    input  logic [31:0] in_reg,
    input  logic        clk,
    input  logic        rst,
    input  logic        enable,
    output logic [31:0] out_reg
);

always_ff @(posedge clk) begin
    if (rst)
        out_reg <= 32'b0;     
    else if (enable)
        out_reg <= in_reg;        
    else
        out_reg <= out_reg;       
end
endmodule


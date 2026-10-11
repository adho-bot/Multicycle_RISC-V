//32 bit
//2:1 mux
module RISCV_mux32bit21(
input logic  [31:0] input_0,
input logic  [31:0] input_1,
input logic  select,
output logic [31:0] output_mux	
);

always_comb begin
	output_mux = (select) ? input_1 : input_0;
end

endmodule


//32 bit
//4:1 mux
module RISCV_mux32bit41(
input logic  [31:0] input_0,
input logic  [31:0] input_1,
input logic  [31:0] input_2,
input logic  [31:0] input_3,
input logic  [1:0]  select,
output logic [31:0] output_mux	
);

always_comb begin
	case(select)
	2'b00:	output_mux = input_0;
	2'b01:	output_mux = input_1;
	2'b10:	output_mux = input_2;
	2'b11:	output_mux = input_3;
	default:output_mux = 32'd0;
	endcase
end

endmodule


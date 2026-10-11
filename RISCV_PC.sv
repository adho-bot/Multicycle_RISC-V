//Verified
module RISCV_PC (
    	input logic         clk,
    	input logic         rst,
    	input logic 	    PC_en,	 
    	input logic  [31:0] PC_in,
    	output logic [31:0] PC_out,          // Current PC value
    	output logic [31:0] old_PC_out    	
);

	// PC registers
	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			PC_out <= 32'h00000000;    
			old_PC_out <= 32'h00000000;
		end else if (PC_en) begin
			PC_out <= PC_in;
			old_PC_out <= PC_out;          		// Store current PC as previous
		end else begin
			PC_out <= PC_out;
			old_PC_out <= old_PC_out;
		end
	end
endmodule

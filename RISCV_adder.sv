//Verified
module RISCV_adder(
	input logic         add_sel,        // Control signal to load new PC value
    	input logic  [31:0] IMM,
	input logic  [31:0] PC_old,
	input logic  [31:0] PC_out,
	output logic [31:0] Adder_out
);

    logic [31:0] output_mux1;           // Output from first mux (selects PC base)
    logic [31:0] output_mux2;           // Output from second mux (selects offset)
    
    // First mux: Select between current PC (normal) or previous PC (for branches)
    RISCV_mux32bit21 mux1 (
        .input_0(PC_out), 
        .input_1(PC_old), 
        .select(add_sel), 
        .output_mux(output_mux1)
    );
    
    // Second mux: Select between +4 or IMM (offset)
    RISCV_mux32bit21 mux2 (
        .input_0(32'd4),                
        .input_1(IMM), 
        .select(add_sel), 
        .output_mux(output_mux2)
    );
    
    
    always_comb begin
        Adder_out = output_mux1 + output_mux2;   	// Calculate new PC
    end
endmodule

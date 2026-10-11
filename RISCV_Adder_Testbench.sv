`timescale  1ns / 100ps
`define CLOCK_PERIOD  10
`include "RISCV_definitions.sv"
module RISCV_Adder_Testbench;

	logic         add_sel;        // Control signal to load new PC value
    	logic  [31:0] IMM;
	logic  [31:0] PC_old;
	logic  [31:0] PC_out;
	logic  [31:0] Adder_out;

	RISCV_adder uut(
		.add_sel(add_sel),
		.IMM(IMM),
		.PC_old(PC_old),
		.PC_out(PC_out),
		.Adder_out(Adder_out)
	);

	task adder_test(input sel, input [31:0] immediate, input [31:0] old, input [31:0] out); begin
		add_sel = sel;
		IMM = immediate;
		PC_old = old;
		PC_out = out;
		#1
		
		if(sel) 
			$display("OldPC + IMM selected");
		else
			$display("PC + 4 selected");
		$display("add_sel = %0b | IMM = %0d | PC_old = %0d | PC_out = %0d", sel, immediate, old, out); 
	end
	endtask 
	
	
	initial begin

		adder_test(0, 32'd0, 32'd100, 32'd104);
		assert (Adder_out === 32'd108)
			$display("Test 1 PASSED");
		else
			$fatal("Test 1 FAILED: Expected 104, got %0d", Adder_out);

		adder_test(1, 32'd20, 32'd100, 32'd120);
		assert (Adder_out === 32'd120)
			$display("Test 2 PASSED");
		else
			$fatal("Test 2 FAILED: Expected 120, got %0d", Adder_out);

		adder_test(1, -32'sd4, 32'd100, 32'd96);
		assert (Adder_out === 32'd96)
			$display("Test 3 PASSED");
		else
			$fatal("Test 3 FAILED: Expected 96, got %0d", Adder_out);

		adder_test(0, 32'd0, 32'd0, 32'd4);
		assert (Adder_out === 32'd8)
			$display("Test 4 PASSED");
		else
			$fatal("Test 4 FAILED: Expected 4, got %0d", Adder_out);

		adder_test(1, 32'd1024, 32'd500, 32'd1524);
		assert (Adder_out === 32'd1524)
			$display("Test 5 PASSED");
		else
			$fatal("Test 5 FAILED: Expected 1524, got %0d", Adder_out);

		adder_test(1, -32'sd1024, 32'd2000, 32'd976);
		assert (Adder_out === 32'd976)
			$display("Test 6 PASSED");
		else
			$fatal("Test 6 FAILED: Expected 976, got %0d", Adder_out);

		$display("All 6 tests PASSED.");
		$display("---------------------------------");
	end
endmodule

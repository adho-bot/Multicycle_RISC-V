//functions for combinatorial zero timing constraints
//task for delay statements    for simulation time stuff

`timescale  1ns / 100ps
`define CLOCK_PERIOD  10
`include "RISCV_definitions.sv"

module RISCV_ALU_Testbench;

    logic [9:0]  ALU_op;
    logic [31:0] SrcA, SrcB;
    logic        c_status;
    logic [31:0] ALU_out;

    // Instantiate the ALU
    RISCV_ALU uut (
        .ALU_op(ALU_op),
        .SrcA(SrcA),
        .SrcB(SrcB),
        .c_status(c_status),
        .ALU_out(ALU_out)
    );

class alu_val;
    rand bit [31:0] SrcA;
    rand bit [31:0] SrcB;
    randc bit [9:0] ALU_op;

    constraint operations {
        ALU_op == `ADD ||
        ALU_op == `SUB ||
        ALU_op == `SLL ||
        ALU_op == `XORR ||
        ALU_op == `SRL ||
        ALU_op == `SRA ||
        ALU_op == `ORR ||
        ALU_op == `ANDD ||
        ALU_op == `BEQ ||
        ALU_op == `BNE ||
        ALU_op == `BLT ||
        ALU_op == `BGE;
    }
endclass

// Object declaration
alu_val alu;

initial begin
    alu = new;
    for (int i = 0; i < 50; i++) begin
        assert (alu.randomize()) begin
	    SrcA = alu.SrcA;
	    SrcB = alu.SrcB;
	    ALU_op = alu.ALU_op;
            $display("  SrcA   = %0d", alu.SrcA);
            $display("  SrcB   = %0d", alu.SrcB);
            $display("  ALU_op = %0b", alu.ALU_op);
	    $display("  c_out  = %0b", c_status);
	    $display(" Result = %d", ALU_out);
        end else begin
            $error("Randomization failed at iteration %0d", i);
        end
        #(0.1); // Delay between iterations
    end
end
endmodule

/*
    task alu_test(input [9:0] op, input [31:0] A, input [31:0] B, string op_name); begin
            ALU_op = op;
            SrcA = A;
            SrcB = B;
            #1; 
            $display("Test %s: SrcA = %0d, SrcB = %0d --> ALU_out = %0d, c_status = %b", 
                     op_name, A, B, ALU_out, c_status);
        end
    endtask
    
    initial begin
        $display("Starting RISCV_ALU Testbench...");
        
        alu_test(`ADD,  32'd15, 32'd10, "ADD");     // Expect 25
        alu_test(`SUB,  32'd30, 32'd10, "SUB");     // Expect 20
        alu_test(`ANDD, 32'hF0F0F0F0, 32'h0F0F0F0F, "ANDD"); // Expect 0x00000000
        alu_test(`ORR,  32'hF0F0F0F0, 32'h0F0F0F0F, "ORR");  // Expect 0xFFFFFFFF
        alu_test(`XORR, 32'hFF00FF00, 32'h00FF00FF, "XORR"); // Expect 0xFFFFFFFF
        alu_test(`SLL,  32'd1, 32'd4, "SLL");        // Expect 16
        alu_test(`SRL,  32'd16, 32'd2, "SRL");       // Expect 4
        alu_test(`SRA,  32'hFFFFFFF0, 32'd2, "SRA");// Expect 0xFFFFFFFC
        alu_test(`BEQ,  32'd20, 32'd20, "BEQ");      // c_status = 1
        alu_test(`BNE,  32'd20, 32'd20, "BNE");      // c_status = 1
        alu_test(`BLT,  32'd10, 32'd20, "BLT");      // c_status = 1
        alu_test(`BGE,  32'd20, 32'd10, "BGE");      // c_status = 1
      
        
        $display("Testbench finished.");
        $display("-----------------------------------------------------");
    end
*/

//functions for combinatorial zero timing constraints
//task for delay statements    for simulation time stuff

`timescale  1ns / 100ps
`define CLOCK_PERIOD  10
`include "RISCV_definitions.sv"

module RISCV_PC_Testbench;

    	logic         clk;
    	logic         rst;
    	logic 	      PC_en;	 
    	logic  [31:0] PC_in;
    	logic  [31:0] PC_out;          
    	logic  [31:0] old_PC_out;    	

    // Instantiate the ALU
    RISCV_PC uut (
        .clk(clk),
        .rst(rst),
        .PC_en(PC_en),
        .PC_in(PC_in),
        .PC_out(PC_out), //output
        .old_PC_out(old_PC_out) //output
    );
   
    //Clock 
    initial clk = 0;		                         
    always #(`CLOCK_PERIOD/2) clk = !clk;


    	initial begin
        rst = 1;
        #(`CLOCK_PERIOD * 2);
        rst = 0;
        PC_en = 1;
        PC_in =32'd1;
        #`CLOCK_PERIOD;

        #`CLOCK_PERIOD;
        PC_in =32'd20;       
        #`CLOCK_PERIOD;
        PC_in =32'd50;
        PC_en = 0;
        #`CLOCK_PERIOD;
        PC_in =32'd100;       
        #(`CLOCK_PERIOD * 3);        
	
        
        $display("Testbench finished.");
        $display("-----------------------------------------------------");
	$stop;
    end

endmodule


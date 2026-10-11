`timescale 1ns / 100ps
`define CLOCK_PERIOD 10
`include "RISCV_definitions.sv"

module RISCV_Control_Testbench; //Used to test FSM + control decode implementation

 //---------RISCV_control Testbench Instantiation--------

    logic         clk;
    logic         rst;
    logic         c_status;
    logic [31:0]  ir;
    logic [3:0]	  state;

    logic         PC_en;
    logic         add_sel;
    logic         IR_en;
    logic [6:0]   se_sel;
    logic         data_reg_en;
    logic [1:0]   data_sel;
    logic         WD3_en;
    logic [4:0]   A1_addr;
    logic [4:0]   A2_addr;
    logic [4:0]   A3_addr;
    logic [2:0]   ALU_op;
    logic         srcB_sel;
    logic         ALU_reg_en;
    logic         Addr_sel;
    logic         mem_rd;
    logic         mem_wr;

    RISCV_control uut (
        .clk(clk),
        .rst(rst),
        .c_status(c_status),
        .ir(ir),
        .PC_en(PC_en),
        .add_sel(add_sel),
        .IR_en(IR_en),
        .se_sel(se_sel),
        .data_reg_en(data_reg_en),
        .data_sel(data_sel),
        .WD3_en(WD3_en),
        .A1_addr(A1_addr),
        .A2_addr(A2_addr),
        .A3_addr(A3_addr),
        .ALU_op(ALU_op),
        .srcB_sel(srcB_sel),
        .ALU_reg_en(ALU_reg_en),
        .Addr_sel(Addr_sel),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr));


    // Clock generation
    initial clk = 0;
    always #(`CLOCK_PERIOD / 2) clk = ~clk;

    //State Change Block
    initial begin
    rst = 1;
    ir = {25'd0, `OPCODE_LOAD}; 	// Load opcode
    #(`CLOCK_PERIOD * 2);
    rst = 0;   
    #(`CLOCK_PERIOD * 4);
    ir = {25'd0, `OPCODE_STORE}; 	// Store opcode				    
    #(`CLOCK_PERIOD * 4);  
    ir = {25'd0, `OPCODE_R_TYPE}; 	// R-type opcode  
    #(`CLOCK_PERIOD * 4);   
    ir = {25'd0, `OPCODE_I_TYPE}; 	// I-type opcode
    #(`CLOCK_PERIOD * 4);
    ir = {25'd0, `OPCODE_JAL}; 		// JAL opcode					
    #(`CLOCK_PERIOD * 4);    
    ir = {25'd0, `OPCODE_BRANCH}; 	// Branch opcode		 
    #(`CLOCK_PERIOD * 4);         
    ir = {25'd0, `OPCODE_LOAD}; 	// Load opcode
    #`CLOCK_PERIOD
    rst = 1;
    #(`CLOCK_PERIOD * 4);       
    $stop;
    end


endmodule


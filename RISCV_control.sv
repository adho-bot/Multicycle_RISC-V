`include "RISCV_definitions.sv"

/*----------------------------------------------------------------------------*/

module RISCV_control(input  logic		rst,		 // Reset
                     input  logic        	clk,		 // Clock
		     input  logic  	[31:0]        c_status,	 // ALU branch status
              	     input  logic  [31:0] 	ir,	         // Current instruction
                     output logic                PC_en,		 // PC register enable
                     output logic                add_sel,	 // Adder input selection 
                     output logic                IR_en,		 // Instruction register enable
 		     output logic  [6:0]         se_sel,		 // Sign extender operation     
 		     output logic                data_reg_en,	 // Data register enable
		     output logic  [1:0]         data_sel, 	 // Register input selector     
		     output logic  	        WD3_en,		 // Register write enable
		     output logic  [4:0]         A1_addr,	 // Register read select
		     output logic  [4:0]         A2_addr,	 // Register read select
              	     output logic  [4:0]         A3_addr,         // Register write selector
		     output logic  [9:0]         ALU_op,	 	 // ALU operation
              	     output logic                srcB_sel,	 // ALU RD2 selector
                     output logic                ALU_reg_en,	 // ALU register enable
      		     output logic                Addr_sel,        // Address Bus out select 
                     output logic                mem_rd,		 // Memory read enable
                     output logic                mem_wr,
                     output logic                 c_stat_en);	 // Memory write enable	
                   

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Declarations of any internal signals and buses used                        */

logic [3:0] state;


/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* Instantiate modules                                                        */

	RISCV_FSM FSM(
	   .clk(clk),	   
           .rst(rst),	 
           .ir(ir),        
           .state(state)
        );
     
     
	RISCV_control_decode DECODER(
	    .state(state),
	    .c_status(c_status),
	    .ir(ir),

	    // PC control
	    .PC_en(PC_en),
	    .add_sel(add_sel),

	    // Datapath controls
	    .IR_en(IR_en),
	    .se_sel(se_sel),
	    .data_reg_en(data_reg_en),
	    .data_sel(data_sel),

	    // Register control
	    .WD3_en(WD3_en),
	    .A1_addr(A1_addr),
	    .A2_addr(A2_addr),
	    .A3_addr(A3_addr),
	    .c_stat_en(c_stat_en),

	    // ALU control
	    .ALU_op(ALU_op),
	    .srcB_sel(srcB_sel),
	    .ALU_reg_en(ALU_reg_en),
	    .Addr_sel(Addr_sel),

	    // Memory control
	    .mem_rd(mem_rd),
	    .mem_wr(mem_wr)
	 );   
     
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/

/*----------------------------------------------------------------------------*/

endmodule

/*============================================================================*/

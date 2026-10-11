


module RISCV_datapath(input  logic		rst,		 // Reset
                     input  logic        	clk,		 // Clock
                     input logic                PC_en,		 // PC register enable
                     input logic                add_sel,	 // Adder input selection 
                     input logic                IR_en,		 // Instruction register enable
 		     input logic   [6:0]        se_sel,		 // Sign extender operation     
 		     input logic                data_reg_en,	 // Data register enable
		     input logic   [1:0]        data_sel, 	 // Register input selector     
		     input logic  	        WD3_en,		 // Register write enable
		     input logic   [4:0]        A1_addr,	 // Register read select
		     input logic   [4:0]        A2_addr,	 // Register read select
              	     input logic   [4:0]        A3_addr,         // Register write selector
		     input logic   [9:0]        ALU_op,	 	 // ALU operation
              	     input logic                srcB_sel,	 // ALU RD2 selector
                     input logic                ALU_reg_en,	 // ALU register enable
      		     input logic                Addr_sel,        // Address Bus out select 
      		     input logic                c_stat_en,
                     input logic   [31:0]	data_in,
                     output logic  [31:0]	c_stat_reg_out,	 // ALU branch status
                     output logic  [31:0]	data_out,
                     output logic  [31:0] 	address,
                     output logic  [31:0] 	curr_instr
                     );	 


	logic [31:0] old_PC_out, PC_out, Adder_out;
	logic [31:0] IMM, IR_out, data_reg_out;
	logic [31:0] ALU_out, ALU_reg_out;
	logic [31:0] SrcA, SrcB, RD2_reg_out, RD1, RD2;
	logic [31:0] WD3;
	logic        c_status;
	
	
/*------------------------------------------------------------------------------------------*/
/*					Program Counter 				    */
/*------------------------------------------------------------------------------------------*/
/*---------------------Program Counter---------------------*/
	RISCV_PC PC(
		.clk(clk),		//input
		.rst(rst),		//input
		.PC_en(PC_en),		//input
		.PC_in(Adder_out),	//input
		.PC_out(PC_out),	//output
		.old_PC_out(old_PC_out)	//output
	);


/*------------------------------------------------------------------------------------------*/
/*					Sign Extender	 				    */
/*------------------------------------------------------------------------------------------*/
/*---------------------Sign Extender---------------------*/
	RISCV_sign_extender sign_extender(
		.se_sel(se_sel),	//input
		.in_sign_ext(IR_out),		//input
		.IMM(IMM)		//output
	);


/*------------------------------------------------------------------------------------------*/
/*					Operation Modules 				    */
/*------------------------------------------------------------------------------------------*/

/*---------------------Adder---------------------*/
	RISCV_adder adder(
		.add_sel(add_sel),	//input
		.IMM(IMM),		//input
		.PC_old(old_PC_out),	//input
		.PC_out(PC_out),	//input
		.Adder_out(Adder_out)	//output
	);

/*---------------------ALU---------------------*/
	RISCV_ALU alu(
		.ALU_op(ALU_op),	//input
		.SrcA(SrcA),	//input
		.SrcB(SrcB),	//input
		.c_status(c_status),	//output
		.ALU_out(ALU_out)	//output
	);


/*------------------------------------------------------------------------------------------*/
/*					Registers	 				    */
/*------------------------------------------------------------------------------------------*/

/*---------------------Data Register---------------------*/
	RISCV_datapath_register data_reg(
		.in_reg(data_in),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.enable(data_reg_en),	//input
		.out_reg(data_reg_out)	//output
	);

/*-------------------------IR--------------------------*/
	RISCV_datapath_register IR(
		.in_reg(data_in),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.enable(IR_en),	//input
		.out_reg(IR_out)	//output
	);

/*---------------------ALU register---------------------*/
	RISCV_datapath_register ALU_reg(
		.in_reg(ALU_out),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.enable(ALU_reg_en),	//input
		.out_reg(ALU_reg_out)	//output
	);
	
/*---------------------RD1 Register---------------------*/
	RISCV_datapath_register RD1_reg(
		.in_reg(RD1),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.enable(1'b1),	//input
		.out_reg(SrcA)	//output
	);
	
/*---------------------RD2 Register---------------------*/
	RISCV_datapath_register RD2_reg(
		.in_reg(RD2),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.enable(1'b1),	//input
		.out_reg(RD2_reg_out)	//output
	);		
	
/*---------------------c_status Register---------------------*/
	RISCV_datapath_register c_stat_reg(
		.in_reg({{31{1'b0}}, c_status}),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.enable(c_stat_en),	//input
		.out_reg(c_stat_reg_out)	//output
	);	

/*---------------------Register Bank---------------------*/
	RISCV_registers register_bank(
		.WD3(WD3),		//input
		.WD3_en(WD3_en),	//input
		.clk(clk),		//input
		.rst(rst),		//input
		.A1_addr(A1_addr),	//input
		.A2_addr(A2_addr),	//input
		.A3_addr(A3_addr),	//input
		.RD1(RD1),		//output
		.RD2(RD2)		//output
	);


/*------------------------------------------------------------------------------------------*/
/*					Multiplexers	 				    */
/*------------------------------------------------------------------------------------------*/

/*---------------------SrcB selector---------------------*/
	RISCV_mux32bit21 RD2_IMM_mux(
		.input_0(RD2_reg_out),	//input
		.input_1(IMM),	//input
		.select(srcB_sel),	//input
		.output_mux(SrcB)	//output
	);

/*-------------------Register bank input selector-------------------*/
	RISCV_mux32bit41 mux41(
		.input_0(data_reg_out),	//input
		.input_1(ALU_reg_out),	//input
		.input_2(PC_out),	//input
		.input_3(32'hXXXX),	//input
		.select(data_sel),	//input
		.output_mux(WD3)	//output
	);


/*---------------------Address Selector---------------------*/
	RISCV_mux32bit21 Address_Select(
		.input_0(ALU_reg_out),	//input
		.input_1(PC_out),	//input
		.select(Addr_sel),	//input
		.output_mux(address)	//output
	);	

assign data_out = RD2_reg_out;
assign curr_instr = IR_out;

endmodule













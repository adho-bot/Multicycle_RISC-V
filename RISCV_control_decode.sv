`include "RISCV_definitions.sv" 

module RISCV_control_decode(
    input  logic [3:0]  state,
    input  logic [31:0]       c_status,
    input  logic [31:0] ir,

    // PC control
    output logic         PC_en,
    output logic         add_sel,

    // Datapath controls
    output logic         IR_en,
    output logic  [6:0]  se_sel,
    output logic         data_reg_en,
    output logic  [1:0]  data_sel,

    // Register control
    output logic         WD3_en,
    output logic  [4:0]  A1_addr,
    output logic  [4:0]  A2_addr,
    output logic  [4:0]  A3_addr,
    output logic         c_stat_en,

    // ALU control
    output logic  [9:0]  ALU_op,
    output logic         srcB_sel,
    output logic         ALU_reg_en,
    output logic         Addr_sel,

    // Memory control
    output logic         mem_rd,
    output logic         mem_wr
);

	always_comb begin
	// Default control signal values
	    // PC control
	    PC_en        = 1'b0;
	    add_sel      = 1'b0;

	    // Datapath controls
	    IR_en        = 1'b0;
	    se_sel       = 7'bXXXXXXX;
	    data_reg_en  = 1'b0;
	    data_sel 	 = 2'bXX;

	    // Register control
	    WD3_en       = 1'b0;
	    A1_addr      = ir[19:15]; //make it hold the values needed and not reset it to a certain value.
	    A2_addr      = ir[24:20];
	    A3_addr      = 5'h00;
	    c_stat_en    = 1'b0;
	    
	    // ALU control
	    ALU_op       = 3'bXXX;
	    srcB_sel     = 1'bX;
	    ALU_reg_en   = 1'b0;
	    Addr_sel     = 1'bX;

	    // Memory control
	    mem_rd      = 1'b0;
	    mem_wr      = 1'b0;

	   
	    case(state)
		`FETCH: begin
		    	mem_rd   = 1'b1;
		    	Addr_sel  = 1'b1;
		    	add_sel   = 1'b0;
		    	PC_en     = 1'b1;
		    	IR_en     = 1'b1;
		end

		`DECODE: begin
			se_sel 	= ir[6:0];
			//A1_addr = ir[19:15];
			//A2_addr = ir[24:20];
			data_sel = 2'b00;
		end

		`EXECUTE_R: begin
			srcB_sel = 1'b0;
			ALU_op = {ir[31:25],ir[14:12]};
			ALU_reg_en = 1'b1;
		end

		`EXECUTE_I: begin
			se_sel 	= ir[6:0];
			srcB_sel = 1'b1;
			ALU_op = {7'b0000000,ir[14:12]};
			ALU_reg_en = 1'b1;
		end

		`EXECUTE_B: begin
			srcB_sel = 1'b0;
			ALU_op   = {7'b1111111,ir[14:12]};
			ALU_reg_en  = 1'b1;
			add_sel  = 1'b1;
			c_stat_en = 32'd1;
					
		end

		`JAL: begin
			se_sel 	= ir[6:0];
			add_sel = 1'b1;
		end

		`MEM_ADR: begin
			se_sel = ir[6:0];
			srcB_sel = 1'b1;
			ALU_op = {7'b0000000,3'b000};
			ALU_reg_en = 1'b1;// might need to set this as zero as value is passed in mem state
		end

		`MEM_READ: begin
			Addr_sel = 1'b0;
			mem_rd = 1'b1;
			data_reg_en = 1'b1;
			data_sel = 2'b00;
		end

		`MEM_WRITE: begin
			Addr_sel = 1'b0;
			mem_wr = 1'b1;
		end

		`MEM_WRITEBACK: begin
			data_sel = 2'b00;
			A3_addr = ir[11:7];
			WD3_en = 1'b1;
		end

		`ALU_WRITEBACK: begin
		    	data_sel = 2'b01;     // current PC : ALU output 
		    	A3_addr = ir[11:7];
		    	WD3_en = 1'b1;
		end
		
		`PC_WRITEBACK: begin
			se_sel = ir[6:0];
			add_sel = 1'b1;
			PC_en = (c_status) ? 32'd1 : 32'd0;	
		end
		
		`J_WRITEBACK: begin
			data_sel = 2'b10;
			A3_addr = ir[11:7];
		    	WD3_en = 1'b1;
			se_sel = ir[6:0];
			add_sel = 1'b1;
			PC_en = 1'b1; 
		end
	    endcase
	end
endmodule





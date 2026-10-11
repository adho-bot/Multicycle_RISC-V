//page 436
//Verified
`include "RISCV_definitions.sv" 


module RISCV_FSM (input  logic	     	clk,	    // System clock
                  input  logic	     	rst,	    // Master reset
                  input  logic  [31:0] 	ir,         // Instruction Register
                  //(*KEEP = "true"*)                 //Attribute to keep the signal intact when debugging   
                  output logic  [ 3:0] 	state);	    // Current state of the FSM

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -*/
/* FSM                                                                        */

logic [3:0] next_state;

/*------------------------------------------------------------------------------------------*/
/*					Register Logic 					    */
/*------------------------------------------------------------------------------------------*/
always_ff @ (posedge clk, posedge rst) begin
	if(rst)
		state <= `FETCH;
	else
		state <= next_state;
end

/*------------------------------------------------------------------------------------------*/
/*					Next state Logic				    */
/*------------------------------------------------------------------------------------------*/
always_comb begin
	case(state)
	`FETCH: next_state = `DECODE;
	`DECODE: begin
		case(ir[6:0])
			`OPCODE_LOAD:   next_state = `MEM_ADR;
			`OPCODE_STORE:  next_state = `MEM_ADR;
			`OPCODE_R_TYPE: next_state = `EXECUTE_R;
			`OPCODE_I_TYPE: next_state = `EXECUTE_I;
			`OPCODE_JAL:    next_state = `JAL;
			`OPCODE_BRANCH: next_state = `EXECUTE_B;
			default:        next_state = `FETCH;
		endcase
	end
	`EXECUTE_R: next_state = `ALU_WRITEBACK;
	`EXECUTE_I: next_state = `ALU_WRITEBACK;
	`EXECUTE_B: next_state = `PC_WRITEBACK;
	`JAL: 	    next_state = `J_WRITEBACK;
	`MEM_ADR:   next_state = (ir[5]) ? `MEM_WRITE : `MEM_READ;	// 0 for load | 1 for store
	
	`MEM_WRITE: next_state = `FETCH;
	`MEM_READ: next_state = `MEM_WRITEBACK;
	
	`J_WRITEBACK: next_state = `FETCH;
	`ALU_WRITEBACK: next_state = `FETCH;
	`MEM_WRITEBACK: next_state = `FETCH;
	`PC_WRITEBACK:   next_state = `FETCH;
	
	default: next_state = 4'hX;					// Testing 
	endcase
	
end
endmodule



`timescale 1ns / 100ps
`define CLOCK_PERIOD 10
`include "RISCV_definitions.sv"

module RISCV_FSM_Testbench; //Used to test FSM + control decode implementation


//---------FSM--------
    logic         clk;
    logic         rst;
    logic [31:0]  ir;
    logic [3:0]   state;

    RISCV_FSM uut (
        .clk(clk),
        .rst(rst),
        .ir(ir),
        .state(state)
    );


    // Clock generation
    initial clk = 0;
    always #(`CLOCK_PERIOD / 2) clk = ~clk;

    //State Change Block
    initial begin
    #(`CLOCK_PERIOD * 2);    
    ir = {25'd0, `OPCODE_LOAD}; 	// Load opcode
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


    // Assert block block
    initial begin
        rst = 1;
        #(`CLOCK_PERIOD * 2);
        rst = 0;



/*------------------------------------------------------------------------------------------*/
/*                                   Load	                                            */
/*------------------------------------------------------------------------------------------*/
        #(`CLOCK_PERIOD + `CLOCK_PERIOD / 4);						//0
        assert(state == `DECODE) else $fatal("LOAD DECODE ERROR");       		//1
        #`CLOCK_PERIOD
        assert(state == `MEM_ADR) else $fatal("LOAD MEM_ADR ERROR");     		//6
        #`CLOCK_PERIOD
        assert(state == `MEM_READ) else $fatal("LOAD MEM_READ ERROR");   		//7
        #`CLOCK_PERIOD
        assert(state == `MEM_WRITEBACK) else $fatal("LOAD MEM_WRITEBACK ERROR");	//9

/*------------------------------------------------------------------------------------------*/
/*                                   Store	                                            */
/*------------------------------------------------------------------------------------------*/
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("STORE FETCH ERROR");			//1        
        #`CLOCK_PERIOD
        assert(state == `DECODE) else $fatal("STORE DECODE ERROR");			//1
        #`CLOCK_PERIOD
        assert(state == `MEM_ADR) else $fatal("STORE MEM_ADR ERROR");			//6
        #`CLOCK_PERIOD
        assert(state == `MEM_WRITE) else $fatal("STORE MEM_WRITE ERROR");		//8

/*------------------------------------------------------------------------------------------*/
/*                                  R type	                                            */
/*------------------------------------------------------------------------------------------*/
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("R FETCH ERROR");				//1          
        #`CLOCK_PERIOD
        assert(state == `DECODE) else $fatal("R-TYPE DECODE ERROR");			//1
        #`CLOCK_PERIOD
        assert(state == `EXECUTE_R) else $fatal("R-TYPE EXECUTE_R ERROR");		//2
        #`CLOCK_PERIOD
        assert(state == `ALU_WRITEBACK) else $fatal("R-TYPE ALU_WRITEBACK ERROR");	//10

/*------------------------------------------------------------------------------------------*/
/*                                   I type	                                            */
/*------------------------------------------------------------------------------------------*/
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("I FETCH ERROR");				//1          
        #`CLOCK_PERIOD
        assert(state == `DECODE) else $fatal("I-TYPE DECODE ERROR");			//1
        #`CLOCK_PERIOD
        assert(state == `EXECUTE_I) else $fatal("I-TYPE EXECUTE_I ERROR");		//3
        #`CLOCK_PERIOD
        assert(state == `ALU_WRITEBACK) else $fatal("I-TYPE ALU_WRITEBACK ERROR");	//10

/*------------------------------------------------------------------------------------------*/
/*                                   JAL	                                            */
/*------------------------------------------------------------------------------------------*/
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("JAL FETCH ERROR");				//1          
        #`CLOCK_PERIOD
        assert(state == `DECODE) else $fatal("JAL DECODE ERROR");			//1
        #`CLOCK_PERIOD
        assert(state == `JAL) else $fatal("JAL EXECUTION ERROR");			//5
        #`CLOCK_PERIOD
        assert(state == `ALU_WRITEBACK) else $fatal("JAL ALU_WRITEBACK ERROR");		//10

/*------------------------------------------------------------------------------------------*/
/*                                   B type	                                            */
/*------------------------------------------------------------------------------------------*/
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("B FETCH ERROR");				//1          
        #`CLOCK_PERIOD
        assert(state == `DECODE) else $fatal("BRANCH DECODE ERROR");			//1
        #`CLOCK_PERIOD
        assert(state == `EXECUTE_B) else $fatal("BRANCH EXECUTE_B ERROR");		//4
        #`CLOCK_PERIOD
        assert(state == `PC_WRITEBACK) else $fatal("BRANCH PC_WRITEBACK ERROR");	//11

/*------------------------------------------------------------------------------------------*/
/*                                   Reset test	                                            */
/*------------------------------------------------------------------------------------------*/
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("LOAD FETCH ERROR");			//1          
        #`CLOCK_PERIOD
        assert(state == `FETCH) else $fatal("Reset ERROR");				//1
	#(`CLOCK_PERIOD * 2);								//0
	
        $display("All instruction FSM state sequences passed!");
        $stop;
    end

endmodule


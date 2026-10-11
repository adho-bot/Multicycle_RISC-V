

`timescale  1ns / 100ps
`define CLOCK_PERIOD  10

module RISCV_testbench;

    // Clock and reset
    logic clk;
    logic rst;
    
    // Processor interface
    logic [31:0] data_in;
   // logic [31:0] data_from_mem;
   // logic [31:0] data_to_mem;
    logic [31:0] address;
    logic [31:0] data_out;
    logic mem_rd;
    logic mem_wr;
    
    // DUT instantiation
    RISCV uut (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .address(address),
        .data_out(data_out),
        .mem_rd(mem_rd),
        .mem_wr(mem_wr)
    );
    
    RISCV_memory memory(.clk(clk),
                        .cs(1'b1),
                        .rd(mem_rd),
                        .wr(mem_wr),
                        .address(address),
                        .wr_data(data_out),
                        .rd_data(data_in));
    
    // Clock generation
    initial clk = 0;
    always #(`CLOCK_PERIOD/2) clk = !clk;
/*    
    // Memory interface
    always @(negedge clk) begin
        if (mem_rd && !mem_wr) begin
            // Read operation
            data_in <= data_from_mem; // Word-aligned addressing
            $display("Time %0t: Memory READ from address 0x%h, data = 0x%h", 
                     $time, address, data_from_mem);
        end
        else if (mem_wr && !mem_rd) begin
            // Write operation
            data_to_mem <= data_out;
            $display("Time %0t: Memory WRITE to address 0x%h, data = 0x%h", 
                     $time, address, data_out);
        end
        else if (!mem_rd && !mem_wr) begin
            // No memory operation
            data_in <= data_in;
        end
    end
*/    
    // Load instructions into memory
    initial begin
        rst = 1;
       //load_instructions();
        
        // Reset sequence
        #(`CLOCK_PERIOD*5);
        rst = 0;
        
        // Run simulation
        #(`CLOCK_PERIOD*150);
        $stop;
    end
endmodule

/*list of issues encountered so far
- Writing the wrong se_sel signal for the sign extender
- Posedge memory fetch leads to new instructions delayed, hence not being able to nexecute them
- Forgot to enable data reg en for load state
- Incorrect bus size when instantiating
- Forgot to inclue ir[6:0] for sign extension operation for load/store
- Completly forgot the case of lw in sign extension
- Wrong Addr_sel for the read case
- For memory load, when read occurs to fetch instruction specified by address, this overwrites the current executing instruction, leading to wrong writeback address being selected(A3_addr)
	- Solution: added output curr_instr(basically extended a wire between IR and sign_extend to store current instruction) like what they did in stump
- Forgot to assign value to data_sel, leading to nothing being written back to register bank.
- Values A1/A2_addr values would reset before reaching the memory state for the store instruction.
- Jal needs to go to state "PC_writeback" instead of "ALU_writreback"
- se_sel needs to be held at ir[6:0] instead of letting it reset after one state
- c_status flag needs to be held high for an extra cycle for branch hits. fixed by removing deault of 0 in ALU and assign c_status value individually for each operation
- JAL was jumping but not writing back to register file. Added a new state for it to + PC offset and also writeback to the ALU
*/




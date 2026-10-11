
//n77335ci@e-c10kilf9019:~/bin$ rva -v code.hex [400] -lk code.list code.s 
//used to assemble code

module RISCV (
    input logic clk,                   
    input logic rst,                 
    input logic [31:0] data_in,        
    output logic [31:0] address,      
    output logic [31:0] data_out,      
    output logic mem_rd,              
    output logic mem_wr               
);

    /*---------------Internal wires----------------------*/
    logic 	PC_en;           
    logic 	add_sel;         
    logic 	IR_en;           
    logic [6:0] se_sel;    
    logic 	data_reg_en;     
    logic [1:0] data_sel;  
    logic 	WD3_en;          
    logic [4:0] A1_addr;   
    logic [4:0] A2_addr;   
    logic [4:0] A3_addr;   
    logic [9:0] ALU_op;    
    logic 	srcB_sel;        
    logic 	ALU_reg_en;      
    logic 	Addr_sel;        
    logic [31:0] 	c_status;
    logic    c_stat_en;    
    logic[31:0]	curr_instr;        

    // Instantiate datapath
    RISCV_datapath datapath (
        .rst(rst),                 // input
        .clk(clk),                 // input
        .PC_en(PC_en),             // input
        .add_sel(add_sel),         // input
        .IR_en(IR_en),             // input
        .se_sel(se_sel),           // input
        .data_reg_en(data_reg_en), // input
        .data_sel(data_sel),       // input
        .WD3_en(WD3_en),           // input
        .A1_addr(A1_addr),         // input
        .A2_addr(A2_addr),         // input
        .A3_addr(A3_addr),         // input
        .ALU_op(ALU_op),           // input
        .srcB_sel(srcB_sel),       // input
        .ALU_reg_en(ALU_reg_en),   // input
        .Addr_sel(Addr_sel),       // input
        .data_in(data_in),         // input 
        .c_stat_reg_out(c_status), // output 
        .c_stat_en(c_stat_en),     //input
        .data_out(data_out),       // output 
        .address(address)      ,   // output
        .curr_instr(curr_instr)	   //output
    );

    // Instantiate control
    RISCV_control control (
        .rst(rst),               // input
        .clk(clk),               // input
        .c_status(c_status),     // input 
        .ir(curr_instr),         // instruction input 
        .PC_en(PC_en),           // output 
        .add_sel(add_sel),       // output 
        .IR_en(IR_en),           // output
        .se_sel(se_sel),         // output 
        .data_reg_en(data_reg_en), // output 
        .data_sel(data_sel),     // output
        .WD3_en(WD3_en),         // output
        .A1_addr(A1_addr),       // output 
        .A2_addr(A2_addr),       // output
        .A3_addr(A3_addr),       // output 
        .ALU_op(ALU_op),         // output 
        .srcB_sel(srcB_sel),     // output 
        .ALU_reg_en(ALU_reg_en), // output 
        .Addr_sel(Addr_sel),     // output
        .mem_rd(mem_rd),         // output
        .mem_wr(mem_wr)     ,     // output
        .c_stat_en(c_stat_en) 
    );

endmodule


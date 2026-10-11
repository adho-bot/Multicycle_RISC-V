/*------------------------------------------------------------------------------------------*/
/*                                ALU Operation States                                      */
/*------------------------------------------------------------------------------------------*/
//Normal ALU
`define ADD		10'b0000000_000 // Addition
`define SUB     	10'b0100000_000 // Subtraction
`define SLL    	  	10'b0000000_001 // Shift left logical
`define XORR     	10'b0000000_100 // Xor
`define SRL     	10'b0000000_101 // Shift right logical
`define SRA     	10'b0100000_101 // Shift right arithmetic
`define ORR     	10'b0000000_110 // Or
`define ANDD    	10'b0000000_111 // And
    
    
//Branch
`define BEQ     	10'b1111111_000  //sketchy way of doing this. Qno funct7 for B instructions. I just made it 7 1s
`define BNE     	10'b1111111_001
`define BLT     	10'b1111111_100
`define BGE     	10'b1111111_101

/*------------------------------------------------------------------------------------------*/
/*                                   FSM States                                             */
/*------------------------------------------------------------------------------------------*/
`define FETCH            4'b0000   // Fetch instruction from memory

`define DECODE           4'b0001

`define EXECUTE_R        4'b0010   // Execute R-type instructions
`define EXECUTE_I        4'b0011   // Execute I-type instructions
`define EXECUTE_B        4'b0100   // Execute B-type instructions
`define JAL              4'b0101   // Execute JAL instruction
`define MEM_ADR          4'b0110   // Calculate memory address for load/store

`define MEM_READ         4'b0111   // Read data from memory
`define MEM_WRITE        4'b1000   // Write data to memory
`define MEM_WRITEBACK    4'b1001   // Write loaded data back to register file

`define ALU_WRITEBACK    4'b1010   // Write ALU result back to register file
`define PC_WRITEBACK	 4'b1011   // Write PC offest result to the PC
`define J_WRITEBACK	 4'b1100   //write offset back to pc and alu result to register file
/*------------------------------------------------------------------------------------------*/
/*                                RISC-V Instruction Opcodes                                */
/*------------------------------------------------------------------------------------------*/
`define OPCODE_LOAD     7'b0000011          // Load instructions 
`define OPCODE_STORE    7'b0100011          // Store instructions 
`define OPCODE_R_TYPE   7'b0110011          // R-type instructions 
`define OPCODE_I_TYPE   7'b0010011          // I-type instructions 
`define OPCODE_JAL      7'b1101111          // JAL instruction
`define OPCODE_JALR     7'b1100111          // JALR instruction
`define OPCODE_BRANCH   7'b1100011          // Branch instructions 
`define OPCODE_LUI      7'b0110111          // LUI instruction 
`define OPCODE_AUIPC    7'b0010111          // AUIPC instruction









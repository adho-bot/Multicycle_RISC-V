/*
Complete RISC-V Sign Extender
I type  -> extend IR[31:20]                           		3'b000
S type  -> extend IR[31:25] && IR[11:7]               		3'b001 <-  
U type  -> extend IR[31:12] (LUI, AUIPC)             		3'b010
B type  -> extend IR[31], IR[7], IR[30:25], IR[11:8] 		3'b011
J type  -> extend IR[31], IR[19:12], IR[20], IR[30:21] (JAL) 	3'b100
*/
module RISCV_sign_extender (
    input logic  [6:0]  se_sel,    //  based on opcode
    input logic  [31:0] in_sign_ext,
    output logic [31:0] IMM
);

always_comb begin
    case(se_sel) 
        7'b0010011:  IMM = {{20{in_sign_ext[31]}}, in_sign_ext[31:20]};  // I
        7'b0000011:  IMM = {{20{in_sign_ext[31]}}, in_sign_ext[31:20]};  // lw
        7'b0100011:  IMM = {{20{in_sign_ext[31]}}, in_sign_ext[31:25], in_sign_ext[11:7]};  // S
        7'b0110111:  IMM = {in_sign_ext[31:12], 12'b0};  // U
        7'b1100011:  IMM = {{18{in_sign_ext[31]}}, in_sign_ext[31], in_sign_ext[7], in_sign_ext[30:25], in_sign_ext[11:8], 1'b0};  // B
        7'b1101111:  IMM = {{11{in_sign_ext[31]}}, in_sign_ext[19:12], in_sign_ext[20], in_sign_ext[30:21], 1'b0};  // J
        default: IMM = 32'b0; 
    endcase
end

endmodule

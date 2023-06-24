`include "defines.v"

module alu (
    input[1:0] alu_ctl,
    input [31:0] A, B,
    output zero, overflow, positive,
    output [31:0] C
);

    assign C = (alu_ctl == `ALU_OP_ADD) ? A + B :
               (alu_ctl == `ALU_OP_SUB) ? A - B :
               (alu_ctl == `ALU_OP_OR) ? A | B :
               (alu_ctl == `ALU_OP_LUI) ? {B[15:0], 16'b0} : 32'b0;

    assign zero = (C == 32'b0);
    assign positive = (C[31] == 1'b0) && !zero;
    assign overflow = (alu_ctl == `ALU_OP_ADD) ? (A[31] == B[31] && C[31] != A[31]) : 1'b0;     

endmodule
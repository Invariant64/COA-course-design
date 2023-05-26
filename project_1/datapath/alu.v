module alu (
    input[1:0] alu_ctl,
    input [31:0] A, B,
    output zero,
    output [31:0] C
);

    // alu_ctl : 2'b00 = addu, 2'b01 = subu, 2'b10 = ori, 2'b11 = lui
    assign C = (alu_ctl == 2'b00) ? A + B :
               (alu_ctl == 2'b01) ? A - B :
               (alu_ctl == 2'b10) ? A | B :
               (alu_ctl == 2'b11) ? {B[15:0], 16'b0} : 32'b0;
    assign zero = (C == 32'b0);

endmodule
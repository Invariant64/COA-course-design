module alu (
    input[1:0] alu_ctl,
    input [31:0] A, B,
    output zero,
    output [31:0] C
);

    assign C = (alu_ctl == 2'b00) ? A + B :
               (alu_ctl == 2'b01) ? A - B :
               (alu_ctl == 2'b10) ? A | B : 32'b0;
    assign zero = (C == 32'b0);

endmodule
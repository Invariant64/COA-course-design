`include "defines.v"

module ext (
    input ext_op,
    input [15:0] data_in,
    output [31:0] data_out
);
    // ext_op : 1'b0 = zero extend, 1'b1 = sign extend
    assign data_out = (ext_op == `EXT_ZERO) ? {{16{1'b0}}, data_in} : {{16{data_in[15]}}, data_in};
                      
endmodule
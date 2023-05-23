module ext (
    input [1:0] ext_op,
    input [15:0] data_in,
    output [31:0] data_out
);

    assign data_out = (ext_op == 2'b00) ? {{16{1'b0}}, data_in} :
                      (ext_op == 2'b01) ? {{16{data_in[15]}}, data_in} :
                      (ext_op == 2'b10) ? {data_in, {16{1'b0}}} : 32'b0;
                      
endmodule
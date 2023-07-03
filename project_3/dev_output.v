module dev_output (
    input [31:0] data_in,

    input clk, reset,
    input [3:2] add,
    input write_en,

    output reg [31:0] data_out
);

    initial begin
        data_out = 32'b0;
    end

    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            data_out = 32'b0;
        end
        else begin
            data_out = (add == 2'b00 && write_en) ? data_in : data_out;
        end
    end

endmodule
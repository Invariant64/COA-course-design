module gpr (
    input clk,
    input [4:0] read1, read2,
    input [4:0] write,
    input [31:0] write_data,
    input wd,
    output [31:0] data1, data2
);

    reg [31:0] rgs[31:0];

    assign data1 = rgs[read1];
    assign data2 = rgs[read2];

    always @ (posedge clk)
    begin
        if (wd) begin
            rgs[write] <= write_data;
        end
    end

endmodule
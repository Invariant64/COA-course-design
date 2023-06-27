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

    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
        begin
            rgs[i] = 32'h00000000;
        end
    end

    always @ (posedge clk)
    begin
        if (wd) begin
            if (write != 5'b0) 
                rgs[write] <= write_data;
        end
    end

endmodule
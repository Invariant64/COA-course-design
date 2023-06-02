module dm_1k (
    input [9:0] addr,
    input [31:0] din,
    input we,
    input clk,
    output [31:0] dout
);

    reg [7:0] dm[1023:0];

    assign dout = { dm[addr + 3], dm[addr + 2], dm[addr + 1], dm[addr] };

    always @ (posedge clk) 
    begin
        if (we) begin
            { dm[addr + 3], dm[addr + 2], dm[addr + 1], dm[addr] } <= din;
        end
    end
    
endmodule
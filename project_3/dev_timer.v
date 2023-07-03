module dev_timer (
    input clk, reset,
    input [3:2] add,
    input write_en,
    input [31:0] data_in,

    output int_request,
    output [31:0] data_out
);

    reg [31:0] count, preset, ctrl;

    wire [1:0] mode;
    wire enable, im;

    initial begin
        count = 32'b0;
        preset = 32'b0;
        ctrl = 32'b0;
    end

    assign im = ctrl[3];
    assign mode = ctrl[2:1];
    assign count_enable = ctrl[0];

    assign int_request = (mode == 2'b00) && (im == 1'b1) && (count == 32'b0);

    assign data_out = (add == 2'b00) ? ctrl : 
                      (add == 2'b01) ? preset :
                      (add == 2'b10) ? count : 32'b0;

    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            count = 32'b0;
            preset = 32'b0;
            ctrl = 32'b0;
        end
        else begin
            if (write_en) begin
                if (add == 2'b00) ctrl = {28'b0, data_in[3:0]};
                if (add == 2'b01) begin
                    preset = data_in;
                    count = preset;
                end
            end
            else if (count_enable) begin
                if (count > 0) count = count - 1;
                else if (count == 0) begin
                    if (mode == 2'b01) count = preset;
                end
            end
        end
    end

endmodule




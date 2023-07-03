`include "mips.v"
`include "bridge.v"
`include "dev_timer.v"
`include "dev_input.v"
`include "dev_output.v"

module system (
    input clk, reset,

    input [31:0] data_input,
    output [31:0] data_output
);

    wire [31:0] timer_data_in, timer_data_out;
    wire [31:0] input_data_out;
    wire [31:0] output_data_in;

    wire w_timer_int_request;
    wire w_dev_write_en0, w_dev_write_en1, w_dev_write_en2;

    wire [31:0] w_dev_write_data;
    wire [31:0] w_pr_addr;
    wire [3:2] w_dev_addr;

    wire [31:0] w_pr_write_data;
    wire w_pr_write_en;
    wire [5:0] w_hw_int;
    wire [31:0] w_pr_read_data;

    dev_timer dev_timer_1 (
        .clk(clk), .reset(reset),
        .add(w_dev_addr), .write_en(w_dev_write_en0),
        .data_in(w_dev_write_data),
        .int_request(w_timer_int_request),
        .data_out(timer_data_out)
    );

    dev_input dev_input_1 (
        .clk(clk), .reset(reset),
        .add(w_dev_addr), 
        .data_in(data_input),
        .data_out(input_data_out)
    );

    dev_output dev_output_1 (
        .clk(clk), .reset(reset),
        .add(w_dev_addr), .write_en(w_dev_write_en2),
        .data_in(w_dev_write_data),
        .data_out(data_output)
    );

    bridge bridge_1 (
        .pr_addr(w_pr_addr),
        .pr_write_data(w_pr_write_data),
        .dev_read_data0(timer_data_out),
        .dev_read_data1(input_data_out), 
        .dev_read_data2(),
        .int_request0(w_timer_int_request), 
        .int_request1(1'b0), 
        .int_request2(1'b0),
        .pr_write_en(w_pr_write_en),

        .pr_read_data(w_pr_read_data),
        .dev_addr(w_dev_addr),
        .dev_write_data(w_dev_write_data),

        .dev_write_en0(w_dev_write_en0), 
        .dev_write_en1(w_dev_write_en1),
        .dev_write_en2(w_dev_write_en2),

        .hw_int(w_hw_int)
    );

    mips mips_1 (
        .clk(clk), .rst(reset),
        .pr_data_in(w_pr_read_data),
        .hw_int(w_hw_int),
        .pr_write_en(w_pr_write_en),
        .pr_addr(w_pr_addr),
        .pr_data_out(w_pr_write_data)
    );

endmodule


    


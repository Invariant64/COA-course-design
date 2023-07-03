`include "defines.v"

module cp0 (
    input [31:2] pc,
    input [31:0] data_in,
    input [5:0] hw_int,
    input [4:0] reg_sel,
    input write_en,
    input exl_set,
    input exl_clr,
    input clk, reset,

    output [31:0] data_out,
    output int_request,
    output [31:2] epc
);

    // SR 
    reg [15:10] im; // allow which device to interrupt
    reg exl;        // exception level, means is now interrupting
    reg ie;         // interrupt enable

    // CAUSE
    reg [15:10] hw_int_pend; // pending interrupt

    // EPC
    reg [31:2] epc; // exception program counter

    // PRID
    reg [31:0] prid; // processor id

    // register read
    assign data_out = (reg_sel == `CP0_REG_SEL_SR) ? {16'b0, im, 8'b0, exl, ie} :
                      (reg_sel == `CP0_REG_SEL_CAUSE) ? {16'b0, hw_int_pend, 10'b0} :
                      (reg_sel == `CP0_REG_SEL_EPC) ? {epc, 2'b0} :
                      (reg_sel == `CP0_REG_SEL_PRID) ? prid : 32'b0;

    initial begin
        im = 6'b0;
        exl = 1'b0;
        ie = 1'b0;
        hw_int_pend = 6'b0;
        epc = 30'b0;
        prid = 'h21074118;
    end

    // register write
    always @ (posedge clk, posedge reset) begin
        if (reset) begin
            im = 6'b0;
            exl = 1'b0;
            ie = 1'b0;
            hw_int_pend = 6'b0;
            epc = 30'b0;
            prid = 32'b0;
        end
        else begin
            // SR
            if (write_en && (reg_sel == `CP0_REG_SEL_SR)) begin
                im = data_in[15:10];
                exl = data_in[1];
                ie = data_in[0];
            end
            if (exl_set) exl = 1'b1;
            if (exl_clr) exl = 1'b0;

            // CAUSE
            hw_int_pend = hw_int;

            // EPC
            if (write_en && int_request) begin
                epc = pc[31:2];
            end

            // PRID
            if (write_en && (reg_sel == `CP0_REG_SEL_PRID)) begin
                prid = data_in;
            end
        end
    end

    // interrupt request
    assign int_request = | (hw_int_pend & im) && ie && !exl;

endmodule
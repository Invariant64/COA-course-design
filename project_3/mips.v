`include "controller.v"
`include "datapath.v"

module mips (
    input clk, rst,

    input [31:0] pr_data_in,
    input [5:0] hw_int,
    output pr_write_en,
    output [31:0] pr_addr,
    output [31:0] pr_data_out
);

    wire [1:0] alu_ctl;
    wire ext_op;
    wire [2:0] reg_src;
    wire [2:0] npc_sel;
    wire mem_write;
    wire mem_op;
    wire reg_write;
    wire alu_src;
    wire [1:0] reg_dst;
    wire j_ctl;
    wire jr_ctl;
    wire overflow;
    wire positive;
    wire signed_less;
    wire zero;
    wire pc_write;
    wire rgs_ins_write;

    wire [5:0] opcode;
    wire [5:0] funct;
    wire [4:0] cp0_code;

    wire cp0_reg_write_en;
    wire exl_clr, exl_set;
    wire int_request;

    datapath datapath_1(
        .clk(clk),
        .rst(rst),
        .alu_ctl(alu_ctl),
        .ext_op(ext_op),
        .reg_src(reg_src),
        .npc_sel(npc_sel),
        .mem_write(mem_write),
        .mem_op(mem_op),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .opcode(opcode),
        .funct(funct),
        .cp0_code(cp0_code),
        .overflow(overflow),
        .positive(positive),
        .signed_less(signed_less),
        .zero(zero),
        .pc_write(pc_write),
        .rgs_ins_write(rgs_ins_write),

        .hw_int(hw_int),
        .cp0_reg_write_en(cp0_reg_write_en),
        .pr_data_in(pr_data_in),
        .exl_clr(exl_clr),
        .exl_set(exl_set),
        .pr_addr(pr_addr),
        .pr_data_out(pr_data_out),
        .int_request(int_request)
    );

    assign pr_write_en = mem_write;

    controller controller_1(
        .clk(clk),
        .reset(rst),
        .pc_write(pc_write),
        .rgs_ins_write(rgs_ins_write),
        .opcode(opcode),
        .funct(funct),
        .cp0_code(cp0_code),
        .alu_ctl(alu_ctl),
        .ext_op(ext_op),
        .reg_src(reg_src),
        .npc_sel(npc_sel),
        .mem_write(mem_write),
        .mem_op(mem_op),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .overflow(overflow),
        .positive(positive),
        .signed_less(signed_less),
        .zero(zero),

        .int_request(int_request),
        .exl_clr(exl_clr),
        .exl_set(exl_set),
        .cp0_reg_write_en(cp0_reg_write_en)
    );

endmodule
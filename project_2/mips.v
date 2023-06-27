`include "controller.v"
`include "datapath.v"

module mips (
    input clk,
    input rst
);

    wire [1:0] alu_ctl;
    wire ext_op;
    wire [2:0] reg_src;
    wire [1:0] npc_sel;
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
        .overflow(overflow),
        .positive(positive),
        .signed_less(signed_less),
        .zero(zero),
        .pc_write(pc_write),
        .rgs_ins_write(rgs_ins_write)
    );

    controller controller_1(
        .clk(clk),
        .reset(rst),
        .pc_write(pc_write),
        .rgs_ins_write(rgs_ins_write),
        .opcode(opcode),
        .funct(funct),
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
        .zero(zero)
    );

endmodule
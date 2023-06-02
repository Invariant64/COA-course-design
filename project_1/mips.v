`include "controller.v"
`include "datapath.v"

module mips (
    input clk,
    input rst
);

    wire [1:0] alu_ctl;
    wire ext_op;
    wire [1:0] reg_src;
    wire npc_sel;
    wire mem_write;
    wire reg_write;
    wire alu_src;
    wire [1:0] reg_dst;
    wire j_ctl;
    wire jr_ctl;
    wire overflow;
    wire positive;

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
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .opcode(opcode),
        .funct(funct),
        .j_ctl(j_ctl),
        .overflow(overflow),
        .positive(positive),
        .jr_ctl(jr_ctl)
    );

    controller controller_1(
        .opcode(opcode),
        .funct(funct),
        .alu_ctl(alu_ctl),
        .ext_op(ext_op),
        .reg_src(reg_src),
        .npc_sel(npc_sel),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .j_ctl(j_ctl),
        .overflow(overflow),
        .positive(positive),
        .jr_ctl(jr_ctl)
    );

endmodule
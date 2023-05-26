module mips (
    input clk,
    input rst
);

    wire [1:0] alu_ctl;
    wire ext_op;
    wire mem_to_reg;
    wire npc_sel;
    wire mem_write;
    wire reg_write;
    wire alu_src;
    wire reg_dst;

    wire [5:0] opcode;
    wire [5:0] funct;

    datapath datapath_1(
        .clk(clk),
        .rst(rst),
        .alu_ctl(alu_ctl),
        .ext_op(ext_op),
        .mem_to_reg(mem_to_reg),
        .npc_sel(npc_sel),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst),
        .opcode(opcode),
        .funct(funct)
    );

    controller controller_1(
        .opcode(opcode),
        .funct(funct),
        .alu_ctl(alu_ctl),
        .ext_op(ext_op),
        .mem_to_reg(mem_to_reg),
        .npc_sel(npc_sel),
        .mem_write(mem_write),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .reg_dst(reg_dst)
    );

endmodule
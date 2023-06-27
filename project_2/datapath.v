`include "defines.v"
`include "alu.v"
`include "ext.v"
`include "gpr.v"
`include "dm.v"
`include "dm_helper.v"
`include "ifu.v"

module datapath (
    input clk,
    input rst,

    input [1:0] alu_ctl,
    input ext_op,
    input [2:0] reg_src,
    input [1:0] npc_sel,
    input mem_write,
    input mem_op,
    input reg_write,
    input alu_src,
    input [1:0] reg_dst,

    input rgs_ins_write, pc_write,
    
    output zero, overflow, positive, signed_less,
    output [5:0] opcode,
    output [5:0] funct
);

    reg [31:0] rgs_A, rgs_B;
    reg [31:0] rgs_alu;
    reg [31:0] rgs_data;

    wire w_zero;
    wire [4:0] w_reg_write_src;
    wire [31:0] w_ins, w_C, w_ext_data, w_reg_src, w_reg_data1, w_reg_data2, w_dm_data, w_alu_b_src, w_npc;
    wire [31:0] h_mem_in, h_mem_out, h_gpr_in, h_gpr_out;

    always @ (posedge clk, posedge rst) begin
        if (rst) begin
            rgs_A = 32'b0;
            rgs_B = 32'b0;
            rgs_alu = 32'b0;
            rgs_data = 32'b0;
        end 
        else begin
            rgs_A = w_reg_data1;
            rgs_B = w_reg_data2;
            rgs_alu = w_C;
            rgs_data = h_gpr_in;
        end
    end
    
    ifu ifu_1(
        .clk(clk),
        .reset(rst),
        .npc_sel(npc_sel), 
        .pc(w_npc),
        .rs_data(w_reg_data1),
        .pc_write(pc_write),
        .rgs_ins_write(rgs_ins_write),
        .rgs_ins(w_ins)
    );

    assign opcode = w_ins[31:26];
    assign funct = w_ins[5:0];

    alu alu_1(
        .alu_ctl(alu_ctl),
        .A(rgs_A),
        .B(w_alu_b_src),
        .zero(zero),
        .overflow(overflow),
        .positive(positive),
        .signed_less(signed_less),
        .C(w_C)
    );

    assign w_alu_b_src = (alu_src == `ALU_SRC_REG) ? rgs_B :
                         (alu_src == `ALU_SRC_EXT) ? w_ext_data : 32'b0;

    ext ext_1(
        .ext_op(ext_op),
        .data_in(w_ins[15:0]),
        .data_out(w_ext_data)
    );

    gpr gpr_1(
        .clk(clk),
        .read1(w_ins[25:21]),
        .read2(w_ins[20:16]),
        .write(w_reg_write_src),
        .write_data(w_reg_src),
        .wd(reg_write),
        .data1(w_reg_data1),
        .data2(w_reg_data2)
    );

    assign w_reg_write_src = (reg_dst == `REG_WRITE_ADDR_RD) ? w_ins[15:11] :
                             (reg_dst == `REG_WRITE_ADDR_RT) ? w_ins[20:16] :
                             (reg_dst == `REG_WRITE_ADDR_OVERFLOW) ? 5'b11110 :
                             (reg_dst == `REG_WRITE_ADDR_NPC) ? 5'b11111 : 5'b0;
    assign w_reg_src = (reg_src == `REG_WRITE_SRC_ALU) ? rgs_alu :
                       (reg_src == `REG_WRITE_SRC_MEM) ? rgs_data :
                       (reg_src == `REG_WRITE_SRC_ZERO) ? 32'b0 :
                       (reg_src == `REG_WRITE_SRC_ONE) ? 32'b1 :
                       (reg_src == `REG_WRITE_SRC_PC) ? w_npc : 32'b0;

    assign h_gpr_out = rgs_B;

    dm_1k dm_1(
        .addr(rgs_alu[9:0]),
        .din(h_mem_in),
        .we(mem_write),
        .clk(clk),
        .dout(h_mem_out)
    );

    dm_helper dm_helper_1(
        .mem_op(mem_op),
        .read_gpr_data(h_gpr_out),
        .read_mem_data(h_mem_out),
        .write_gpr_data(h_gpr_in),
        .write_mem_data(h_mem_in)
    );

endmodule

    
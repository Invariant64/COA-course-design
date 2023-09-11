`include "defines.v"
`include "alu.v"
`include "ext.v"
`include "gpr.v"
`include "dm.v"
`include "dm_helper.v"
`include "ifu.v"
`include "cp0.v"

module datapath (
    input clk,
    input rst,

    input [1:0] alu_ctl,
    input ext_op,
    input [2:0] reg_src,
    input [2:0] npc_sel,
    input mem_write,
    input mem_op,
    input reg_write,
    input alu_src,
    input [1:0] reg_dst,

    input rgs_ins_write, pc_write,

    output zero, overflow, positive, signed_less,
    output [5:0] opcode,
    output [5:0] funct,
    output [4:0] cp0_code,

    // device
    input [31:0] pr_data_in,
    output [31:0] pr_data_out,

    // CP0
    input [5:0] hw_int,
    input cp0_reg_write_en,
    input exl_clr, exl_set,
    output [31:0] pr_addr,
    output int_request
);

    reg [31:0] rgs_A, rgs_B;
    reg [31:0] rgs_alu;
    reg [31:0] rgs_data;

    wire w_zero;
    wire [4:0] w_reg_write_src;
    wire [31:0] w_ins, w_C, w_ext_data, w_reg_src, w_reg_data1, w_reg_data2, w_dm_data, w_alu_b_src, w_npc;
    wire [31:0] h_mem_in, h_mem_out, h_gpr_in, h_gpr_out;
    reg [31:0] w_sra_data;

    wire [31:2] w_epc;
    wire [31:0] w_cp0_data_out;

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

    //assign w_sra_data = {{(w_ins[10:6]){rgs_A[31]}}, rgs_A[31:(w_ins[10:6])]};
    integer i, j;
    always @ (posedge clk) begin
        j = w_ins[10:6];
        for (i = 0; i < 31 - j; i = i + 1) begin
            w_sra_data[i] = rgs_B[i + j];
        end
        for (i = 0; i < j; i = i + 1) begin
            w_sra_data[31 - i] = rgs_B[31];
        end
    end
    // assign w_sra_data = rgs_A >> w_ins[10:6];
    
    ifu ifu_1(
        .clk(clk),
        .reset(rst),
        .npc_sel(npc_sel), 
        .pc(w_npc),
        .rs_data(w_reg_data1),
        .pc_write(pc_write),
        .rgs_ins_write(rgs_ins_write),
        .rgs_ins(w_ins),
        .epc(w_epc)
    );

    assign opcode = w_ins[31:26];
    assign funct = w_ins[5:0];
    assign cp0_code = w_ins[25:21];

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
                       (reg_src == `REG_WRITE_SRC_MEM) ? ((rgs_alu < 'h3000) ? rgs_data : pr_data_in) :
                       (reg_src == `REG_WRITE_SRC_ZERO) ? 32'b0 :
                       (reg_src == `REG_WRITE_SRC_ONE) ? 32'b1 :
                       (reg_src == `REG_WRITE_SRC_PC) ? w_npc : 
                       (reg_src == `REG_WRITE_SRC_SRA) ? w_sra_data :
                       (reg_src == `REG_WRITE_SRC_CP0) ? w_cp0_data_out : 32'b0;

    assign h_gpr_out = rgs_B;

    dm_1k dm_1(
        .addr(rgs_alu[13:0]),
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

    assign pr_addr = rgs_alu;
    assign pr_data_out = rgs_B;

    cp0 cp0_1(
        .pc(w_npc[31:2]),
        .data_in(w_reg_data2),
        .hw_int(hw_int),
        .reg_sel(w_ins[15:11]),
        .write_en(cp0_reg_write_en),
        .exl_set(exl_set),
        .exl_clr(exl_clr),
        .clk(clk),
        .reset(rst),

        .data_out(w_cp0_data_out),
        .int_request(int_request),
        .epc(w_epc)
    );

endmodule

    
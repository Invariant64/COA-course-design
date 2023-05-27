module datapath (
    input clk,
    input rst,

    input [1:0] alu_ctl,
    input ext_op,
    input [1:0] reg_src,
    input npc_sel,
    input mem_write,
    input reg_write,
    input alu_src,
    input [1:0] reg_dst,
    input j_ctl,
    input jr_ctl,
    
    output overflow, positive,
    output [5:0] opcode,
    output [5:0] funct
);

    wire w_zero;
    wire [4:0] w_reg_write_src;
    wire [31:0] w_ins, w_C, w_ext_data, w_reg_src, w_reg_data1, w_reg_data2, w_dm_data, w_alu_b_src, w_npc;
    
    ifu ifu_1(
        .clk(clk),
        .reset(rst),
        .npc_sel(npc_sel),
        .zero(w_zero), 
        .insout(w_ins),
        .j_ctl(j_ctl),
        .jr_ctl(jr_ctl),
        .npc(w_npc),
        .rs_data(w_reg_data1)
    );

    assign opcode = w_ins[31:26];
    assign funct = w_ins[5:0];

    alu alu_1(
        .alu_ctl(alu_ctl),
        .A(w_reg_data1),
        .B(w_alu_b_src),
        .zero(w_zero),
        .overflow(overflow),
        .positive(positive),
        .C(w_C)
    );

    assign w_alu_b_src = (alu_src == 1'b0) ? w_reg_data2 : w_ext_data;

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

    assign w_reg_write_src = (reg_dst == 2'b00) ? w_ins[20:16] : 
                             (reg_dst == 2'b01) ? w_ins[15:11] :
                             (reg_dst == 2'b10) ? 5'b11110 : 5'b11111;
    assign w_reg_src = (reg_src == 2'b00) ? w_C : 
                       (reg_src == 2'b01) ? w_dm_data:
                       (reg_src == 2'b10) ? 32'b1 : w_npc;
    
    dm_1k dm_1(
        .addr(w_C[9:0]),
        .din(w_reg_data2),
        .we(mem_write),
        .clk(clk),
        .dout(w_dm_data)
    );

endmodule

    
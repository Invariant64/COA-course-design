module controller (
    input [5:0] opcode,
    input [5:0] funct,
    
    output [1:0] alu_ctl,
    output [1:0] ext_op,
    output [1:0] reg_src,
    output npc_sel,
    output mem_write,
    output reg_write,
    output alu_src,
    output reg_dst,
    output j_ctl
);

    wire r_type, addu, subu, ori, lw, sw, beq, lui, j;

    assign r_type = (opcode == 6'b000000);
    assign addu = r_type && (funct == 6'b100001);
    assign subu = r_type && (funct == 6'b100011);
    
    assign ori = (opcode == 6'b001101);
    assign beq = (opcode == 6'b000100);
    assign j = (opcode == 6'b000010);
    assign lw = (opcode == 6'b100011);
    assign sw = (opcode == 6'b101011);
    assign lui = (opcode == 6'b001111);



endmodule
module controller (
    input [5:0] opcode,
    input [5:0] funct,
    input overflow, positive,
    
    output [1:0] alu_ctl,
    output ext_op,
    output [1:0] reg_src,
    output npc_sel,
    output mem_write,
    output reg_write,
    output alu_src,
    output [1:0] reg_dst,
    output j_ctl
);

    wire overflow;

    wire r_type, addu, subu, ori, lw, sw, beq, lui, j;
    wire addi, addiu, slt, jal, jr;
    wire w_add, w_sub, w_or, w_lui; // alu_ctl
    wire w_overflow_ctl;

    assign r_type = (opcode == 6'b000000);
    assign addu = r_type && (funct == 6'b100001);
    assign subu = r_type && (funct == 6'b100011);
    assign slt = r_type && (funct == 6'b101010);
    
    assign ori = (opcode == 6'b001101);
    assign beq = (opcode == 6'b000100);
    assign j = (opcode == 6'b000010);
    assign lw = (opcode == 6'b100011);
    assign sw = (opcode == 6'b101011);
    assign lui = (opcode == 6'b001111);

    assign addi = (opcode == 6'b001000);
    assign addiu = (opcode == 6'b001001);
    assign jal = (opcode == 6'b000011);
    assign jr = (opcode == 6'b001000);

    // alu_ctl : 2'b00 = addu, 2'b01 = subu, 2'b10 = or, 2'b11 = lui
    assign w_add = addu || lw || sw || addi || addiu;
    assign w_sub = subu || beq || slt;
    assign w_or = ori;
    assign w_lui = lui;
    assign alu_ctl[0] = w_sub || w_lui;
    assign alu_ctl[1] = w_or || w_lui;

    assign ext_op = lw || sw || addi || addiu;

    assign reg_src[0] = lw || slt && positive;
    assign reg_src[1] = overflow && w_overflow_ctl || slt;

    assign npc_sel = beq || j;

    assign mem_write = sw;

    assign reg_write = addu || subu || ori || lui || lw || addi || addiu || slt;

    assign alu_src = ori || lui || lw || sw || addi || addiu;

    assign reg_dst[0] = addu || subu || slt; // 0 = rt, 1 = rd
    assign reg_dst[1] = overflow && w_overflow_ctl;

    assign j_ctl = j;

    assign w_overflow_ctl = addi;

endmodule
module controller (
    input [5:0] opcode,
    input [5:0] funct,
    
    output [1:0] alu_ctl,
    output ext_op,
    output mem_to_reg,
    output npc_sel,
    output mem_write,
    output reg_write,
    output alu_src,
    output reg_dst
);

    wire r_type, addu, subu, ori, lw, sw, beq, lui, j;
    wire w_addu, w_subu, w_or, w_lui; // alu_ctl

    assign r_type = (opcode == 6'b000000);
    assign addu = r_type && (funct == 6'b100001);
    assign subu = r_type && (funct == 6'b100011);
    
    assign ori = (opcode == 6'b001101);
    assign beq = (opcode == 6'b000100);
    assign j = (opcode == 6'b000010);
    assign lw = (opcode == 6'b100011);
    assign sw = (opcode == 6'b101011);
    assign lui = (opcode == 6'b001111);

    // alu_ctl : 2'b00 = addu, 2'b01 = subu, 2'b10 = or, 2'b11 = lui
    assign w_addu = addu || lw || sw;
    assign w_subu = subu || beq;
    assign w_or = ori;
    assign w_lui = lui;
    assign alu_ctl[0] = w_subu || w_lui;
    assign alu_ctl[1] = w_or || w_lui;

    assign ext_op = lw || sw;

    assign mem_to_reg = lw;

    assign npc_sel = beq || j;

    assign mem_write = sw;

    assign reg_write = addu || subu || ori || lui || lw;

    assign alu_src = ori || lui || lw || sw;

    assign reg_dst = addu || subu; // 0 = rt, 1 = rd

endmodule
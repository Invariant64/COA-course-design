`include "defines.v"

module controller (
    input clk, reset,
    input [5:0] opcode,
    input [5:0] funct,
    input zero, overflow, positive, signed_less,
    
    output reg pc_write,
    output reg rgs_ins_write,
    output reg [1:0] alu_ctl,
    output reg ext_op,
    output reg [2:0] reg_src,
    output reg [1:0] npc_sel,
    output reg mem_write,
    output reg mem_op,
    output reg reg_write,
    output reg alu_src,
    output reg [1:0] reg_dst
);

    wire r_type, addu, subu, ori, lw, sw, beq, lui, j, addi, addiu, slt, jal, jr, lb, sb; // instruction

    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7, S8 = 8, S9 = 9;

    reg [3:0] state;
    
    // instruction decode
    assign r_type = (opcode == 6'b000000);
    assign addu = r_type && (funct == 6'b100001);
    assign subu = r_type && (funct == 6'b100011);
    assign slt = r_type && (funct == 6'b101010);
    assign jr = r_type && (funct == 6'b001000);
    assign ori = (opcode == 6'b001101);
    assign beq = (opcode == 6'b000100);
    assign j = (opcode == 6'b000010);
    assign lw = (opcode == 6'b100011);
    assign sw = (opcode == 6'b101011);
    assign lui = (opcode == 6'b001111);
    assign addi = (opcode == 6'b001000);
    assign addiu = (opcode == 6'b001001);
    assign jal = (opcode == 6'b000011);
    assign lb = (opcode == 6'b100000);
    assign sb = (opcode == 6'b101000);
    assign sra = r_type && (funct == 6'b000011);

    // control signals
    always @ (*) begin 
        case (state)
            S0 : begin // fetch
                pc_write = 1'b1;
                npc_sel = `NPC_SEL_NORMAL;
                rgs_ins_write = 1'b1;
                reg_write = 1'b0;
                mem_write = 1'b0;
            end
            S1 : begin // decode
                pc_write = 1'b0;
                rgs_ins_write = 1'b0;
                alu_ctl = (addu || lw || sw || addi || addiu || lb || sb) ? `ALU_OP_ADD : 
                          (subu || beq || slt) ? `ALU_OP_SUB : 
                          (ori) ? `ALU_OP_OR : 
                          (lui) ? `ALU_OP_LUI : 0;
                ext_op = (lw || sw || addi || addiu || lb || sb) ? `EXT_SIGN : `EXT_ZERO;
                alu_src = (lw || sw || ori || lui || addi || addiu || lb || sb) ? `ALU_SRC_EXT : `ALU_SRC_REG; 
                reg_src = (addu || subu || ori || lui || addiu) ? `REG_WRITE_SRC_ALU : 
                          (lw || lb) ? `REG_WRITE_SRC_MEM :
                          (jal) ? `REG_WRITE_SRC_PC : 
                          (sra) ? `REG_WRITE_SRC_SRA : 0;
                reg_dst = (addu || subu || slt || sra) ? `REG_WRITE_ADDR_RD :
                          (ori || lui || lw || addiu || lb) ? `REG_WRITE_ADDR_RT :
                          (jal) ? `REG_WRITE_ADDR_NPC : 0;
                npc_sel = (beq) ? `NPC_SEL_RELATIVE :
                          (jal || j) ? `NPC_SEL_NRELATIVE : 
                          (jr) ? `NPC_SEL_REG : `NPC_SEL_NORMAL;
                mem_op = (lw || sw) ? `MEM_OP_WORD : 
                         (lb || sb) ? `MEM_OP_BYTE : 0;
            end
            S2 : begin // memory access
            end
            S3 : begin // memory read
            end
            S4 :begin // memory write back
                reg_write = 1'b1;
            end
            S5 : begin // memory write
                mem_write = 1'b1;
            end
            S6 : begin // execute
            end
            S7 : begin // alu write back
                reg_write = 1'b1;
                if (addi) begin
                    if (overflow) begin
                        reg_dst = `REG_WRITE_ADDR_OVERFLOW;
                        reg_src = `REG_WRITE_SRC_ONE;
                    end
                    else begin
                        reg_dst = `REG_WRITE_ADDR_RT;
                        reg_src = `REG_WRITE_SRC_ALU;
                    end
                end
                if (slt) begin
                    if (signed_less) reg_src = `REG_WRITE_SRC_ONE;
                    else reg_src = `REG_WRITE_SRC_ZERO;
                end
                if (sra) reg_src = `REG_WRITE_SRC_SRA;
            end
            S8 : begin // branch
                pc_write = zero;
            end
            S9 : begin // jump
                pc_write = 1'b1;
                if (jal) reg_write = 1'b1;
            end    
        endcase
    end

    // state transition
    always @ (posedge clk, posedge reset) begin
        if (reset) state = S0;
        else begin
            case (state)
                S0 : begin // fetch
                    state = S1;
                end
                S1 : begin // decode
                    if (lw || sw || lb || sb) state = S2;
                    else if (addu || subu || ori || lui || addiu || addi || slt || sra) state = S6;
                    else if (beq) state = S8;
                    else if (jal || j || jr) state = S9;
                    else state = S0;
                end
                S2 : begin // memory access
                    if (lw || lb) state = S3;
                    else if (sw || sb) state = S5;
                end
                S3 : begin // memory read
                    state = S4;
                end
                S4 : begin // memory write back
                    state = S0;
                end
                S5 : begin // memory write
                    state = S0;
                end
                S6 : begin // execute
                    state = S7;
                end
                S7 : begin // alu write back
                    state = S0;
                end
                S8 : begin // branch
                    state = S0;
                end
                S9 : begin // jump
                    state = S0;
                end
            endcase
        end
    end

    // assign alu_ctl[0] = w_sub || w_lui;
    // assign alu_ctl[1] = w_or || w_lui; // 00 = addu, 01 = subu, 10 = or, 11 = lui
    // assign ext_op = lw || sw || addi || addiu;
    // assign reg_src[0] = lw || slt && !positive || w_overflow && w_overflow_ctl;
    // assign reg_src[1] = w_overflow && w_overflow_ctl || slt;
    // assign reg_src[2] = jal; // 000 = alu, 001 = mem, 010 = 0, 011 = 1, 100 = pc
    // assign npc_sel = beq || j || jal || jr;
    // assign mem_write = sw;
    // assign reg_write = addu || subu || ori || lui || lw || addi || addiu || slt || jal;
    // assign alu_src = ori || lui || lw || sw || addi || addiu;
    // assign reg_dst[0] = addu || subu || slt || jal; 
    // assign reg_dst[1] = w_overflow && w_overflow_ctl || jal; // 00 = rt, 01 = rd, 10 = 30, 11 = 31
    // assign j_ctl = j || jal;
    // assign jr_ctl = jr;


endmodule
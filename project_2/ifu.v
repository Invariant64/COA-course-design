`include "im.v"
`include "defines.v"

module ifu (
    input clk,
    input reset,
    input [1:0] npc_sel,
    input pc_write,
    input rgs_ins_write,
    
    input [31:0] rs_data,

    output reg [31:0] pc,
    output reg [31:0] rgs_ins
);

    wire [31:0] insout;
    wire [31:0] pcnew, relative_pc, nrelative_pc, normal_pc;
    wire [25:0] imm;

    assign imm = rgs_ins[25:0];

    im_1k i1(
        .addr(pc[9:0]),
        .dout(insout)
    );

    always @ (posedge clk, posedge reset)
    begin
        if (reset) begin 
            pc = 32'h0000_3000;
            rgs_ins = 32'h0000_0000;
        end
        else begin
            if (pc_write) pc = pcnew;
            if (rgs_ins_write) rgs_ins = insout;
        end
    end

    assign pcnew = (npc_sel == `NPC_SEL_NORMAL) ? normal_pc :
                   (npc_sel == `NPC_SEL_RELATIVE) ? relative_pc :
                   (npc_sel == `NPC_SEL_NRELATIVE) ? nrelative_pc :
                   (npc_sel == `NPC_SEL_REG) ? rs_data : 0;
    
    assign normal_pc = pc + 4;
    assign relative_pc = pc + {{14{imm[15]}}, imm[15:0], 2'b00};
    assign nrelative_pc = {pc[31:28], imm[25:0], 2'b00};

endmodule
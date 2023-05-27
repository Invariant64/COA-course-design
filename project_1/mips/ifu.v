module ifu (
    input clk,
    input reset,
    input npc_sel,
    input zero,
    input j_ctl,
    input jr_ctl,

    input [31:0] rs_data,

    output [31:0] npc,
    output [31:0] insout
);

    reg [31:0] pc;
    wire [31:0] pcnew, t2, t1;
    wire [15:0] imm;

    im_1k i1(
        .addr(pc[9:0]),
        .dout(insout)
    );

    always @ (posedge clk, posedge reset)
    begin
        if (reset) pc = 32'h0000_3000;
        else pc = pcnew;
    end

    assign pcnew = (npc_sel && jr_ctl) ? rs_data : 
                   (npc_sel && j_ctl) ? t2 : 
                   (npc_sel && zero) ? t1 : npc;
     
    assign imm = insout[15:0];
    assign npc = pc + 4;
    assign t1 = npc + {{14{imm[15]}}, imm, 2'b00};
    assign t2 = {pc[31:28], insout[25:0], 2'b00};

endmodule
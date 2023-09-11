module ifu_tb;
    reg clk;
    reg reset;
    reg npc_sel;
    reg zero;
    reg jctl;
    wire[31:0] pc;
    wire [31:0] insout;
    wire [15:0] imm;

    ifu ifu1(clk, reset, npc_sel, zero, jctl, insout);
    assign pc = ifu1.pc;
    assign imm = ifu1.imm;

    initial begin
        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, ifu_tb);    //tb模块名称

        clk = 0;
        reset = 0;
        npc_sel = 0;
        zero = 0;
        jctl = 0;

        #1 reset = 1;
        #1 reset = 0;
        $readmemh("../code1.txt", ifu.i1.im);
    end

    always begin
        #1 clk = ~clk;
        if ($time == 6) begin
            npc_sel = 1;
            zero = 1;
        end
        if ($time == 8) begin
            npc_sel = 0;
            zero = 0;
        end
        if ($time > 100) $finish;
    end

endmodule
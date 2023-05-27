module mips_tb;

    reg clk;
    reg rst;

    wire zero, overflow, positive;
    wire [31:0] pc;
    wire [31:0] gpr_data0, gpr_data1, gpr_data2, gpr_data3, gpr_data6, gpr_data8, gpr_data9, gpr_data10, gpr_data11, gpr_data30, gpr_data31;
    assign gpr_data0 = mips_1.datapath_1.gpr_1.rgs[0];
    assign gpr_data1 = mips_1.datapath_1.gpr_1.rgs[1];
    assign gpr_data2 = mips_1.datapath_1.gpr_1.rgs[2];
    assign gpr_data3 = mips_1.datapath_1.gpr_1.rgs[3];
    assign gpr_data6 = mips_1.datapath_1.gpr_1.rgs[6];
    assign gpr_data8 = mips_1.datapath_1.gpr_1.rgs[8];
    assign gpr_data9 = mips_1.datapath_1.gpr_1.rgs[9];
    assign gpr_data10 = mips_1.datapath_1.gpr_1.rgs[10];
    assign gpr_data11 = mips_1.datapath_1.gpr_1.rgs[11];
    assign gpr_data30 = mips_1.datapath_1.gpr_1.rgs[30];
    assign gpr_data31 = mips_1.datapath_1.gpr_1.rgs[31];

    assign zero = mips_1.datapath_1.alu_1.zero;
    assign positive = mips_1.datapath_1.alu_1.positive;
    assign pc = mips_1.datapath_1.ifu_1.pc;
    assign overflow = mips_1.datapath_1.alu_1.overflow;

    mips mips_1(
        .clk(clk),
        .rst(rst)
    );

    initial begin
        clk = 1'b0;
        #5 rst = 1'b1;
        #5 rst = 1'b0;
        $readmemh("../code4.txt", mips_1.datapath_1.ifu_1.i1.im);

        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, mips_tb);    //tb模块名称
    end

    always begin
        #1 clk = ~clk;
        if ($time == 60) $finish;
    end

endmodule
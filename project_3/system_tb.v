`include "system.v"

module system_tb;

    reg clk;
    reg rst;

    reg [31:0] reg_data_input;

    // wire zero, overflow, positive;
    wire [31:0] pc;
    wire [31:0] gpr_data0, gpr_data1, gpr_data2, gpr_data3, gpr_data4, gpr_data5, gpr_data6, gpr_data7, gpr_data8, gpr_data9, gpr_data10, gpr_data11, gpr_data12, gpr_data13, gpr_data14, gpr_data15, gpr_data16, gpr_data17, gpr_data18, gpr_data19, gpr_data20, gpr_data21, gpr_data22, gpr_data23, gpr_data24, gpr_data25, gpr_data26, gpr_data27, gpr_data28, gpr_data29, gpr_data30, gpr_data31;
    wire [3:0] state;
    // wire [5:0] opcode, funct;
    wire [31:0] ins;
    wire exl;
    // wire exl_set;
    // wire pc_write;
    // wire [1:0] pc_sel;
    // wire [31:0] rnpc;
    // wire [31:0] aluout;
    // wire [15:0] imm;
    // wire signed_less;
    // wire [31:0] w_sra_data;
    // wire [4:0] shamt;

    // wire [31:0] timer_preset;
    // wire dev_write_en1;
    // wire hit_dev1;
    // wire [3:2] timer_add;
    // wire [31:0] rgs_alu;
    wire [31:0] wire_data_output;
    // wire [31:0] epc;
    // wire int_request, controller_int_request;
    // wire [31:0] count, preset;

    // assign preset = system_1.dev_timer_1.preset;
    // assign count = system_1.dev_timer_1.count;
    // assign int_request = system_1.dev_timer_1.int_request;
    // assign controller_int_request = system_1.mips_1.controller_1.int_request;
    // assign epc = {system_1.mips_1.datapath_1.w_epc, 2'b0};

    // assign rgs_alu = system_1.mips_1.datapath_1.rgs_alu;
    // assign timer_add = system_1.dev_timer_1.add;
    // assign hit_dev1 = system_1.bridge_1.hit_dev1;
    // assign dev_write_en1 = system_1.bridge_1.dev_write_en1;
    // assign timer_preset = system_1.dev_timer_1.preset;

    // assign shamt = system_1.mips_1.datapath_1.w_ins[10:6];
    // assign w_sra_data = system_1.mips_1.datapath_1.w_sra_data;

    // assign signed_less = system_1.mips_1.datapath_1.alu_1.signed_less;
    // assign imm = system_1.mips_1.datapath_1.ifu_1.imm;
    // assign aluout = system_1.mips_1.datapath_1.rgs_alu;
    // assign rnpc = system_1.mips_1.datapath_1.ifu_1.relative_pc;
    // assign pc_sel = system_1.mips_1.controller_1.npc_sel;
    // assign pc_write = system_1.mips_1.controller_1.pc_write;

    // assign exl_set = system_1.mips_1.controller_1.exl_set;
    assign exl = system_1.mips_1.datapath_1.cp0_1.exl;
    assign state = system_1.mips_1.controller_1.state;
    // assign opcode = system_1.mips_1.datapath_1.opcode;
    // assign funct = system_1.mips_1.datapath_1.funct;
    assign ins = system_1.mips_1.datapath_1.w_ins;

    assign gpr_data0 = system_1.mips_1.datapath_1.gpr_1.rgs[0];
    assign gpr_data1 = system_1.mips_1.datapath_1.gpr_1.rgs[1];
    assign gpr_data2 = system_1.mips_1.datapath_1.gpr_1.rgs[2];
    assign gpr_data3 = system_1.mips_1.datapath_1.gpr_1.rgs[3];
    assign gpr_data4 = system_1.mips_1.datapath_1.gpr_1.rgs[4];
    assign gpr_data5 = system_1.mips_1.datapath_1.gpr_1.rgs[5];
    assign gpr_data6 = system_1.mips_1.datapath_1.gpr_1.rgs[6];
    assign gpr_data7 = system_1.mips_1.datapath_1.gpr_1.rgs[7];
    assign gpr_data8 = system_1.mips_1.datapath_1.gpr_1.rgs[8];
    assign gpr_data9 = system_1.mips_1.datapath_1.gpr_1.rgs[9];
    assign gpr_data10 = system_1.mips_1.datapath_1.gpr_1.rgs[10];
    assign gpr_data11 = system_1.mips_1.datapath_1.gpr_1.rgs[11];
    assign gpr_data12 = system_1.mips_1.datapath_1.gpr_1.rgs[12];
    assign gpr_data13 = system_1.mips_1.datapath_1.gpr_1.rgs[13];
    assign gpr_data14 = system_1.mips_1.datapath_1.gpr_1.rgs[14];
    assign gpr_data15 = system_1.mips_1.datapath_1.gpr_1.rgs[15];
    assign gpr_data16 = system_1.mips_1.datapath_1.gpr_1.rgs[16];
    assign gpr_data17 = system_1.mips_1.datapath_1.gpr_1.rgs[17];
    assign gpr_data18 = system_1.mips_1.datapath_1.gpr_1.rgs[18];
    assign gpr_data19 = system_1.mips_1.datapath_1.gpr_1.rgs[19];
    assign gpr_data20 = system_1.mips_1.datapath_1.gpr_1.rgs[20];
    assign gpr_data21 = system_1.mips_1.datapath_1.gpr_1.rgs[21];
    assign gpr_data22 = system_1.mips_1.datapath_1.gpr_1.rgs[22];
    assign gpr_data23 = system_1.mips_1.datapath_1.gpr_1.rgs[23];
    assign gpr_data24 = system_1.mips_1.datapath_1.gpr_1.rgs[24];
    assign gpr_data25 = system_1.mips_1.datapath_1.gpr_1.rgs[25];
    assign gpr_data26 = system_1.mips_1.datapath_1.gpr_1.rgs[26];
    assign gpr_data27 = system_1.mips_1.datapath_1.gpr_1.rgs[27];
    assign gpr_data28 = system_1.mips_1.datapath_1.gpr_1.rgs[28];
    assign gpr_data29 = system_1.mips_1.datapath_1.gpr_1.rgs[29];
    assign gpr_data30 = system_1.mips_1.datapath_1.gpr_1.rgs[30];
    assign gpr_data31 = system_1.mips_1.datapath_1.gpr_1.rgs[31];

    // assign zero = system_1.mips_1.datapath_1.alu_1.zero;
    // assign positive = system_1.mips_1.datapath_1.alu_1.positive;
    assign pc = system_1.mips_1.datapath_1.ifu_1.pc;
    // assign overflow = system_1.mips_1.datapath_1.alu_1.overflow && system_1.mips_1.datapath_1.controller_1.addi;

    system system_1(
        .clk(clk),
        .reset(rst),

        .data_input(reg_data_input),
        .data_output(wire_data_output)
    );

    initial begin
        reg_data_input = 32'b0;
        clk = 1'b1;
        // $readmemh("code1.txt", system_1.mips_1.datapath_1.ifu_1.i1.im); // test cp0 instructions
        $readmemh("code_main.txt", system_1.mips_1.datapath_1.ifu_1.i1.im);
        $readmemh("code_eret.txt", system_1.mips_1.datapath_1.ifu_1.i1.im, 'h1180);
        #5 rst = 1'b0;
        #5 rst = 1'b1;
        #5 rst = 1'b0;

        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, system_tb);    //tb模块名称
    end

    always begin
        #1 clk = ~clk;
        if ($time < 400) reg_data_input = reg_data_input + 1;
        if ($time == 800) $finish;
    end

endmodule
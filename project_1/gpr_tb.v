module gpr_tb;
    reg clk;
    reg [4:0] read1, read2;
    reg [4:0] write;
    reg [31:0] write_data;
    reg wd;
    wire [31:0] data1, data2;

    gpr g1(clk, read1, read2, write, write_data, wd, data1, data2);

    integer i;

    initial begin
        clk = 0;
        read1 = 5'b0;
        read2 = 5'b0;
        write = 5'b0;
        write_data = 32'b0;
        wd = 0;

        // for (i = 0; i < 32; i = i + 1)
        // begin
        //     #1 g1.rgs[i] = i;
        // end

        $dumpfile("wave.vcd");        //生成的vcd文件名称
        $dumpvars(0, gpr_tb);    //tb模块名称

        //$readmemh("../code1.txt", ifu.i1.im);
    end

    always begin
        #1 clk = ~clk;
        if ($time > 50) $finish;
    end

    always @ (posedge clk) begin
        if ($time < 32)
        begin
            wd = 1;
            #3 write = $time % 32;
            write_data = $time % 32;
            wd = 0;
        end
    end

    always @ (posedge clk) begin
        #1 read1 = $time;
        read2 = (read1 == 31) ? 0 : read1 + 1;
    end

endmodule
module bridge (
    input [31:0] pr_addr,
    input [31:0] pr_write_data,
    input [31:0] dev_read_data0, dev_read_data1, dev_read_data2,
    input int_request0, int_request1, int_request2,
    input pr_write_en,

    output [31:0] pr_read_data,
    output [3:2] dev_addr,
    output [31:0] dev_write_data,

    output dev_write_en0, dev_write_en1, dev_write_en2,

    output [5:0] hw_int
);  

    // dev0 : timer     0000_7F00 -> 0000_7F0B (12 byte)
    // dev1 : input     0000_7F10 -> 0000_7F13 (4  byte)
    // dev2 : output    0000_7F20 -> 0000_7F23 (4  byte)

    wire hit_dev0, hit_dev1, hit_dev2;

    assign dev_write_data = pr_write_data;
    assign dev_addr = pr_addr[3:2];

    assign hit_dev0 = (pr_addr[15:4] == 12'b0111_1111_0000);
    assign hit_dev1 = (pr_addr[15:4] == 12'b0111_1111_0001);
    assign hit_dev2 = (pr_addr[15:4] == 12'b0111_1111_0010);

    assign dev_write_en0 = (pr_write_en && hit_dev0);
    assign dev_write_en1 = (pr_write_en && hit_dev1);
    assign dev_write_en2 = (pr_write_en && hit_dev2);

    assign pr_read_data = (hit_dev0) ? dev_read_data0 :
                           (hit_dev1) ? dev_read_data1 :
                           (hit_dev2) ? dev_read_data2 : 0;

    assign hw_int = {3'b0, int_request2, int_request1, int_request0};

endmodule






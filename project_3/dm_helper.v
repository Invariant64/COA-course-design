`include "defines.v"

module dm_helper (
    input mem_op,
    input [31:0] read_gpr_data,
    input [31:0] read_mem_data,

    output [31:0] write_gpr_data,
    output [31:0] write_mem_data
);

    assign write_gpr_data = (mem_op == `MEM_OP_WORD) ? read_mem_data :
                            (mem_op == `MEM_OP_BYTE) ? {{24{read_mem_data[7]}}, read_mem_data[7:0]} : 0;
                        
    assign write_mem_data = (mem_op == `MEM_OP_WORD) ? read_gpr_data :
                            (mem_op == `MEM_OP_BYTE) ? {read_mem_data[31:8], read_gpr_data[7:0]} : 0;

endmodule
import kamus_pkg::wb_options_e;

module kamus_WB(
    input logic             regfile_wr_en_memwb_reg_i,
    input logic [31:0]      alu_memwb_reg_i,            // the data0 that will be saved to regFile (and in MEM/WB register)
    input logic [31:0]      l1d_rd_data_memwb_reg_i,    // the data1 that will be saved to regFile (and in MEM/WB register)
    input logic [1:0]       wb_mux_sel_memwb_reg_i,
    input logic [4:0]       rd_addr_memwb_reg_i,

    // WB-RegFile Interface
    output logic            regfile_wr_en_memwb_reg_o,
    output logic [4:0]      rd_addr_memwb_reg_o,
    output logic [31:0]     wb_data_o
);

assign regfile_wr_en_memwb_reg_o        = regfile_wr_en_memwb_reg_i;
assign rd_addr_memwb_reg_o              = rd_addr_memwb_reg_i;

always_comb begin
    case(wb_mux_sel_memwb_reg_i)
        ALU_RESULT: wb_data_o   = alu_memwb_reg_i;
        MEM_RESULT: wb_data_o   = l1d_rd_data_memwb_reg_i;
        default:    wb_data_o   = 32'b0;
    endcase
end

endmodule
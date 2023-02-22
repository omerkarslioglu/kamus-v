module kamus_WB(
    input logic             regfile_wr_en_memwb_reg_i,
    
    input logic [31:0]      alu_memwb_reg_i,            // the data0 that will be saved to regFile (and in MEM/WB register)
    input logic [31:0]      l1d_rd_data_memwb_reg_i,    // the data1 that will be saved to regFile (and in MEM/WB register)
    input logic [1:0]       wb_mux_sel_memwb_reg_i,
    input logic [4:0]       rd_addr_memwb_reg_i,
    
);



endmodule
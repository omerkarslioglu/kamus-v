/*
    This module is important for two main stages:
        1-) Access to Data Memory to read or write
        2-) Access to Register File to write AFTER READING DATA MEM.
    
    LSU covered L1 data cache with an interface and register for WB stage
    to access register file (2) to write data.

    Omer Karslioglu - omerkarsliogluu@gmail.com - 22.02.2023
*/


//import kamus_pkg::*;

module kamus_LSU(
    input logic [31:0]      alu_rslt_i,         // comes from kamus_EX (ALU)
    input logic [31:0]      l1d_wr_data_i,      // comes from kamus_ID (regfile) (when store command taken)
    input logic             l1d_wr_en_i,        // comes from  control unit
    
    output logic [31:0]     l1d_rd_data_o, alu_o, pc4_o, // the datas that will be saved to regFile

    output logic            regfile_wr_en_o,
    output logic [31:0]     mem_wr_data_o, reg_wr_data_o
);

logic [31:0]  l1d_wr_addr;

assign l1d_wr_addr = alu_rslt_i;

endmodule
/*
    This module is important for two main stages:
        1-) Access to Data Memory to read or write
        2-) Access to Register File to write AFTER READING DATA MEM.
    
    LSU covered L1 data cache with an interface and register for WB stage
    to access register file (2) to write data.

    Omer Karslioglu - omerkarsliogluu@gmail.com - 22.02.2023


    -- MUST BE UPDATED
        - All control signals must be buffered to the stages are need
        - PC must be stopped when an instruction is in pipeline stages
        - All core stages must be updated according to pipeline stages
        - L1 data cache must support combinational reading, sequential writing as register file
    --
*/


//import kamus_pkg::*;

module kamus_LSU(
    input clk_i, rst_ni,

    // EX stage interface (prev. stage)
    input logic [31:0]      rs2_exmem_reg_i,            // rs2 values comes from kamus_EX (regfile) (when store command taken)
    input logic [31:0]      alu_rslt_exmem_reg_i,       // comes from kamus_EX (ALU)
        // comes from EX but they are related with Control Unit:
    input logic             l1d_wr_en_exmem_reg_i,      // comes from  kamus_EX (control unit)
    input logic             regfile_wr_en_exmem_i,

    // WB stage interface (next stage)
    output logic            regfile_wr_en_memwb_reg_o,  
    output logic [31:0]     alu_memwb_reg_o             // the data that will be saved to regFile (and in MEM/WB register)
    output logic [31:0]     l1d_rd_data_o,              // the data will be readed from l1d as sequential so no need MEM/WB reg -
                                                        //      **l1d_rd_data_o shoud forward to WB stages
    
    // $L1D Interface
    input logic [31:0]      l1d_rd_data_i,          
    output logic            l1d_wr_en_o,                // comes from from kamus_EX
    output logic [31:0]     l1d_addr_o,                 // comes from from kamus_EX
    output logic [31:0]     l1d_wr_data_o
);

assign l1d_wr_en_o          = l1d_wr_en_exmem_reg_i; 
assign l1d_addr_o           = alu_rslt_exmem_reg_i;
assign l1d_wr_data_o        = rs2_exmem_reg_i;
assign l1d_rd_data_o        = l1d_rd_data_i;

/*
    MEM/WB Register:
*/
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        regfile_wr_en_memwb_reg_o               <= 0;
        reg_wr_data_memwb_reg_o                 <= 0;
        alu_memwb_reg_o                         <= 0;
    end else begin
        regfile_wr_en_memwb_reg_o               <= regfile_wr_en_exmem_i;
        alu_memwb_reg_o                         <= alu_rslt_exmem_reg_i;      
    end
end

endmodule
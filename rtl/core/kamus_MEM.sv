/*
    This module is important for two main stages:
        1-) Access to Data Memory to read or write
        2-) Access to Register File to write AFTER READING DATA MEM.
    
    MEM covered L1 data cache with an interface and register for WB stage
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

/* -- The Components Connected to Control Unit
UNVALID
*/

module kamus_MEM(
    input clk_i, rst_ni,

    // EX stage interface (prev. stage)
    input logic [31:0]              rs2_data_i,                 // rs2 values comes from kamus_EX (regfile) (when store command taken)
    input logic [31:0]              ex_rslt_i,                  // comes from kamus_EX (ALU)
    input logic [4:0]               rd_addr_i,
    input logic [4:0]               operation_i,
    input logic [31:0]              next_pc_i,
    input logic                     is_branch_taken_i,
        // comes from EX but they are related with Control Unit:
    input logic                     l1d_wr_en_i,                // comes from  kamus_EX (control unit)
    input logic                     regfile_wr_en_i,            // from exmem ff
    input logic [1:0]               wb_mux_sel_i,               // from exmem ff
    input instr_addr_sel_state_e    instr_addr_sel_i,

    // WB stage interface (next stage)
    output logic                    regfile_wr_en_o,  
    output logic [31:0]             ex_rslt_o,                  // the data0 that will be saved to regFile (and in MEM/WB register)
    output logic [31:0]             l1d_rd_data_o,              // the data1 that will be saved to regFile (and in MEM/WB register)
    output logic [1:0]              wb_mux_sel_o,
    output logic [4:0]              rd_addr_o,
    output logic [31:0]             next_pc_o,
    output logic                    is_branch_taken_o,
    output instr_addr_sel_state_e   instr_addr_sel_o,
    
    // $L1D Interface
    input logic [31:0]              l1d_rd_data_i,          
    output logic                    l1d_wr_en_o,                // comes from from kamus_EX
    output logic [31:0]             l1d_addr_o,                 // comes from from kamus_EX
    output logic [31:0]             l1d_wr_data_o
);

logic [31:0] lsu_data_buff;                                     // it was designed for WORD-HALFWORD-BYTE store and load options

assign l1d_wr_en_o                  = l1d_wr_en_i; 
assign l1d_addr_o                   = ex_rslt_i;
assign l1d_wr_data_o                = lsu_data_buff;            // it will be used store
assign next_pc_o                    = next_pc_i;


// MEM/WB Register Inputs:
assign regfile_wr_en_o              = regfile_wr_en_i;
assign ex_rslt_o                    = ex_rslt_i;
assign l1d_rd_data_o                = lsu_data_buff;            // it will be used load
assign wb_mux_sel_o                 = wb_mux_sel_i;
assign rd_addr_o                    = rd_addr_i;
assign is_branch_taken_o            = is_branch_taken_i;
assign instr_addr_sel_o             = instr_addr_sel_i;

// LSU
always_comb begin
    unique case (operation_i)
        LW:         lsu_data_buff       = l1d_rd_data_i;
        LH:         lsu_data_buff       = {16{l1d_rd_data_i[15]}, l1d_rd_data_i[15:0]};
        LB:         lsu_data_buff       = {24{l1d_rd_data_i[7]}, l1d_rd_data_i[7:0]};
        LHU:        lsu_data_buff       = {16{1'b1}, l1d_rd_data_i[15:0]};
        LBU:        lsu_data_buff       = {24{1'b1}, l1d_rd_data_i[7:0]};
        SW:         lsu_data_buff       = rs2_data_i;
        SH:         lsu_data_buff       = {16{rs2_data_i[15]}, rs2_data_i[15:0]};
        SB:         lsu_data_buff       = {24{rs2_data_i[7]}, rs2_data_i[7:0]};
        default:    lsu_data_buff       = 32'b0;
    endcase
end

endmodule
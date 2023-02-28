/* -- The Components Connected to Control Unit
1-) wb MUX (wb_mux_sel_i)
*/

import kamus_pkg::wb_options_e;

module kamus_WB(
    input logic             regfile_wr_en_i,
    input logic [31:0]      ex_rslt_i,              // the data0 that will be saved to regFile (and in MEM/WB register)
    input logic [31:0]      l1d_rd_data_i,          // the data1 that will be saved to regFile (and in MEM/WB register)
    input logic [1:0]       wb_mux_sel_i,
    input logic [4:0]       rd_addr_i,
    input logic [31:0]      next_pc_i,              // comes from IF(generated)->buffered->WB(used)
    input logic             is_branch_taken_i,

    // WB-IF Interface
    output logic            is_branch_taken_o,
    output logic [31:0]     ex_rslt_o,
    
    // WB-RegFile Interface
    output logic            regfile_wr_en_o,
    output logic [4:0]      rd_addr_o,
    output logic [31:0]     wb_data_o
);

assign regfile_wr_en_o              = regfile_wr_en_i;
assign rd_addr_o                    = rd_addr_i;
assign is_branch_taken_o            = is_branch_taken_i;
assign ex_rslt_o                    = ex_rslt_i;

always_comb begin
    case(wb_mux_sel_i)
        ALU_RESULT  :   wb_data_o   = ex_rslt_i;
        MEM_RESULT  :   wb_data_o   = l1d_rd_data_i;
        NEXT_PC     :   wb_data_o   = next_pc_i;
        default:        wb_data_o   = 32'b0;
    endcase
end

endmodule
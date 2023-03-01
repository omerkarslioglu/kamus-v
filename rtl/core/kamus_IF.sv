/* -- The Components Connected to Control Unit
1-)  instruction address selection/pc MUX
*/
import kamus_pkg::*;

module kamus_IF
#(
    parameter logic [31:0] BOOT_ADDR = 32'h0;
)(
    input logic clk_i, rst_ni,
    input logic flush_i,

    // WB-IF Interface:
    input logic [31:0]  ex_rslt_i,              // comes from EX->buffered->IF (for jump and branch)
    input logic         is_branch_taken_i,
    input logic [2:0]   instr_addr_sel_i,       // for pc value selector mux (according to jal, branch etc.)
    
    // L1I Interface:
    input logic [31:0]  instr_data_i,           // comes from $L1I
    output logic [31:0] instr_addr_o,           // instr_addr = target pc (for $l1i)
    
    // IF-ID Interface:
    output logic [31:0] instr_data_o,           // just wire that connected to ID
    output logic [31:0] next_pc_o               // next = pc+4
);

logic [31:0] pc_next;
logic [31:0] pc_curr;

instr_addr_sel_state_e instr_addr_sel;

assign instr_data_o = instr_data_i;
assign instr_addr_sel <= instr_addr_sel_i;

always_comb begin
    unique case(instr_addr_sel)
        PC4_ST:     instr_addr_o = pc_next;
        PC_ST:      instr_addr_o = pc_curr;
        B_ST:       instr_addr_o = (is_branch_taken_i)? ex_rslt_i : pc_curr;
        J_ST:       instr_addr_o = ex_rslt_i;
        default:    instr_addr_o = pc_curr;
    endcase
end

always @(posedge clk_i) begin
    if(~rst_ni) begin
        pc_curr <= BOOT_ADDR;
        pc_next <= BOOT_ADDR;
    end else begin
        if(~flush_i) begin
            pc_curr <= pc_next;
            pc_next <= pc_next + 32'h4;
        end else begin
            pc_curr <= pc_curr;
            pc_next <= pc_next;
        end
    end
end

endmodule
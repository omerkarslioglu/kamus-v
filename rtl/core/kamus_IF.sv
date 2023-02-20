module kamus_IF
#(
    parameter logic [31:0] BOOT_ADDR = 32'h0;
)(
    input clk_i, rst_ni,
    input logic [31:0]  instr_val_i,            // comes from $L1I
    input logic [31:0]  instr_imm_addr_i,       // comes from ID (for jump and branch)
    input logic [2:0]   instr_addr_sel_i,       // for pc value selector mux (according to jal, branch etc.)
    
    output logic [31:0] instr_val_o,            // just wire that connected to ID
    output logic [31:0] instr_addr_o            // instr_addr = pc
);

logic [31:0] pc_next;
logic [31:0] pc_curr;

instr_addr_sel_state_e instr_addr_sel;

enum bit [2:0] {
    PC4_ST, // PC+4 state
    PC_ST, // PC state for state
    B_ST,
    J_ST
}instr_addr_sel_state_e;

assign instr_val_o = instr_val_i;
assign instr_addr_sel <= instr_addr_sel_i;

always_comb @(posedge clk_i) begin
    case(instr_addr_sel)
        PC4_ST:     instr_addr_o = pc_next;
        PC_ST:      instr_addr_o = pc_curr;
        B_ST:       instr_addr_o = pc_curr + instr_imm_addr_i;
        J_ST:       instr_addr_o = instr_imm_addr_i; // WILL BE UPDATED, LINK PC+4 to X1 or X5 MUST BE NEED
        default:    instr_addr_o = pc_next;
    endcase
end

always @(posedge clk_i) begin
    if(~rst_ni) begin
        pc <= BOOT_ADDR;
    end else begin
        pc_curr <= pc_next;
        pc_next <= pc_next + 32'h4;
    end
end

endmodule
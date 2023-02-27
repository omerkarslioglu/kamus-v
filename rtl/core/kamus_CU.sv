/* 
    kamus-v Control Unit FSM Module
*/
import kamus_pkg::*;

module kamus_CU(
    input instr_decoded_t control_unit_i,          // comes from just operation
    output control_unit_t control_unit_o
);

always_comb begin
    unique case(control_unit_i.operation)
    JAL, JALR:
        control_unit_o.instr_addr_state     = J_ST;
        control_unit_o.wb_sel               = ALU_RESULT;
        control_unit_o.l1d_wr_en            = 1'b0;
    BEQ, BNE, BLT, BGE, BLTU, BGEU:
        control_unit_o.instr_addr_state     = B_ST;
        control_unit_o.wb_sel               = ?????????;
        control_unit_o.l1d_wr_en            = 1'b0;
    SW, SH, SB:
        control_unit_o.instr_addr_state     = PC4_ST;
        control_unit_o.wb_sel               = MEM_RESULT;
        control_unit_o.l1d_wr_en            = 1'b1;

    default:
        control_unit_o.instr_addr_state     = PC4_ST;
        control_unit_o.wb_sel               = ALU_RESULT; // doesn't matter
        control_unit_o.l1d_wr_en            = 1'b0;

    endcase
end

endmodule
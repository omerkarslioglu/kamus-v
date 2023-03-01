/* 
    kamus-v Control Unit FSM Module
*/
import kamus_pkg::*;

module kamus_CU(
    input   control_unit_t      control_unit_i,          // comes from just instr_type (or operation)
    output  control_unit_t      control_unit_o
);

always_comb begin
    unique case(control_unit_i.instr_type)     // instead of control_unit_i.operation
        LUI_TYPE, AUIPC_TYPE        // LUI, AUIPC:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;

        JAL_TYPE, JALR_TYPE:        // JAL, JALR:
            control_unit_o.instr_addr_state     = J_ST;
            control_unit_o.wb_sel               = NEXT_PC;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;

        B_TYPE:                    // BEQ, BNE, BLT, BGE, BLTU, BGEU:
            control_unit_o.instr_addr_state     = B_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b0;

        L_TYPE:                     // LB, LH, LW, LBU, LHU:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;
        
        S_TYPE:                     // SB, SH, SW:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b1;
            control_unit_o.regfile_wr_en        = 1'b0;
        
        ALU_I_TYPE, ALU_TYPE:       // ADD, SUB, SLT, SLTU, XOR, OR, AND, SL, SRL, SRA:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;

        default:                    // flush and unexpected conditions
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT; // doesn't matter
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b0;
    endcase
end

endmodule
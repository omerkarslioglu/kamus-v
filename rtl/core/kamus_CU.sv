/* 
    kamus-v Control Unit FSM Module
*/
import kamus_pkg::*;

module kamus_CU(
    input   control_unit_input_t    control_unit_i,          // comes from just instr_type (or operation)
    output  control_unit_output_t   control_unit_o
);

always_comb begin
    unique case(control_unit_i.instr_type)      // instead of control_unit_i.operation
        LUI_TYPE, AUIPC_TYPE: begin                    // LUI, AUIPC:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;
        end
        JAL_TYPE, JALR_TYPE: begin        // JAL, JALR:
            control_unit_o.instr_addr_state     = J_ST;
            control_unit_o.wb_sel               = NEXT_PC;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;
        end
        B_TYPE: begin                   // BEQ, BNE, BLT, BGE, BLTU, BGEU:
            control_unit_o.instr_addr_state     = B_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b0;
        end
        L_TYPE: begin                     // LB, LH, LW, LBU, LHU:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = MEM_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;
        end
        S_TYPE: begin                     // SB, SH, SW:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b1;
            control_unit_o.regfile_wr_en        = 1'b0;
        end
        ALU_I_TYPE, ALU_TYPE: begin       // ADD, SUB, SLT, SLTU, XOR, OR, AND, SL, SRL, SRA:
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT;
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b1;
        end
        default: begin                   // flush and unexpected conditions
            control_unit_o.instr_addr_state     = PC_ST;
            control_unit_o.wb_sel               = ALU_RESULT; // doesn't matter
            control_unit_o.l1d_wr_en            = 1'b0;
            control_unit_o.regfile_wr_en        = 1'b0;
        end
    endcase
end

endmodule
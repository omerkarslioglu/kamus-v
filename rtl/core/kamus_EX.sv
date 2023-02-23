module kamus_EX(
    input instr_decoded_t instr_i,
    input logic [31:0] rs1_value_i,
    input logic [31:0] rs2_value_i,

    output logic [5:0] operation_exmem__reg_o,
    output logic [31:0] ex_o
);

assign ex_o                         = execute(instr_i, rs1_value_i, rs2_value_i);
assign operation_exmem__reg_o       = instr_i.operation;     


function automatic logic [31:0] execute(instr_decoded_t instr, logic [31:0] rs1_value, logic [31:0] rs2_value);
    logic [31:0] rs2_value_or_imm = instr.immediate_used ? instr.immediate : rs2_value;

    // implement both logical and arithmetic as an arithmetic right shift, with a 33rd bit set to 0 or 1 as required.
    // logic signed [32:0] rshift_operand = {(instr.funct7_bit & rs1_value[31]), rs1_value};

    // shifts use the lower 5 bits of the intermediate or rs2 value
    logic [4:0] shift_amount = rs2_value_or_imm[4:0];

    //logic [31:0] ex_buff;

    unique case (instr.operation)
        ADD, LW, LH, LHU, LB, LBU, SW, SB, SH:
            return rs1_value + rs2_value_or_imm;
        SUB:    return rs1_value - rs2_value;
        SLT:    return $signed(rs1_value) < $signed(rs2_value_or_imm);
        SLTU:   return rs1_value < rs2_value_or_imm;
        XOR:    return rs1_value ^ rs2_value_or_imm;
        OR:     return rs1_value | rs2_value_or_imm;
        AND:    return rs1_value & rs2_value_or_imm;
        SL:     return rs1_value << shift_amount;
        SRL:    return rs1_value >> shift_amount;
        SRA:    return $signed(rs1_value) >>> shift_amount;
        LUI:    return instr.immediate;
        AUIPC:  return instr.immediate + instr.pc;
        // JAL(R) stores the address of the instruction that followed the jump
        JAL, JALR: return instr.pc + 4; // next instr
        CSRRW, CSRRS, CSRRC: return read_csr(csr_e'(instr.funct12));
        default: return 'x;
    endcase
endfunction

// IT WILL BE UPDATED
function automatic logic [31:0] read_csr(csr_e csr_addr);
        case (csr_addr)
`ifdef MACHINE_MODE
            MVENDORID, MARCHID, MIMPID, MHARTID, MEDELEG, MIDELEG: return '0;
            MISA:      return 32'b01000000_00000000_00000001_00000000;
            MTVEC:     return {mtvec[31:2], 2'b0}; // must be aligned on a 4-byte boundary
            MSTATUS:   return {19'b0, 2'b11, 3'b0, mstatus.mpie, 3'b0, mstatus.mie, 3'b0};
            MIP:       return {20'b0, mip.meip, 3'b0, mip.mtip, 3'b0, mip.msip, 3'b0};
            MIE:       return {20'b0, mie.meie, 3'b0, mie.mtie, 3'b0, mie.msie, 3'b0};
            MSCRATCH:  return mscratch;
            MEPC:      return {mepc[31:2], 2'b0}; // must be aligned on a 4-byte boundary
            MCAUSE:    return {mcause[31], 27'b0, mcause[3:0]};
            MBADADDR:  return mbadaddr;
            DSCRATCH:  return dscratch;
            MINSTRET:  return instret[31:0];
            MINSTRETH: return instret[63:32];
            MTIMECMP:  return timecmp[31:0];
            MTIMECMPH: return timecmp[63:32];
            // since we have a fixed frequency, we can say time = cycle count.
            MCYCLE,  MTIME:  return cycles[31:0];
            MCYCLEH, MTIMEH: return cycles[63:32];
`endif
            CYCLE,  TIME:  return cycles[31:0];
            CYCLEH, TIMEH: return cycles[63:32];
            default:   return 'x;
        endcase
endfunction

endmodule
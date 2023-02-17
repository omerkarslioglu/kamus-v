module kamus_EX(
    input operation_e operation_i,
    input logic [31:0] rs1_value,
    input logic [31:0] rs2_value,

);
    
    
    function automatic logic [31:0] execute(instr_t instr, logic [31:0] rs1_value, logic [31:0] rs2_value);

    logic [31:0] rs2_value_or_imm = instr.immediate_used ? instr.immediate : rs2_value;

    // implement both logical and arithmetic as an arithmetic right shift, with a 33rd bit set to 0 or 1 as required.
    // logic signed [32:0] rshift_operand = {(instr.funct7_bit & rs1_value[31]), rs1_value};

    // shifts use the lower 5 bits of the intermediate or rs2 value
    logic [4:0] shift_amount = rs2_value_or_imm[4:0];

    unique case (instr.op)
        ADD:   return rs1_value + rs2_value_or_imm;
        SUB:   return rs1_value - rs2_value;
        SLT:   return $signed(rs1_value) < $signed(rs2_value_or_imm);
        SLTU:  return rs1_value < rs2_value_or_imm;
        XOR:   return rs1_value ^ rs2_value_or_imm;
        OR:    return rs1_value | rs2_value_or_imm;
        AND:   return rs1_value & rs2_value_or_imm;
        SL:    return rs1_value << shift_amount;
        SRL:   return rs1_value >> shift_amount;
        SRA:   return $signed(rs1_value) >>> shift_amount;
        LUI:   return instr.immediate;
        AUIPC: return instr.immediate + instr.pc;
        // JAL(R) stores the address of the instruction that followed the jump
        JAL, JALR: return instr.pc + 4;
        CSRRW, CSRRS, CSRRC: return read_csr(csr_t'(instr.funct12));
        default: return 'x;
    endcase
    endfunction

endmodule
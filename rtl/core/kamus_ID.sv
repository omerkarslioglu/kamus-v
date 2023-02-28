/*
    Instruction Decoder

    -- Must be updated:
    -  Think that ID covers to the register file
    --
*/

/* -- The Components Connected to Control Unit
UNVALID
*/
`include "kamus_pkg.svh"
import kamus_pkg::*;

module kamus_ID #(
    parameter PC_WIDTH = 32
)(
    input logic clk_i, rst_ni,

    // Interface between IF-ID stages
    input logic [31:0]          instr_i,
    input logic [31:0]          instr_addr_i,       // comes from fetch stage: kamus_IF (instr_addr)
    input logic [31:0]          next_pc_i,

    // Interface between ID-EX stages
    output instr_decoded_t      instr_o,
    output logic [31:0]         rs1_data_o,
    output logic [31:0]         rs2_data_o,
    output logic [31:0]         next_pc_o,
    
    // -- RegisterFile Interface:
    input logic [31:0]          rs1_data_i,
    input logic [31:0]          rs2_data_i,
    output logic [4:0]          rs1_addr_o,
    output logic [4:0]          rs2_addr_o,
    output logic [4:0]          rd_addr_o
    // --

);

//logic [6:0] opcode;
logic [32:0] immediate_val;

//assign opcode = instr_i[6:0];

assign instr_o.opcode           = instr_i[6:0];
// assign instr_o.rd_addr          = instr_i[11:7];
// assign instr_o.func3            = instr_i[14:12];
// assign instr_o.rs1_addr         = instr_i[19:15];
// assign instr_o.rs2_addr         = instr_i[24:20];
// assign instr_o.func7            = instr_i[31:25];
// assign instr_o.imm_i        = instr_i[31:20];
// assign instr_o_imm_s        = {instr_i[31:25], instr_i[11:7]};
// assign instr_o_imm_b        = {instr_i[12], instr_i[10:5], instr_i[4:1], instr_i[11]};
// assign instr_o.imm_u        = instr_i[31:12];
// assign instr_o.imm_j        = {instr_i[20], instr_i[10:1], instr_i[11] ,instr_i[12:19]};
assign instr_o.immediate        = immediate_val[31:0];
assign instr_o.immediate_used   = immediate_val[32];
assign instr_o.pc               = instr_addr_i;
assign instr_o.operation        = decode_opcode(instr_i);
assign immediate_val            = decode_immediate(instr_i);
assign rs1_data_o               = rs1_data_i;
assign rs2_data_o               = rs2_data_i;
assign next_pc_o                = next_pc_i;

// // register_file.sv instantiate:
// register_file register_file(
//     .clk_i(clk_i), 
//     .rst_ni(rst_ni),
//     .rs1_addr_i(instr_i`rs1),           
//     .rs2_addr_i(instr_i`rs2),    
//     .rd_addr_i(instr_i`rd),            
//     .wr_data_i(...),      
//     .rs1_val_o(rs1_val_o),
//     .rs2_val_o(rs2_val_o)
// );

// -- for register file interface
assign rs1_addr_o               = instr_i`rs1;
assign rs2_addr_o               = instr_i`rs2;
assign rd_addr_o                = instr_i`rd;
// --


function automatic operation_e decode_opcode(logic [31:0] instr);
    logic [11:0] funct12 = instr`funct12;
    logic [2:0]  funct3  = instr`funct3;
    logic [4:0]  rs1 = instr`rs1;
    logic legal_csr_op = validate_csr_op(rs1 != zero, csr_e'(funct12));

    // ensure the two LSBs are 1
    if (instr`opext != 2'b11)
        return INVALID;

    unique case (instr`opcode) //opcodes
        LUI_TYPE[6:2]:  return LUI;
        AUIPC_TYPE[6:2]:return AUIPC;
        JAL_TYPE[6:2]:  return JAL;
        JALR_TYPE[6:2]: return JALR;
        B_TYPE[6:2]:
            unique case (funct3)
                F3_BEQ:     return BEQ;
                F3_BNE:     return BNE;
                F3_BLT:     return BLT;
                F3_BLTU:    return BLTU;
                F3_BGE:     return BGE;
                F3_BGEU:    return BGEU;
            endcase
        L_TYPE[6:2]:
            unique case (funct3)
                F3_LB:     return LB;
                F3_LH:     return LH;
                F3_LW:     return LW;
                F3_LBU:    return LBU;
                F3_LHU:    return LHU;
            endcase
        S_TYPE[6:2]: 
                F3_SW:      return SW;
                F3_SH:      return SH;
                F3_SB:      return SB;
        ALU_I_TYPE, ALU_TYPE:
            unique case (funct3)
                // there is no SUBI instruction so also check opcode
                F3_ADDSUB:  return instr[5] && funct12[10] ? SUB : ADD;
                F3_SLT:     return SLT;
                F3_SLTU:    return SLTU;
                F3_XOR:     return XOR;
                F3_OR:      return OR;
                F3_AND:     return AND;
                // for immediate shifts we check the 6th bit in the shift amount is 0
                // for non-immediate shifts this value must be 0 anyway (it is the end of the funct7 code)
                F3_SLL:     return funct12[5] ? INVALID : SL;
                F3_SR:      return funct12[5] ? INVALID : (funct12[10] ? SRA : SRL);
                default:    return INVALID;
            endcase
        FENCE_TYPE[6:2]:return funct3[0] ? FENCE_I : FENCE;
        CSR_TYPE[6:2]:
            unique case (funct3[1:0])
                // when rs1 is zero we are not writing to the CSR. This is used when checking for
                // an illegal write to a read-only CSR.
                F2_CSRRW: return legal_csr_op ? CSRRW : INVALID;
                F2_CSRRS: return legal_csr_op ? CSRRS : INVALID;
                F2_CSRRC: return legal_csr_op ? CSRRC : INVALID;
                F2_PRIV:
                unique case (funct12)
                    F12_ECALL:  return ECALL;
                    F12_EBREAK: return EBREAK;
`ifdef MACHINE_MODE
                    F12_MRET:   return MRET;
                    F12_WFI:    return WFI;
`endif
                    default:    return INVALID;
                endcase
            endcase
        default: return INVALID;
    endcase
endfunction

function automatic logic validate_csr_op(logic write, csr_e csr);
    // first check we aren't writing to a read-only CSR.mem.txt
    if (write && csr[11:10] == 2'b11)
        return '0;
    unique case (csr)
`ifdef MACHINE_MODE
        // all the CSRs we support in machine mode...
        MVENDORID, MARCHID, MIMPID, MHARTID, MEDELEG, MIDELEG,
        MISA, MTVEC, MSTATUS, MIP, MIE, MSCRATCH, MEPC, MCAUSE, MBADADDR, DSCRATCH,
        MCYCLE, MTIME, MINSTRET, MCYCLEH, MTIMEH, MINSTRETH, MTIMECMP, MTIMECMPH,
`endif
        // in user-mode only timer CSRs can be read
        CYCLE, TIME, CYCLEH, TIMEH: return '1;
        default:                    return '0;
    endcase

endfunction

// sign extended decoded
function automatic logic [32:0] decode_immediate(logic [31:0] instr);
        // returns an extra top bit to indicate whether the immediate is used
        // all except u-type instructions have sign-extended immediates.
        logic [19:0] sign_ext_20 = {20{instr[31]}};
        logic [11:0] sign_ext_12 = {12{instr[31]}};
        unique case (instr`opcode)
            JALR_TYPE[6:2], L_TYPE[6:2], ALU_I_TYPE[6:2]: // i-type
                return {1'b1, sign_ext_20, instr[31:20]};
            S_TYPE[6:2]: // s-type
                return {1'b1, sign_ext_20, instr[31:25], instr[11:7]};
            B_TYPE[6:2]: // sb-type
                return {1'b1, sign_ext_20, instr[7], instr[30:25], instr[11:8], 1'b0};
            JAL_TYPE[6:2]: // uj-type
                return {1'b1, sign_ext_12, instr[19:12], instr[20], instr[30:21], 1'b0};
            LUI_TYPE[6:2], AUIPC_TYPE[6:2]: // u-type
                return {1'b1, instr[31:12], 12'b0};
            CSR_TYPE[6:2]: // no ordinary immediate but possibly a csr zimm (5-bit immediate)
                return {instr[14], 32'bx};
            default: // no immediate
                return {1'b0, 32'bx};
        endcase
endfunction

endmodule
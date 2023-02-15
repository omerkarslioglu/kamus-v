`define opext  [1 : 0]
`define opcode [6 : 2] // <io/wire_name>`opcode -> selects just [6:2] bits
`define rd     [11: 7]
`define funct3 [14:12]
`define rs1    [19:15]
`define rs2    [24:20]
`define funct7 [31:25]
`define funct12 [31:20]

typedef enum logic [4:0] {
    zero,
    ra,
    sp,
    gp,
    tp,
    t0, t1, t2,
    fp, s1,
    a0, a1, a2, a3, a4, a5, a6, a7,
    s2, s3, s4, s5, s6, s7, s8, s9, s10, s11,
    t3, t4, t5, t6
} register_e;

typedef struct packed {
    logic [6:0]     opcode;
    logic [4:0]     rd;
    logic [2:0]     func3;
    logic [4:0]     rs1;
    logic [4:0]     rs2;
    logic [6:0]     func7;
    logic [11:0]    imm_i;
    logic [11:0]    imm_s;
    logic [11:0]    imm_b;
    logic [20:0]    imm_u;
    logic [20:0]    imm_j;
}instr_decoded_t;

// careful: last two bit 11 (you can use first 5 bit if you want)
typedef enum logic [6:0] {
    LUI_TYPE    = 7'b0110111;
    AUIPC_TYPE  = 7'b0010111;
    JAL_TYPE    = 7'b0010111;
    JALR_TYPE   = 7'B1100111;
    B_TYPE      = 7'b1100011;
    L_TYPE      = 7'b0000011;
    S_TYPE      = 7'b0100011;
    ALU_I_TYPE  = 7'b0010011;
    ALU_TYPE    = 7'b0110011;
    FENCE_TYPE  = 7'b0001111;
    CSR_TYPE    = 7'b1110011;
} instr_types_e;

// internal, decoded opcodes
typedef enum logic [4:0] {
    LUI,
    AUIPC,
    JAL,
    JALR,
    BEQ,
    BNE,
    BLT,
    BGE,
    BLTU,
    BGEU,
    LOAD,
    STORE,
    ADD,
    SUB,
    SLT,
    SLTU,
    XOR,
    OR,
    AND,
    SL,
    SRL,
    SRA,
    FENCE,
    FENCE_I,
    ECALL,
    EBREAK,
    MRET,
    WFI,
    CSRRW,
    CSRRS,
    CSRRC,
    INVALID
} operation_e;

// CSR addresses
typedef enum logic [11:0] {
    CYCLE     = 12'hC00,
    TIME      = 12'hC01,
    INSTRET   = 12'hC02,
    CYCLEH    = 12'hC80,
    TIMEH     = 12'hC81,
    INSTRETH  = 12'hC82,

    MISA      = 12'hF10,
    MVENDORID = 12'hF11,
    MARCHID   = 12'hF12,
    MIMPID    = 12'hF13,
    MHARTID   = 12'hF14,

    MSTATUS   = 12'h300,
    MEDELEG   = 12'h302,
    MIDELEG   = 12'h303,
    MIE       = 12'h304,
    MTVEC     = 12'h305,

    MSCRATCH  = 12'h340,
    MEPC      = 12'h341,
    MCAUSE    = 12'h342,
    MBADADDR  = 12'h343,
    MIP       = 12'h344,

    MCYCLE    = 12'hF00,
    MTIME     = 12'hF01,
    MINSTRET  = 12'hF02,
    MCYCLEH   = 12'hF80,
    MTIMEH    = 12'hF81,
    MINSTRETH = 12'hF82,

    // non-standard but we don't want to memory-map mtimecmp
    MTIMECMP  = 12'h7C1,
    MTIMECMPH = 12'h7C2,

    // provisional debug CSRs
    DCSR      = 12'h7B0,
    DPC       = 12'h7B1,
    DSCRATCH  = 12'h7B2
} csr_e;
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
    LUI_TYPE    = 7'b0110111,
    AUIPC_TYPE  = 7'b0010111,
    JAL_TYPE    = 7'b0010111,
    JALR_TYPE   = 7'B1100111,
    B_TYPE      = 7'b1100011,
    L_TYPE      = 7'b0000011,
    S_TYPE      = 7'b0100011,
    ALU_I_TYPE  = 7'b0010011,
    ALU_TYPE    = 7'b0110011,
    FENCE_TYPE  = 7'b0001111,
    CSR_TYPE    = 7'b1110011
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

// all the funct3 codes

typedef enum logic [2:0] {
    F3_ADDSUB = 3'b000,
    F3_SLT    = 3'b010,
    F3_SLTU   = 3'b011,
    F3_XOR    = 3'b100,
    F3_OR     = 3'b110,
    F3_AND    = 3'b111,
    F3_SLL    = 3'b001,
    F3_SR     = 3'b101
} funct3_op_t;

typedef enum logic [2:0] {
    F3_BEQ  = 3'b000,
    F3_BNE  = 3'b001,
    F3_BLT  = 3'b100,
    F3_BGE  = 3'b101,
    F3_BLTU = 3'b110,
    F3_BGEU = 3'b111
} funct3_branch_t;

typedef enum logic [2:0] {
    F3_LB  = 3'b000,
    F3_LH  = 3'b001,
    F3_LW  = 3'b010,
    F3_LBU = 3'b100,
    F3_LHU = 3'b101
} funct3_load_t;

typedef enum logic [2:0] {
    F3_SB  = 3'b000,
    F3_SH  = 3'b001,
    F3_SW  = 3'b010
} funct3_store_t;

typedef enum logic [2:0] {
    F3_FENCE  = 3'b000,
    F3_FENCEI = 3'b001
} funct3_misc_mem_t;

typedef enum logic [2:0] {
    F3_CSRRW  = 3'b001,
    F3_CSRRS  = 3'b010,
    F3_CSRRC  = 3'b011,
    F3_CSRRWI = 3'b101,
    F3_CSRRSI = 3'b110,
    F3_CSRRCI = 3'b111,
    F3_PRIV   = 3'b000
} funct3_system_t;

// non-immediate part of the system funct3 codes
typedef enum logic [1:0] {
    F2_PRIV  = 2'b00,
    F2_CSRRW = 2'b01,
    F2_CSRRS = 2'b10,
    F2_CSRRC = 2'b11
} funct2_system_t;

// machine mode funct12 codes
typedef enum logic [11:0] {
    F12_ECALL  = 12'b000000000000,
    F12_EBREAK = 12'b000000000001,
    F12_MRET   = 12'b001100000010,
    F12_WFI    = 12'b000100000101
} funct12_t;


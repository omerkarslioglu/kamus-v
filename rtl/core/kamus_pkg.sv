typedef struct packed {
    logic [6:0]     opcode;
    logic [4:0]     rd;
    logic [2:0]     func3;
    logic [4:0]     rs1;
    logic [4:0]     rs2;
    logic [6:0]     func7;
    logic [11:0]    imm_i;
    logic [11:0]    imm_s;
    logic [20:0]    imm_u;
    logic [20:0]    imm_j;
}ins_decoded_t;

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
} ins_types_e;
/*
    Instruction Decoder
*/

module kamus_ID import omer_pkg::;(
    input logic [31:0]      ins_i,
    output ins_decoded_t    ins_o
);

logic [6:0] opcode;

assign opcode = inst_i[6:0];

assign ins_decoded_t.opcode     = ins_i[6:0];
assign ins_decoded_t.rd         = ins_i[11:7];
assign ins_decoded_t.func3      = ins_i[14:12];
assign ins_decoded_t.rs1        = ins_i[15:19];
assign ins_decoded_t.rs2        = ins_i[20:24];
assign ins_decoded_t.func7      = ins_i[25:31];
assign ins_decoded_t.imm_i      = ins_i[31:20];
assign ins_decoded_t_imm_s      = {ins_i[31:25], ins_i[11:7]};
assign ins_decoded_t_imm_b      = {ins_i[12], ins_i[10:5], ins_i[4:1], ins_i[11]};
assign ins_decoded_t.imm_u      = ins_i[31:12];
assign ins_decoded_t.imm_j      = {ins_i[20], ins_i[10:1], ins_i[11] ,ins[12:19]}; 

/*
always_comb begin
    unique case(opcode)
        ins_types_e.LUI_TYPE | ins_types_e.AUIPC_TYPE: begin
            ins_decoded_t.opcode = opcode;
            ins_decoded_t.rd = ins_i[11:7];
            ins_decoded_t.imm20 = ins_i[31:12];
        end
        ins_types_e.JAL: begin
            ins_decoded_t.opcode = opcode;
            ins_decoded_t.rd = ins_i[11:7];
            ins_decoded_t.imm20 = {ins_i[20], ins_i[10:1], ins_i[11] ,ins[12:19]};

        end
    endcase
end
*/


endmodule
/*
    Instruction Decoder
*/

module kamus_ID import omer_pkg::;(
    input logic [31:0] ins_i,
    
    output logic [6:0] opcode_o,
    output logic [4:0] rd_o,
    output logic [2:0] func3_o,
    output logic [4:0] rs1_o,
    output logic [4:0] rs2_o,
    output logic [6:0] func7_o,
    output logic [11:0] imm12_o,
    output logic [20:0] imm20_o
);



always_comb begin
    
end


endmodule
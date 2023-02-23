module kamus_core(
    input logic clk_i, rst_ni,
    
    // Interface with $L1I
    input logic [31:0]  l1i_instr_data_i,
    output logic [31:0] l1i_instr_addr_o,
);

// IF/ID FlipFlop IOs
logic [31:0]    instr_data_IFID_reg_d;
logic [31:0]    instr_data_IFID_reg_q;
logic [31:0]    instr_addr_IFID_reg_q;

// ID-RegFile Wires
logic [31:0]    rs1_data_wire;
logic [31:0]    rs2_data_wire;
logic [4:0]     rs1_addr_wire;
logic [4:0]     rs2_addr_wire;
logic [4:0]     rd_addr_wire;

kamus_IF #(
    BOOT_ADDR = 32'h0
)
kamus_IF_sub
(
    .clk_i(clk_i),
    .rst_ni(rst_ni),
    .instr_data_i(l1i_instr_data_i),            // comes from $L1I
    .instr_imm_addr_i(),                        // comes from ID (for jump and branch)
    .instr_addr_sel_i(),                        // for pc value selector mux (according to jal, branch etc.)

    .instr_data_o(instr_data_IFID_reg_d),       // just wire that connected to ID
    .instr_addr_o(l1i_instr_addr_o)             // instr_addr = pc
);

kamus_ID #(
    PC_WIDTH = 32
)
kamus_ID_sub
(
    .clk_i(clk_i), 
    .rst_ni(rst_ni),
    .instr_i(instr_data_IFID_reg_q),
    .instr_addr_i(instr_addr_IFID_reg_q),        // comes from fetch stage: kamus_IF (instr_addr)
    .imm_instr_addr_o()// kafam yandı arkadaş j-type lara dikkat
    .instr_o(),
    .rs1_data_o(),
    .rs2_data_o(),
    
    // -- RegisterFile Interface:
    .rs1_data_i(rs1_data_wire),
    .rs2_data_i(rs2_data_wire),
    .rs1_addr_o(rs1_addr_wire),
    .rs2_addr_o(rs2_addr_wire),
    .rd_addr_o(rd_addr_wire)
    // --
);

register_file(
    .clk_i(clk_i), 
    .rst_ni(rst_ni),
    .reg_wr_en(),
    .rs1_addr_i(rs1_addr_wire),             // source1 register addr
    .rs2_addr_i(rs2_addr_wire),                            // source2 register addr
    .rd_addr_i(rd_addr_wire),                             // destination reister addr
    .wr_data_i(),                         // write data
    .rs1_data_o(rs1_data_wire),        // read data1
    .rs2_data_o(rs2_data_wire)         // read data2
);

// IF/ID FlipFLop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        instr_data_IFID_reg_q   <= 32'b0;
        instr_addr_IFID_reg_q   <= 32'b0;
    end else begin
        instr_data_IFID_reg_q   <= instr_data_IFID_reg_d;
        instr_addr_IFID_reg_q   <= l1i_instr_addr_o;
    end
end



endmodule
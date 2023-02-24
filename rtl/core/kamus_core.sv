import kamus_pkg::*;

module kamus_core(
    input logic clk_i, rst_ni,
    
    // Interface with $L1I
    input logic [31:0]  l1i_instr_data_i,
    output logic [31:0] l1i_instr_addr_o,
);

// IF/ID FlipFlop IOs
logic [31:0]    instr_data_ifid_d;
logic [31:0]    instr_data_ifid_q;
logic [31:0]    instr_addr_ifid_q;

// ID-RegFile Wires
logic [31:0]    rs1_data_wire;
logic [31:0]    rs2_data_wire;
logic [4:0]     rs1_addr_wire;
logic [4:0]     rs2_addr_wire;
logic [4:0]     rd_addr_wire;

// ID/EX FlipFlop IOs
instr_decoded_t instr_idex_d;
instr_decoded_t instr_idex_q;
logic [31:0]    rs1_data_idex_q;
logic [31:0]    rs2_data_idex_q;
logic [31:0]    rs1_data_idex_d;
logic [31:0]    rs2_data_idex_d;

// EX/MEM FlipFlop IOs
logic [4:0]     operation_exmem_d;
logic [4:0]     operation_exmem_q;
logic [31:0]    ex_rslt_exmem_d;
logic [31:0]    ex_rslt_exmem_q;


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

    .instr_data_o(instr_data_ifid_d),           // just wire that connected to ID
    .instr_addr_o(l1i_instr_addr_o)             // instr_addr = pc
);

kamus_ID #(
    PC_WIDTH = 32
)
kamus_ID_sub
(
    .clk_i(clk_i), 
    .rst_ni(rst_ni),
    .instr_i(instr_data_ifid_q),
    .instr_addr_i(instr_addr_ifid_q),           // comes from fetch stage: kamus_IF (instr_addr)
    .imm_instr_addr_o()                         // kafam yandı arkadaş j-type lara dikkat
    .instr_o(instr_idex_d),
    .rs1_data_o(rs1_data_idex_d),
    .rs2_data_o(rs2_data_idex_d),
    
    // -- RegisterFile Interface:
    .rs1_data_i(rs1_data_wire),
    .rs2_data_i(rs2_data_wire),
    .rs1_addr_o(rs1_addr_wire),
    .rs2_addr_o(rs2_addr_wire),
    .rd_addr_o(rd_addr_wire)
    // --
);

kamus_EX kamus_EX_sub(
    .instr_i(instr_idex_q),
    .rs1_data_i(rs1_data_idex_q),
    .rs2_data_i(rs2_data_idex_q),

    .operation_o(operation_exmem_d),
    .ex_o(ex_rslt_exmem_d)
);

register_file(
    .clk_i(clk_i), 
    .rst_ni(rst_ni),
    .reg_wr_en_i(),
    .wr_data_i(),                                           // write data
    .rs1_addr_i(rs1_addr_wire),                             // source1 register addr
    .rs2_addr_i(rs2_addr_wire),                             // source2 register addr
    .rd_addr_i(rd_addr_wire),                               // destination reister addr                  
    .rs1_data_o(rs1_data_wire),                             // read data1
    .rs2_data_o(rs2_data_wire)                              // read data2
);

// IF/ID FlipFLop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        instr_data_ifid_q               <= 32'b0;
        instr_addr_ifid_q               <= 32'b0;
    end else begin          
        instr_data_ifid_q               <= instr_data_ifid_d;
        instr_addr_ifid_q               <= l1i_instr_addr_o;
    end
end

// ID/EX FlipFLop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        instr_idex_q.immediate              <= 32'b0;
        instr_idex_q.immediate_used         <= 1'b0;
        instr_idex_q.funcr12                <= 12'b0;
        instr_idex_q.pc                     <= 32'b0;
        instr_idex_q.operation              <= 6'b0;
        instr_idex_q.memory_width           <= 2'b0;

        rs1_data_idex_q                     <= 32'b0;
        rs2_data_idex_q                     <= 32'b0;
    end else begin
        instr_idex_q                        <= instr_idex_d;
        rs1_data_idex_q                     <= rs1_data_idex_d;
        rs1_data_idex_q                     <= rs1_data_idex_d;
    end
end

// EX/MEM FlipFlop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        operation_exmem_q                   <= 5'b0;
        ex_rslt_exmem_q                     <= 32'b0;
    end else begin
        operation_exmem_q                   <= operation_exmem_d;
        ex_rslt_exmem_q                     <= ex_rslt_exmem_d;
    end
end

endmodule
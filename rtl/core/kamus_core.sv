import kamus_pkg::*;

module kamus_core(
    input logic clk_i, rst_ni,
    
    // Interface with $L1I
    input logic [31:0]  l1i_instr_data_i,
    output logic [31:0] l1i_instr_addr_o,

    // Interface with $L1D
    input logic [31:0] l1d_rd_data_i,
    output logic l1d_wr_en_o,
    output logic [31:0] l1d_addr_o,
    output logic [31:0] l1d_wr_data_o
);

// IF/ID FlipFlop IOs
logic [31:0]            instr_data_ifid_d;
logic [31:0]            next_pc_ifid_d;

logic [31:0]            instr_data_ifid_q;
logic [31:0]            instr_addr_ifid_q;
logic [31:0]            next_pc_ifid_q;

// ID/EX FlipFlop IOs
instr_decoded_t         instr_idex_d;
logic [31:0]            rs1_data_idex_d;
logic [31:0]            rs2_data_idex_d;
logic [4:0]             rd_addr_idex_d;
logic                   l1d_wr_en_idex_d; 
logic                   regfile_wr_en_idex_d;
logic [1:0]             wb_mux_sel_idex_d;
logic [31:0]            next_pc_idex_d;
instr_addr_sel_state_e  instr_addr_sel_idex_d;

instr_decoded_t         instr_idex_q;
logic [31:0]            rs1_data_idex_q;
logic [31:0]            rs2_data_idex_q;
logic [4:0]             rd_addr_idex_q;
logic                   l1d_wr_en_idex_q;    
logic                   regfile_wr_en_idex_q;
logic [1:0]             wb_mux_sel_idex_q;
logic [31:0]            next_pc_idex_q;
instr_addr_sel_state_e  instr_addr_sel_idex_q;

// EX/MEM FlipFlop IOs
logic [4:0]             operation_exmem_d;
logic [31:0]            ex_rslt_exmem_d;
logic [31:0]            rs2_data_exmem_d;
logic [4:0]             rd_addr_exmem_d;
logic                   l1d_wr_en_exmem_d;
logic                   regfile_wr_en_exmem_d;
logic [1:0]             wb_mux_sel_exmem_d;
logic [31:0]            next_pc_exmem_d;
logic                   is_branch_taken_exmem_d;
instr_addr_sel_state_e  instr_addr_sel_exmem_d;

logic [4:0]             operation_exmem_q;
logic [31:0]            ex_rslt_exmem_q;
logic [31:0]            rs2_data_exmem_q;
logic [4:0]             rd_addr_exmem_q;
logic                   l1d_wr_en_exmem_q;    
logic                   regfile_wr_en_exmem_q;
logic [1:0]             wb_mux_sel_exmem_q;
logic [31:0]            next_pc_exmem_q;
logic                   is_branch_taken_exmem_q;
instr_addr_sel_state_e  instr_addr_sel_exmem_q;

// MEM/WB FlipFlop IOs
logic                   regfile_wr_en_memwb_d;
logic [31:0]            ex_rslt_memwb_d;
logic [31:0]            l1d_rd_data_memwb_d;
logic [1:0]             wb_mux_sel_memwb_d;
logic [4:0]             rd_addr_memwb_reg_d;
logic [31:0]            next_pc_memwb_d;
logic                   is_branch_taken_memwb_d;
instr_addr_sel_state_e  instr_addr_sel_memwb_d;

logic                   regfile_wr_en_memwb_q;
logic [31:0]            ex_rslt_memwb_q;
logic [31:0]            l1d_rd_data_memwb_q;
logic [1:0]             wb_mux_sel_memwb_q;
logic [4:0]             rd_addr_memwb_reg_q;
logic [31:0]            next_pc_memwb_q;
logic                   is_branch_taken_memwb_q;
instr_addr_sel_state_e  instr_addr_sel_memwb_q;

// WB/IF FlipFlops
logic [31:0]            ex_rslt_o_wbif_d;
logic                   is_branch_taken_wbif_d;
instr_addr_sel_state_e  instr_addr_sel_wbif_d;

logic [31:0]            ex_rslt_o_wbif_q;
logic                   is_branch_taken_wbif_q;
instr_addr_sel_state_e  instr_addr_sel_wbif_q;

// ID-RegFile Wires
logic [31:0]            rs1_data_wire;
logic [31:0]            rs2_data_wire;
logic [4:0]             rs1_addr_wire;
logic [4:0]             rs2_addr_wire;

// WB-RegFile Wires
logic                   regfile_wr_en_wire;
logic [4:0]             rd_addr_wire;
logic [31:0]            wb_data_wire;

// Control Unit Wires
control_unit_t          control_unit_input_wire;
control_unit_t          control_unit_output_wire;

// FlipFlop Q Wires
logic [31:0]            instr_data_ifid_q_wire;
logic [31:0]            instr_addr_ifid_q_wire;
logic [31:0]            next_pc_ifid_q_wire;
instr_decoded_t         instr_idex_q_wire;
logic [31:0]            rs1_data_idex_q_wire;
logic [31:0]            rs2_data_idex_q_wire;
logic [4:0]             rd_addr_idex_q_wire;
logic                   l1d_wr_en_idex_q_wire;
logic                   regfile_wr_en_idex_q_wire;
logic [1:0]             wb_mux_sel_idex_q_wire;
logic [31:0]            next_pc_idex_q_wire;
instr_addr_sel_state_e  instr_addr_sel_idex_q_wire;
logic [4:0]             operation_exmem_q_wire;
logic [31:0]            ex_rslt_exmem_q_wire;
logic [31:0]            rs2_data_exmem_q_wire;
logic [4:0]             rd_addr_exmem_q_wire;
logic                   l1d_wr_en_exmem_q_wire;
logic                   regfile_wr_en_exmem_q_wire;
logic [1:0]             wb_mux_sel_exmem_q_wire;
logic [31:0]            next_pc_exmem_q_wire;
logic                   is_branch_taken_exmem_q_wire;
instr_addr_sel_state_e  instr_addr_sel_exmem_q_wire;
logic                   regfile_wr_en_memwb_q_wire;
logic [31:0]            ex_rslt_memwb_q_wire;
logic [31:0]            l1d_rd_data_memwb_q_wire;
logic [1:0]             wb_mux_sel_memwb_q_wire;
logic [4:0]             rd_addr_memwb_reg_q_wire;
logic [31:0]            next_pc_memwb_q_wire;
logic                   is_branch_taken_memwb_q_wire;
instr_addr_sel_state_e  instr_addr_sel_memwb_q_wire;
logic [31:0]            ex_rslt_o_wbif_q_wire;
logic                   is_branch_taken_wbif_q_wire;
instr_addr_sel_state_e  instr_addr_sel_wbif_q_wire;

assign instr_data_ifid_q_wire               = instr_data_ifid_q;
assign instr_addr_ifid_q_wire               = instr_addr_ifid_q;
assign next_pc_ifid_q_wire                  = next_pc_ifid_q;
assign instr_idex_q_wire                    = instr_idex_q;
assign rs1_data_idex_q_wire                 = rs1_data_idex_q;
assign rs2_data_idex_q_wire                 = rs2_data_idex_q;
assign rd_addr_idex_q_wire                  = rd_addr_idex_q;
assign l1d_wr_en_idex_q_wire                = l1d_wr_en_idex_q; 
assign regfile_wr_en_idex_q_wire            = regfile_wr_en_idex_q;
assign wb_mux_sel_idex_q_wire               = wb_mux_sel_idex_q;
assign next_pc_idex_q_wire                  = next_pc_idex_q;
assign instr_addr_sel_idex_q_wire           = instr_addr_sel_idex_q;
assign operation_exmem_q_wire               = operation_exmem_q;
assign ex_rslt_exmem_q_wire                 = ex_rslt_exmem_q;
assign rs2_data_exmem_q_wire                = rs2_data_exmem_q;
assign rd_addr_exmem_q_wire                 = rd_addr_exmem_q;
assign l1d_wr_en_exmem_q_wire               = l1d_wr_en_exmem_q;
assign regfile_wr_en_exmem_q_wire           = regfile_wr_en_exmem_q;
assign wb_mux_sel_exmem_q_wire              = wb_mux_sel_exmem_q;
assign next_pc_exmem_q_wire                 = next_pc_exmem_q;
assign is_branch_taken_exmem_q_wire         = is_branch_taken_exmem_q;
assign instr_addr_sel_exmem_q_wire          = instr_addr_sel_exmem_q;
assign regfile_wr_en_memwb_q_wire           = regfile_wr_en_memwb_q;
assign ex_rslt_memwb_q_wire                 = ex_rslt_memwb_q;
assign l1d_rd_data_memwb_q_wire             = l1d_rd_data_memwb_q;
assign wb_mux_sel_memwb_q_wire              = wb_mux_sel_memwb_q;
assign rd_addr_memwb_reg_q_wire             = rd_addr_memwb_reg_q;
assign next_pc_memwb_q_wire                 = next_pc_memwb_q;
assign is_branch_taken_memwb_q_wire         = is_branch_taken_memwb_q;
assign instr_addr_sel_memwb_q_wire          = instr_addr_sel_memwb_q;
assign ex_rslt_o_wbif_q_wire                = ex_rslt_o_wbif_q;
assign is_branch_taken_wbif_q_wire          = is_branch_taken_wbif_q;
assign instr_addr_sel_wbif_q_wire           = instr_addr_sel_wbif_q;


kamus_IF #(
    .BOOT_ADDR(32'b0)
)
kamus_IF_sub
(
    .clk_i              (clk_i),
    .rst_ni             (rst_ni),
    .flush_i            (),

    // WB-IF Interface:
    .ex_rslt_i          (ex_rslt_o_wbif_q_wire),                         // comes from EX->buffered->IF (for jump and branch) - Imm. Addr.
    .is_branch_taken_i  (is_branch_taken_wbif_q_wire),
    .instr_addr_sel_i   (instr_addr_sel_wbif_q_wire),                    // comes from ID(generated by c.u.)->EX(buffered)->MEM(buffered)->WB(used)for pc value selector mux (according to jal, branch etc.) - for pc value selector mux (according to jal, branch etc.)

    // L1I Interface:               
    .instr_data_i       (l1i_instr_data_i),                         // comes from $L1I
    .instr_addr_o       (l1i_instr_addr_o),                         // instr_addr = target pc (for $l1i)

    // IF-ID Interface:
    //instr_addr_o       is defined           
    .instr_data_o       (instr_data_ifid_d),                        // just wire that connected to ID
    .next_pc_o          (next_pc_ifid_d)                            // next = pc+4
);

kamus_ID #(
    .PC_WIDTH(32)
)
kamus_ID_sub
(
    // IF-ID Interface
    .instr_i            (instr_data_ifid_q_wire),
    .instr_addr_i       (instr_addr_ifid_q_wire),                        // comes from fetch stage: kamus_IF (instr_addr)
    .next_pc_i          (next_pc_ifid_q_wire),
    
    //  ID-EX Interface
    .instr_o            (instr_idex_d),
    .rs1_data_o         (rs1_data_idex_d),
    .rs2_data_o         (rs2_data_idex_d),
    .next_pc_o          (next_pc_idex_d),
        // Comes From Controller Unit
    .instr_addr_sel_o   (instr_addr_sel_idex_d),
    .wb_mux_sel_o       (wb_mux_sel_idex_d),
    .l1d_wr_en_o        (l1d_wr_en_idex_d),
    .regfile_wr_en_o    (regfile_wr_en_idex_d),
    
    // RegisterFile Interface:
    .rs1_data_i         (rs1_data_wire),
    .rs2_data_i         (rs2_data_wire),
    .rs1_addr_o         (rs1_addr_wire),
    .rs2_addr_o         (rs2_addr_wire),
    .rd_addr_o          (rd_addr_idex_d),

    // Control Unit Interface
    .control_unit_output_i(control_unit_output_wire),
    .control_unit_input_o(control_unit_input_wire)
);

kamus_EX kamus_EX_sub(
    // ID-EX Insterface:
    .instr_i            (instr_idex_q_wire),
    .rs1_data_i         (rs1_data_idex_q_wire),
    .rs2_data_i         (rs2_data_idex_q_wire),
    .rd_addr_i          (rd_addr_idex_q_wire),
    .next_pc_i          (next_pc_idex_q_wire),
        // Buffered Control Signals:
    .instr_addr_sel_i   (instr_addr_sel_idex_q_wire),
    .wb_mux_sel_i       (wb_mux_sel_idex_q_wire),
    .l1d_wr_en_i        (l1d_wr_en_idex_q_wire),
    .regfile_wr_en_i    (regfile_wr_en_idex_q_wire),

    // EX-MEM Interface:
    .operation_o        (operation_exmem_d),
    .ex_o               (ex_rslt_exmem_d),
    .is_branch_taken_o  (is_branch_taken_exmem_d),
    .rs2_data_o         (rs2_data_exmem_d),
    .rd_addr_o          (rd_addr_exmem_d),
    .next_pc_o          (next_pc_exmem_d),
        // Buffered Control Signals:
    .instr_addr_sel_o   (instr_addr_sel_exmem_d),
    .wb_mux_sel_o       (wb_mux_sel_exmem_d),
    .l1d_wr_en_o        (l1d_wr_en_exmem_d),  
    .regfile_wr_en_o    (regfile_wr_en_exmem_d)
);

kamus_MEM kamus_MEM_sub(
    .clk_i              (clk_i), 
    .rst_ni             (rst_ni),
    // EX-MEM Interface:
    .rs2_data_i         (rs2_data_exmem_q_wire),                         // rs2 values: ID(gen)->EX(buff)->MEM(used) (when store command taken)
    .ex_rslt_i          (ex_rslt_exmem_q_wire),                          // ALU rslt: EX(gen)->MEM(used)
    .rd_addr_i          (rd_addr_exmem_q_wire),                          // rd address input: ID(gen)->EX(buff)->MEM(buff)->WB(used)
    .operation_i        (operation_exmem_q_wire),
    .next_pc_i          (next_pc_exmem_q_wire),
    .is_branch_taken_i  (is_branch_taken_exmem_q_wire),
        // comes from EX but they are related with Control Unit:
    .l1d_wr_en_i        (l1d_wr_en_exmem_q_wire),                        // from exmem ff
    .regfile_wr_en_i    (regfile_wr_en_exmem_q_wire),                    // from exmem ff
    .wb_mux_sel_i       (wb_mux_sel_exmem_q_wire),                       // from exmem ff
    .instr_addr_sel_i   (instr_addr_sel_exmem_q_wire),

    // MEM-WB Interface:
    .regfile_wr_en_o    (regfile_wr_en_memwb_d),  
    .ex_rslt_o          (ex_rslt_memwb_d),                          // the data0 that will be saved to regFile (and in MEM/WB register)
    .l1d_rd_data_o      (l1d_rd_data_memwb_d),                      // the data1 that will be saved to regFile (and in MEM/WB register)
    .wb_mux_sel_o       (wb_mux_sel_memwb_d),               
    .rd_addr_o          (rd_addr_memwb_reg_d),                      // rd address output:  ID(gen)->EX(buff)->MEM(buff)->WB(used)
    .next_pc_o          (next_pc_memwb_d),
    .is_branch_taken_o  (is_branch_taken_memwb_d),
    .instr_addr_sel_o   (instr_addr_sel_memwb_d),
    
    // $L1D Interface
    .l1d_rd_data_i      (l1d_rd_data_i),          
    .l1d_wr_en_o        (l1d_wr_en_o),                              // comes from from kamus_EX
    .l1d_addr_o         (l1d_addr_o),                               // comes from from kamus_EX
    .l1d_wr_data_o      (l1d_wr_data_o)
);

kamus_WB kamus_WB_sub(
    // MEM-WB Interface:
    .regfile_wr_en_i    (regfile_wr_en_memwb_q_wire),
    .ex_rslt_i          (ex_rslt_memwb_q_wire),                          // the data0 that will be saved to regFile (and in MEM/WB register)
    .l1d_rd_data_i      (l1d_rd_data_memwb_q_wire),                      // the data1 that will be saved to regFile (and in MEM/WB register)
    .wb_mux_sel_i       (wb_mux_sel_memwb_q_wire),
    .rd_addr_i          (rd_addr_memwb_reg_q_wire),
    .next_pc_i          (next_pc_memwb_q_wire),
    .is_branch_taken_i  (is_branch_taken_memwb_q_wire),
    .instr_addr_sel_i   (instr_addr_sel_memwb_q_wire),
    
    // WB-IF Interface:
    .is_branch_taken_o  (is_branch_taken_wbif_d),
    .ex_rslt_o          (ex_rslt_o_wbif_d),
    .instr_addr_sel_o   (instr_addr_sel_wbif_d),
    
    // WB-RegFile Interface
    .regfile_wr_en_o    (regfile_wr_en_wire),
    .wb_data_o          (wb_data_wire),
    .rd_addr_o          (rd_addr_wire)
);

register_file(
    .clk_i              (clk_i), 
    .rst_ni             (rst_ni),
    .reg_wr_en_i        (regfile_wr_en_wire),
    .wr_data_i          (wb_data_wire),
    .rd_addr_i          (rd_addr_wire),                             
    .rs1_addr_i         (rs1_addr_wire),                            // source1 register addr
    .rs2_addr_i         (rs2_addr_wire),                            // source2 register addr                
    .rs1_data_o         (rs1_data_wire),                            // read data1
    .rs2_data_o         (rs2_data_wire)                             // read data2
);

kamus_CU(
    .control_unit_i(control_unit_input_wire),                       // comes from just instr_type (or operation)
    .control_unit_o(control_unit_output_wire)
);

// IF-ID FlipFLop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        instr_data_ifid_q                   <= 32'b0;
        instr_addr_ifid_q                   <= 32'b0;
        next_pc_ifid_q                      <= 32'b0;
    end else begin              
        instr_data_ifid_q                   <= instr_data_ifid_d;
        instr_addr_ifid_q                   <= l1i_instr_addr_o;
        next_pc_ifid_q                      <= next_pc_ifid_d;
    end
end

// ID-EX FlipFLop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        instr_idex_q.immediate              <= 32'b0;
        instr_idex_q.immediate_used         <= 1'b0;
        instr_idex_q.funct12                <= F12_ECALL;
        instr_idex_q.pc                     <= 32'b0;
        instr_idex_q.operation              <= INVALID;
        instr_idex_q.memory_width           <= W;
        rs1_data_idex_q                     <= 32'b0;
        rs2_data_idex_q                     <= 32'b0;
        next_pc_idex_q                      <= 32'b0;
        instr_addr_sel_idex_q               <= PC_ST;//2'b01;
        wb_mux_sel_idex_q                   <= ALU_RESULT; // 2'b00
        l1d_wr_en_idex_q                    <= 1'b0;
        regfile_wr_en_idex_q                <= 1'b0;
    end else begin
        instr_idex_q                        <= instr_idex_d;
        rs1_data_idex_q                     <= rs1_data_idex_d;
        rs1_data_idex_q                     <= rs1_data_idex_d;
        rd_addr_idex_q                      <= rd_addr_idex_d;
        next_pc_idex_q                      <= next_pc_idex_d;
        instr_addr_sel_idex_q               <= instr_addr_sel_idex_d;
        wb_mux_sel_idex_q                   <= wb_mux_sel_idex_d;
        l1d_wr_en_idex_q                    <= l1d_wr_en_idex_d;
        regfile_wr_en_idex_q                <= regfile_wr_en_idex_d;
    end
end

// EX-MEM FlipFlop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        operation_exmem_q                   <= 4'b0;
        ex_rslt_exmem_q                     <= 32'b0;
        rs2_data_exmem_q                    <= 32'b0;
        rd_addr_exmem_q                     <= 5'b0;
        l1d_wr_en_exmem_q                   <= 1'b0;  
        regfile_wr_en_exmem_q               <= 1'b0;
        wb_mux_sel_exmem_q                  <= 2'b0;
        next_pc_exmem_q                     <= 32'b0;
        is_branch_taken_exmem_q             <= 1'b0;
        instr_addr_sel_exmem_q              <= PC_ST;
    end else begin
        operation_exmem_q                   <= operation_exmem_d;    
        ex_rslt_exmem_q                     <= ex_rslt_exmem_d;      
        rs2_data_exmem_q                    <= rs2_data_exmem_d;     
        rd_addr_exmem_q                     <= rd_addr_exmem_d;      
        l1d_wr_en_exmem_q                   <= l1d_wr_en_exmem_d;    
        regfile_wr_en_exmem_q               <= regfile_wr_en_exmem_d;
        wb_mux_sel_exmem_q                  <= wb_mux_sel_exmem_d;
        next_pc_exmem_q                     <= next_pc_exmem_d;
        is_branch_taken_exmem_q             <= is_branch_taken_exmem_d;
        instr_addr_sel_exmem_q              <= instr_addr_sel_exmem_d;
    end
end

// MEM-WB FlipFlop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        regfile_wr_en_memwb_q               <= 1'b0;
        ex_rslt_memwb_q                     <= 32'b0;
        l1d_rd_data_memwb_q                 <= 32'b0;
        wb_mux_sel_memwb_q                  <= 2'b0;
        rd_addr_memwb_reg_q                 <= 5'b0;
        next_pc_memwb_q                     <= 32'b0;
        is_branch_taken_memwb_q             <= 1'b0;
        instr_addr_sel_memwb_q              <= PC_ST;
    end else begin
        regfile_wr_en_memwb_q               <= regfile_wr_en_memwb_d;
        ex_rslt_memwb_q                     <= ex_rslt_memwb_d;    
        l1d_rd_data_memwb_q                 <= l1d_rd_data_memwb_d;
        wb_mux_sel_memwb_q                  <= wb_mux_sel_memwb_d;
        rd_addr_memwb_reg_q                 <= rd_addr_memwb_reg_d;
        next_pc_memwb_q                     <= next_pc_memwb_d;
        is_branch_taken_memwb_q             <= is_branch_taken_memwb_d;
        instr_addr_sel_memwb_q              <= instr_addr_sel_memwb_d;
    end
end

// WB-IF FllipFlop
always_ff @(posedge clk_i) begin
    if(~rst_ni) begin
        ex_rslt_o_wbif_q                    <= 32'b0;
        is_branch_taken_wbif_q              <= 1'b0;
        instr_addr_sel_wbif_q               <= PC_ST;;
    end else begin
        ex_rslt_o_wbif_q                    <= ex_rslt_o_wbif_d;        
        is_branch_taken_wbif_q              <= is_branch_taken_wbif_d;
        instr_addr_sel_wbif_q               <= instr_addr_sel_wbif_d;
    end
end
endmodule
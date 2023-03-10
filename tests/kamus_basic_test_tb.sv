import kamus_pkg::*;

module kamsus_basic_test();

localparam  CLK_FREQ = 100_000_000;
real        CLK_PERIOD = (1.0/CLK_FREQ) * (10**9);

// Core Interface:
logic clk_i=1'b1, rst_ni;
logic [31:0] l1i_instr_data_i;
logic [31:0] l1i_instr_addr_o;

logic l1d_wr_en_o;
logic [31:0] l1d_addr_o;
logic [31:0] l1d_rd_data_i;
logic [31:0] l1d_wr_data_o;

// Buffers to Verify:
logic [31:0] pc_buff = 32'h00000000;

// Immadiate Number Data
logic [19:0] imm_val_20bit = 20'h00000;

// Random Register Address
logic [4:0] rs1_random_addr;
logic [4:0] rs2_random_addr;
logic [4:0] rd_random_addr;

kamus_core kamus_core_uut(.*);

always #(CLK_PERIOD/2.0)    clk_i <= ~clk_i; 

initial begin
    rst_ni  <= 1'b0;
    #(CLK_PERIOD*2)
    rst_ni  <= 1'b1;
    l1i_instr_data_i        = 32'b0;
    #(CLK_PERIOD*2)
    
    $display("\n\nINSTRUCTION TEST IS LOADING...\n");
    #(CLK_PERIOD*2)
    // Algorithm Start Here:
        // ALU Operations:
    l1i_instr_data_i        = 32'b000000000001_00000_000_00001_0010011;                     // addi rd1, rs0, 1;
    #(CLK_PERIOD*5)
    l1i_instr_data_i        = 32'b000000000010_00000_000_00010_0010011;                     // addi rd2, rs0, 2;
    #(CLK_PERIOD*5)
    l1i_instr_data_i        = 32'b000000000011_00000_000_00011_0010011;                     // addi rd3, rs0, 3;
    #(CLK_PERIOD*5)

        // Load Operations:
    l1d_rd_data_i           = 32'h0111111f;
    l1i_instr_data_i        = {12'b000000000001, 5'b00000, F3_LW, 5'b11111, L_TYPE};
    #(CLK_PERIOD*5)
    l1i_instr_data_i        = {12'b000000000011, 5'b00000, F3_LH, 5'b11111, L_TYPE};
    #(CLK_PERIOD*5)
    l1i_instr_data_i        = {12'b000000000111, 5'b00000, F3_LB, 5'b11111, L_TYPE};
    #(CLK_PERIOD*5)
    
        // Store Operations:
    l1i_instr_data_i        = {7'b0000000, 5'b00010, 5'b00001, F3_SW, 5'b00001, S_TYPE};
    #(CLK_PERIOD*5)
    assert(l1d_addr_o == 32'h00000002 && l1d_wr_data_o == 32'h00000002) $display("SW: TRUE");
    else $fatal("SW: FALSE");
    l1i_instr_data_i        = {7'b0000000, 5'b00010, 5'b00001, F3_SH, 5'b00001, S_TYPE};
    #(CLK_PERIOD*5)
    assert(l1d_addr_o == 32'h00000002 && l1d_wr_data_o == 32'h00000002) $display("SH: TRUE");
    else $fatal("SH: FALSE");
    l1i_instr_data_i        = {7'b0000000, 5'b00010, 5'b00001, F3_SB, 5'b00001, S_TYPE};
    #(CLK_PERIOD*5)
    assert(l1d_addr_o == 32'h00000002 && l1d_wr_data_o == 32'h00000002) $display("SB: TRUE");
    else $fatal("SB: FALSE");
    
        // Branch Operations
    l1i_instr_data_i        = {7'b0000000, 5'b11110, 5'b00000, F3_BEQ, 5'b11110, B_TYPE};
    pc_buff = l1i_instr_addr_o;
    #(CLK_PERIOD*5)
    assert(l1i_instr_addr_o == (32'b011110+pc_buff)) $display("BEQ: TRUE");
    else $fatal("BEQ: FALSE");

        // LUI Operation
    //rs1_random_addr         = $urandom_range(5'd31, 5'd2);
    //rs2_random_addr         = $urandom_range(5'd31, 5'd2);
    rd_random_addr          = $urandom_range(5'd31, 5'd2);
    imm_val_20bit           = $random();
    l1i_instr_data_i        = {imm_val_20bit, 5'b11101, LUI_TYPE};                                      // lui  $r29, 0x1;
    #(CLK_PERIOD*5) 
    l1i_instr_data_i        = {12'b000000000001, 5'b11101, F3_ADDSUB, rd_random_addr , ALU_I_TYPE};     // addi $random, $r29, 0x1;
    #(CLK_PERIOD*5)
    l1i_instr_data_i        = {12'b000000000001, 5'b00000, F3_ADDSUB, 5'b00001 , ALU_I_TYPE};           // addi r1, r0, 0x1;  # for store operation
    #(CLK_PERIOD*5)
    l1i_instr_data_i        = {7'b0000000, rd_random_addr, 5'b00001, F3_SW, 5'b00001, S_TYPE};          // sw   $random, $r1(0x1)  # to check
    #(CLK_PERIOD*5)
    assert(l1d_addr_o == 32'h00000002 && l1d_wr_data_o == {imm_val_20bit, 12'b01}) $display("LUI: TRUE");
    else $fatal("LUI: FALSE");
    
    $display("\nTEST IS COMPLETED SUCCESSFULLY!\n\n");
    $finish;
    
end

endmodule
module kamus_core(
    input logic clk_i, rst_ni,

    // Instruction interface
    input  logic [31:0] instr_data_i,
    //input  logic        instr_ack_i, 
    output logic [31:0] instr_addr_o,
    //output logic        instr_req_o, // always is 1'b1
    
    // Data interface
    //input  logic        data_ack,
    input  logic [31:0] data_rd_data,
    output logic [31:0] data_wr_data,
    output logic [31:0] data_addr,
    //output logic [3:0]  data_mask,
    output logic        data_wr_en,
    //output logic        data_req,
    
    // Interrupt sources
    input  logic        software_interrupt,
    input  logic        timer_interrupt,
    input  logic        external_interrupt
);



endmodule
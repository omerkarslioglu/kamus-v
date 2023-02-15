module register_file(
    input clk_i, rst_ni,

    input logic reg_wr_en,

    input logic rs1_addr_i,         // source1 register addr
    input logic rs2_addr_i,         // source2 register addr
    input logic rd_addr_i,          // destination reister addr
    
    input logic [31:0] wr_data_i,   // write data
    
    output logic rd_data1_o,        // read data1
    output logic rd_data2_o,        // read data2
    output logic zero_o
);

logic [31:0] registers [1:31];

// register write
always_ff(posedge clk_i) begin
    if(~rst_ni) begin
        // initial reset:
        for(int i = 1; i<32; i++) begin
            registers[i] <= 32'b0;
        end
    end else begin
        if(reg_wr_en) registers[rd_addr_i] <= wr_data_i;
    end
end

// read reg
always_ff(posedge clk_i) begin
    if(~rst_ni) begin
        rd_data1_o <= 32'b0;
        rd_data2_o <= 32'b0;
    end else begin
        rd_data1_o <= register[rs1_addr_i];
        rd_data2_o <= register[rs2_addr_i];        
    end
end

endmodule
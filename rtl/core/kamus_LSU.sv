import kamus_pkg::*;

module kamus_LSU(
    input [31:0]    mem_addr_i,     // comes from kamus_ID imm value
    input [31:0]    wr_data_i,      // comes from reg file
    
    output          mem_wr_data_o, reg_wr_data_o
);


// function automatic logic [3:0] compute_byte_enable(mem_width_t width, logic [1:0] word_offset);
//     unique case (width)
//         B: return 4'b0001 << word_offset; // selected LB
//         H: return 4'b0011 << word_offset; // selected LH
//         W: return 4'b1111 << word_offset; // selected LW
//         default: return 'x;
//     endcase
// endfunction


endmodule
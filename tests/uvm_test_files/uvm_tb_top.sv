`include "uvm_macros.svh"

import uvm_pkg::*;

module uvm_tb_top();

    base_intarface intf();   // instantiated our interface 

    // instantiate our design
    kamus_core dut(.*);

    // we need to use the set method to set the interface in the database
    initial begin
        // set method:
        uvm_config_db #(virtual base_interface)::set(null, "*", "intf", intf);
    end

    initial begin
        run_test("base_test");
    end

endmodule
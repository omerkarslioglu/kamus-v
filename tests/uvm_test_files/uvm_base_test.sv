`include "uvm_package.sv"

class base_test extends uvm_test;

    `uvm_component_utils(base_test) // to save base_test to uvm factory/library

    // constructor
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // main logic

    // methods
    // properties

endclass
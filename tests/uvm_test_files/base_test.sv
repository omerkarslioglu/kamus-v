`include "uvm_package.sv"

class base_test extends uvm_test;

    `uvm_component_utils(base_test) // to save base_test to uvm factory/library

    // instantiate classes
    base_env env; 

    // constructor
    function new(string name = "base_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // build phase
    function void build_phase(uvm_phase phase);
        // build other components
        // build env class here
        env = base_env::type_id::create("env", this); // factory create method (this is an static method to create an object)
    endfunction

    // build phase
    function void connect_phase(uvm_phase phase);
        // necesary connections
    endfunction

    // run phase
    task run_phase(uvm_phase phase);
        // main logic
    endtask


    // methods
    // properties

endclass
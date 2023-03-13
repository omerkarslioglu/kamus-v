class base_env extends uvm_env;

    `uvm_component_utils(base_env)

    // instantiate classes
    agent agnt;

    function new(string name = "base_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // build phase
    function void build_phase(uvm_phase phase);
        // build other components
        // build agent class
        agnt = base_agent::type_id::create("agnt", this); // factory create method (this is an static method to create an object)
    endfunction

    // connect phase
    function void connect_phase(uvm_phase phase);
        // necesary connections
    endfunction

    // run phase
    task run_phase(uvm_phase phase);
        // main logic
    endtask

endclass: base_env
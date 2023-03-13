class sequencer extends uvm_sequencer #(seq_item);

    `uvm_component_utils(sequencer)

    function new(string name = "sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // build phase
    function void build_phase(uvm_phase phase);
        // build other components
            // get method:
        uvm_config_db #(virtual base_interface)::get(null, "*", "intf", intf);
    endfunction

    // build phase
    function void connect_phase(uvm_phase phase);
        // necesary connections
    endfunction

    // run phase
    task run_phase(uvm_phase phase);
        // main logic
    endtask
endclass: sequencer
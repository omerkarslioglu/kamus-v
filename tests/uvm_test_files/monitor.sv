class monitor extends uvm_monitor;

    `uvm_component_utils(monitor)

    base_interface intf; // instantiate our interface
    seq_item pkg;

    uvm_analysis_port #(seq_item) mon_port;

    function new(string name = "monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // build phase
    function void build_phase(uvm_phase phase);
        // build other components
            // get method
        uvm_config_db #(virtual base_interface)::get(null, "*", "intf", intf);
        mon_port = new("Monitor Port", this);
    endfunction

    // build phase
    function void connect_phase(uvm_phase phase);
        // necesary connections
    endfunction

    // run phase
    task run_phase(uvm_phase phase);
        // main logic
    endtask

endclass: monitor
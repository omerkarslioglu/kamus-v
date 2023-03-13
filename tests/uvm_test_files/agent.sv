class agent extends uvm_agent;

    `uvm_component_utils(agent)

    // instantiate class
    sequencer seqr;
    driver drv;
    monitor mon;

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    // build phase
    function void build_phase(uvm_phase phase);
        // build other components
        // build sequencer, monitor, driver
        seqr    = sequencer::type_id::create("seqr", this);
        drvr    = driver::type_id::create("drvr", this);
        mon     = monitor::type_id::creare("mon", this);
    endfunction

    // connect phase
    function void connect_phase(uvm_phase phase);
        // necesary connections
            // seq_item_port comes from UVM lib.
        drv.seq_item_port.connect(seqr.seq_item_export); // driver <-> sequencer connection
    endfunction

    // run phase
    task run_phase(uvm_phase phase);
        // main logic
    endtask

endclass: agent
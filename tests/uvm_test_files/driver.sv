class driver extends uvm_driver #(seq_item);

    `uvm_component_utils(driver)

    base_interface intf; // instantiate our interface
    seq_item pkg    ;   

    // constructor
    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    // build phase
    function void build_phase(uvm_phase phase);
        // build other components
        pkg = seq_item::type_id.create("Our Packet");
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
        forever begin
            @(posedge intf.clk)
                eq_item_port.get_next_item(pkg);
                intf.input_1 <= pkg.input_1;
                intf.input_2 <= pkg.input_2;

                seq_item_port_item_done();
        end
    endtask

endclass: driver
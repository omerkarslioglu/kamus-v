/*
    Sequence Class
    @def: 
        - It is an object type class which will randomize the packet class and send it to the driver using the sequencer.
*/

class sequence1 extends uvm_sequence;
    
    `uvm_object_utils(sequence1)
    
    seq_item pkg;
    
    function new(string name "sequence1");
        super.new(name);
    endfunction

    // The sequence will take packet class and randomize it to create interesting scnarios.
    task body();
        pkg = seq_item::type_id::create("Our Package");

        // Stimulus
        repeat(10)
        begin
            start_item(pkg);
            pkg.randomize();
            finish_item(pkg);
        end

    endtask
    
endclass
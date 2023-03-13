/*
    Sequence Item
    @def: 
        - It is an object class
        - It is also called data or package class.
        - It contains information of the variables that driver needs in order to execute pin level transactions.
        - Why is this called an object class it şs because they are only created in the testbenh when they are required 
            and destroyed once they serve their purpose.
*/

class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)
    
    // request item
    rand bit [7:0] input_1;
    rand bit [7:0] input_2;
    // response item
    bit [15:0] output_3;
    
    function new (string name = "seq_item");
        super.new(name);
    endfunction



endclass
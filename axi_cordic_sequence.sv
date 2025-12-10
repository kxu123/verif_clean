`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_cordic_sequence extends uvm_sequence;
    `uvm_object_utils(axi_cordic_sequence)
    function new(string name = "axi_cordic_sequence");
        super.new(name);
    endfunction
    
    virtual task body();
        repeat (5) begin 
            axi_cordic_item item = axi_cordic_item::type_id::create("item");
            start_item(item);
            if (!item.randomize())
                `uvm_fatal("SEQ", "TEST")
            item.print();
            finish_item(item);
        end
    endtask

endclass

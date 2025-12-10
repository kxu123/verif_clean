`include "uvm_macros.svh"
// `include "axi_cordic_driver.sv"
// `include "axi_cordic_sequence.sv"
// `include "axi_cordic_monitor.sv"
import uvm_pkg::*;

class axi_cordic_agent extends uvm_agent;
    `uvm_component_utils(axi_cordic_agent)
    function new(string name = "axi_cordic_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    axi_cordic_driver   driver;
    axi_cordic_monitor  monitor;
    uvm_sequencer       #(axi_cordic_item) sequencer;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sequencer = uvm_sequencer#(axi_cordic_item)::type_id::create("sequencer", this);
        driver = axi_cordic_driver::type_id::create("driver", this);
        monitor = axi_cordic_monitor::type_id::create("monitor", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);
    endfunction
endclass
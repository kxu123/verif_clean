`include "uvm_macros.svh"
// `include "axi_cordic_env.sv"
// `include "cordic_interface.sv"
// `include "axi_cordic_sequence.sv"
import uvm_pkg::*;

class axi_cordic_test extends uvm_test;
    `uvm_component_utils(axi_cordic_test)
    function new(string name = "axi_cordic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    axi_cordic_env env; 
    virtual cordic_interface vif_h;
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);        
        env = axi_cordic_env::type_id::create("env", this);
      if (!uvm_config_db#(virtual cordic_interface)::get(this, "", "cordic_interface", vif_h))
          `uvm_fatal("TEST", "Did not get vif_h")

      uvm_config_db#(virtual cordic_interface)::set(this, "env.cordic_agent.*", "cordic_interface", vif_h);
    endfunction

    // DON'T reset for now

    virtual task run_phase(uvm_phase phase);
        axi_cordic_sequence seq = axi_cordic_sequence::type_id::create("seq");
        phase.raise_objection(this);
        seq.randomize();
      	assert(seq.randomize()) else `uvm_fatal("TEST", "Randomization failed!");
        seq.start(env.cordic_agent.sequencer);
        #200;
        phase.drop_objection(this);
    endtask

endclass
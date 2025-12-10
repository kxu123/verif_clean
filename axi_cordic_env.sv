`include "uvm_macros.svh"
// `include "axi_cordic_agent.sv"
// `include "axi_cordic_scoreboard.sv"
import uvm_pkg::*;

class axi_cordic_env extends uvm_env;
    `uvm_component_utils(axi_cordic_env)
    function new(string name = "axi_cordic_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    axi_cordic_agent     cordic_agent;
    axi_cordic_scoreboard scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cordic_agent = axi_cordic_agent::type_id::create("cordic_agent", this);
        scoreboard = axi_cordic_scoreboard::type_id::create("scoreboard", this);
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cordic_agent.monitor.item_collected_port.connect(scoreboard.m_analysis_imp);
    endfunction
endclass
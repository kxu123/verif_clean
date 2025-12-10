`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_cordic_driver extends uvm_driver #(axi_cordic_item);
    `uvm_component_utils(axi_cordic_driver)

    function new(string name = "axi_cordic_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual cordic_interface vif_h;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      if (!uvm_config_db#(virtual cordic_interface)::get(this, "", "cordic_interface", vif_h)) begin
            `uvm_fatal("DRV", "virtual interface error")
        end
    endfunction

    virtual task reset_signals();
        vif_h.s00_axis_tvalid <= 1'b0;
        vif_h.s00_axis_tdata <= '0;
        vif_h.s00_axis_tlast <= 1'b0;
        vif_h.s00_axis_tstrb <= '0;
        vif_h.m00_axis_tready <= 1'b1; 
    endtask

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        reset_signals();
        wait (vif_h.s00_axis_aresetn == 1'b1);
        @(posedge vif_h.s00_axis_aclk);
        forever begin
            axi_cordic_item new_item;
            seq_item_port.get_next_item(new_item);
            drive_s00_transaction(new_item);
            seq_item_port.item_done();
        end
    endtask

    task drive_s00_transaction(axi_cordic_item item);
        @(posedge vif_h.s00_axis_aclk);
        vif_h.s00_axis_tdata <= {item.s00_data_y[15:0], item.s00_data_x[15:0]};
        vif_h.s00_axis_tstrb <= 4'hF; 
        vif_h.s00_axis_tlast <= 1'b1; 

        @(posedge vif_h.s00_axis_aclk)
        vif_h.s00_axis_tvalid <= 1'b1;

        @(posedge vif_h.s00_axis_aclk)

        @(posedge vif_h.s00_axis_aclk)
        vif_h.s00_axis_tvalid <= 1'b0;
        while (!vif_h.s00_axis_tready) begin
            @(posedge vif_h.s00_axis_aclk);
        end
        vif_h.s00_axis_tvalid <= 1'b0;
        
        `uvm_info(get_full_name(), 
            $sformatf("Driving Input: X=%0d, Y=%0d", item.s00_data_x, item.s00_data_y), UVM_HIGH)
    endtask

endclass
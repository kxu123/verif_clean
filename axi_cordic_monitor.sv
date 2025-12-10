`include "uvm_macros.svh"
import uvm_pkg::*;

class axi_cordic_monitor extends uvm_monitor;
    `uvm_component_utils(axi_cordic_monitor)
    function new(string name = "axi_cordic_monitor", uvm_component parent = null);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction

    uvm_analysis_port #(axi_cordic_item) item_collected_port;
    virtual cordic_interface vif_h;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
      if (!uvm_config_db#(virtual cordic_interface)::get(this, "", "cordic_interface", vif_h)) begin
            `uvm_fatal(get_full_name(), "here! error")
        end
        //item_collected_port = new ("item_collected_port", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            axi_cordic_item item = new;

          //item.s00_data_x = $signed(vif_h.s00_axis_tdata[15:0]);
            @(posedge vif_h.m00_axis_aclk);
            // $display("in AXI_MONITOR, m00 tvalid: %d, m00 tready %d\n", vif_h.m00_axis_tvalid, vif_h.m00_axis_tready);
            // $display("in AXI_MONITOR, s00 tvalid: %d, s00 tready %d\n", vif_h.s00_axis_tvalid, vif_h.s00_axis_tready);

            if (vif_h.m00_axis_tvalid && vif_h.m00_axis_tready) begin
                //item = axi_cordic_item::type_id::create("item");
                item.m00_data_x = $signed(vif_h.m00_axis_tdata[15:0]);
                item.m00_data_z = $signed(vif_h.m00_axis_tdata[31:16]);
                item.s00_data_x = $signed(vif_h.s00_axis_tdata[15:0]);
                item.s00_data_y = $signed(vif_h.s00_axis_tdata[31:16]);
                `uvm_info(get_type_name(), $sformatf("Monitor found packet %s", item.convert2str()), UVM_LOW)
                item_collected_port.write(item);

            end
            
            // `uvm_info(get_type_name(), $sformatf("Monitor found packet %s", item.convert2str()), UVM_LOW)
            // item_collected_port.write(item);
        end
    endtask


endclass
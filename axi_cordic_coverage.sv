`include "uvm_macros.svh"
import uvm_pkg::*;
 
class axi_cordic_coverage extends uvm_subscriber#(axi_cordic_item);
    `uvm_component_utils(axi_cordic_coverage);
    axi_cordic_item it; 

    covergroup my_coverage; // check for varying input x and y values
        val_X: coverpoint(it.s00_data_x) {
            bins low_x = {[0:10]};
            bins high_x = {[5000:10000]};
        }

        val_Y: coverpoint(it.s00_data_y) {
            bins low_y = {[0:10]};
            bins high_y = {[5000:10000]};
        }
        combo: cross val_X, val_Y;
    endgroup : my_coverage

    covergroup output_check; // check for varying output values
        output_x: coverpoint(it.m00_data_x) {
            bins low_x = {[0:50]};
            bins middle_x = {[50:500]};
            bins high_x = {[500:5000]};
        }

        output_z: coverpoint(it.m00_data_z) {
            bins negative_z = {[-360:0]};
            bins positive_z = {[0:360]};
        }
        combo: cross output_x, output_z;
    endgroup : output_check

    function new(string name = "axi_cordic_coverage", uvm_component parent = null);
        super.new(name, parent);
        my_coverage = new();
        output_check = new();
    endfunction

    function void write(axi_cordic_item t);
        it = t;
        my_coverage.sample();
        output_check.sample();
    endfunction

    function void report_phase(uvm_phase phase);
        `uvm_info(get_full_name(), $sformatf("Coverage is %f %%", my_coverage.get_coverage()), UVM_LOW);
    endfunction


endclass
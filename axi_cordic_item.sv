`include "uvm_macros.svh"

import uvm_pkg::*;
import cordic_dpi_pkg::*;

class axi_cordic_item extends uvm_sequence_item;
    rand int s00_data_x; 
    rand int s00_data_y; 
    int      m00_data_x; 
    int      m00_data_z;
    
    shortreal     ref_x;
    shortreal     ref_z;

    `uvm_object_utils_begin(axi_cordic_item)
        `uvm_field_int(s00_data_x, UVM_DEFAULT)
        `uvm_field_int(s00_data_y, UVM_DEFAULT)
        `uvm_field_int(m00_data_x, UVM_DEFAULT)
        `uvm_field_int(m00_data_z, UVM_DEFAULT)
        `uvm_field_real(ref_x, UVM_DEFAULT) 
        `uvm_field_real(ref_z, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "axi_cordic_item");
        super.new(name);
    endfunction
    
    constraint input_range {
        // s00_data_x inside {[5000:65536]}; 
        // s00_data_y inside {[5000:65536]}; 
        s00_data_x inside {[5000:65536]}; 
        s00_data_y inside {[5000:65536]}; 
    }

    virtual function string convert2str();
        return $sformatf("s00_x=%0d s00_y=%0d m00_x=%0d m00_z=%0d ref_x=%0f ref_z=%0f", 
                         s00_data_x, s00_data_y, m00_data_x, m00_data_z, ref_x, ref_z);
    endfunction
    
    task do_reference_model();
        shortreal in_x = shortreal'(s00_data_x);
        shortreal in_y = shortreal'(s00_data_y);
        $display("IN CORDIC_ITEM: in_x %f, in_y %f \n", in_x, in_y);
        cordic_reference(in_x, in_y, ref_x, ref_z);
    endtask

endclass
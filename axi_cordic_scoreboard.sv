`include "uvm_macros.svh"
import cordic_dpi_pkg::*;
import uvm_pkg::*;

class axi_cordic_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(axi_cordic_scoreboard)
    function new(string name = "axi_cordic_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp #(axi_cordic_item, axi_cordic_scoreboard) m_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
    endfunction
    
  virtual function void write(axi_cordic_item item);
    shortreal sv_in_x = shortreal'(item.s00_data_x);
    shortreal sv_in_y = shortreal'(item.s00_data_y);
    shortreal exp_x; 
    shortreal exp_z; 
    cordic_reference(sv_in_x, sv_in_y, exp_x, exp_z);
    //$display("HERE! item_m00_data_x %b, %f", item.m00_data_x, item.m00_data_x[15:0]);
    if ( !magnitude_within_tolerance(item.m00_data_x[15:0], exp_x) ) begin
       `uvm_error("FAIL", $sformatf("X Mismatch InX=%0d InY=%0d | DUT_X=%0d Ref_X=%0f", 
                                        item.s00_data_x, item.s00_data_y, item.m00_data_x[15:0], exp_x))
    end else begin
       `uvm_info("PASS", $sformatf("X Match DUT=%0d Ref=%0f", item.m00_data_x[15:0], exp_x), UVM_HIGH)
    end
    if ( !is_within_tolerance(item.m00_data_z[15:0]* 0.00549, exp_z) ) begin
       `uvm_error("FAIL", $sformatf("Z Mismatch InX=%0d InY=%0d | DUT_Z=%0f Ref_Z=%0f", 
                                        item.s00_data_x, item.s00_data_y, item.m00_data_z[15:0] * 0.00549, exp_z))
    end else begin
       `uvm_info("PASS", $sformatf("Z Match DUT=%0d Ref=%0f", item.m00_data_z[15:0]* 0.00549, exp_z), UVM_HIGH)
    end
    
  endfunction

  function bit magnitude_within_tolerance(int actual, shortreal expected);
    shortreal sum;
    sum = actual + expected;
    $display("IN SCOREBOARD, actual is %d, expected is %f, actual_hex: %h", actual, expected, actual);
    if (actual > expected) begin
      return ((actual-expected) <= expected * 0.05);
    end else begin
      return ((expected-actual) <= expected * 0.05);
    end
    return 1;
  endfunction

  function bit is_within_tolerance(int actual, shortreal expected);
    shortreal sum;
    shortreal diff;
    sum = actual + expected;
    if (actual > expected) begin
      diff = actual - expected;
    end else begin
      diff = expected - actual;
    end
 
    $display("IN SCOREBOARD, SUM IS %f, actual is %d, expected is %f, actual_hex: %h", sum, actual, expected, actual);
    if ((sum >= 345) && (sum <= 375)) begin
      return 1;
    end

    if (diff < 3) begin
      return 1;
    end

    if (actual < 0) begin
      $display("ACTUAL IS LESS THAN 0");
      if (((expected - actual) >= 350) && ((expected - actual) >= 370)) begin
        return 1;
      end
      if ((-1* actual) == expected) begin
        return 1;
      end
    end
    return 0; 
  
  endfunction

endclass
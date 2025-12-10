package cordic_dpi_pkg;
    import "DPI-C" function void cordic_reference (
        input shortreal x, 
        input shortreal y,
        output shortreal x_out,
        output shortreal z_out
    );
endpackage : cordic_dpi_pkg

`include "uvm_macros.svh"
`include "cordic_interface.sv"
`include "axi_cordic.sv"
`include "axi_cordic_item.sv"
`include "axi_cordic_sequence.sv"
`include "axi_cordic_driver.sv"
`include "axi_cordic_monitor.sv"
`include "axi_cordic_scoreboard.sv"
`include "axi_cordic_agent.sv"
`include "axi_cordic_env.sv"
`include "axi_cordic_test.sv"


import uvm_pkg::*;
import cordic_dpi_pkg::*;

module tb_top;
  logic clk;
  logic rst;

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    rst = 0;    
    #100;      
    rst = 1;   
  end

  cordic_interface intf (
    .clk (clk),
    .rst (rst)
  );

  axi_cordic dut (
    .s00_axis_aclk    (intf.s00_axis_aclk),   
    .s00_axis_aresetn (intf.s00_axis_aresetn),
    .s00_axis_tready  (intf.s00_axis_tready), 
    .s00_axis_tdata   (intf.s00_axis_tdata),
    .s00_axis_tstrb   (intf.s00_axis_tstrb),
    .s00_axis_tlast   (intf.s00_axis_tlast),
    .s00_axis_tvalid  (intf.s00_axis_tvalid),

    .m00_axis_aclk    (intf.m00_axis_aclk),
    .m00_axis_aresetn (intf.m00_axis_aresetn),
    .m00_axis_tvalid  (intf.m00_axis_tvalid), 
    .m00_axis_tdata   (intf.m00_axis_tdata),   
    .m00_axis_tstrb   (intf.m00_axis_tstrb),
    .m00_axis_tlast   (intf.m00_axis_tlast),
    .m00_axis_tready  (intf.m00_axis_tready)   
  );

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_top);
    uvm_config_db#(virtual cordic_interface)::set(null, "*", "cordic_interface", intf);
    run_test("axi_cordic_test"); 
  end


endmodule

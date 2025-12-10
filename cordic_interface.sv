interface cordic_interface (
    input logic clk,
    input logic rst
);

    parameter integer C_S00_AXIS_TDATA_WIDTH    = 32;
    parameter integer C_M00_AXIS_TDATA_WIDTH    = 32;
    logic s00_axis_aclk;
    logic s00_axis_aresetn;
    logic s00_axis_tlast;
    logic s00_axis_tvalid;
    logic [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata;
    logic [(C_S00_AXIS_TDATA_WIDTH/8)-1: 0] s00_axis_tstrb;
    logic s00_axis_tready;
    logic m00_axis_aclk;
    logic m00_axis_aresetn;
    logic m00_axis_tready;
    logic m00_axis_tvalid;
    logic m00_axis_tlast;
    logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata;
    logic [(C_M00_AXIS_TDATA_WIDTH/8)-1: 0] m00_axis_tstrb;
  
    assign s00_axis_aclk = clk;
    assign s00_axis_aresetn = rst;
    assign m00_axis_aclk = clk;
    assign m00_axis_aresetn = rst;

endinterface

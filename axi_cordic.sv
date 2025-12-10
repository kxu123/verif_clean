//`timescale 1ns / 1ps
`default_nettype none
 
module axi_cordic #
    (
        parameter integer C_S00_AXIS_TDATA_WIDTH    = 32,
        parameter integer C_M00_AXIS_TDATA_WIDTH    = 32
    )
    (
 
        // Ports of Axi Slave Bus Interface S00_AXIS
        input wire  s00_axis_aclk, s00_axis_aresetn,
        input wire  s00_axis_tlast, s00_axis_tvalid,
        input wire [C_S00_AXIS_TDATA_WIDTH-1 : 0] s00_axis_tdata,
        input wire [(C_S00_AXIS_TDATA_WIDTH/8)-1: 0] s00_axis_tstrb,
        output logic  s00_axis_tready,
  
        // Ports of Axi Master Bus Interface M00_AXIS
        input wire  m00_axis_aclk, m00_axis_aresetn,
        input wire  m00_axis_tready,
        output logic  m00_axis_tvalid, m00_axis_tlast,
        output logic [C_M00_AXIS_TDATA_WIDTH-1 : 0] m00_axis_tdata,
        output logic [(C_M00_AXIS_TDATA_WIDTH/8)-1: 0] m00_axis_tstrb
    );

    logic q2;
    logic q3;
    logic signed [16:0][15:0] cordic_angles;

    logic m00_axis_tvalid_reg, m00_axis_tlast_reg;

    logic signed [31:0] new_x;
    logic signed [31:0] new_y;
    logic signed [15:0] z;
    logic [4:0] counter;

    assign m00_axis_tvalid = m00_axis_tvalid_reg;
    assign m00_axis_tlast = m00_axis_tlast_reg;
    assign m00_axis_tdata = {z, new_x[15:0]};
    assign m00_axis_tstrb = 4'hF;


 
    always_ff @(posedge s00_axis_aclk) begin
        if (s00_axis_aresetn == 0) begin
            cordic_angles[0] <= 16'sd8192;
            cordic_angles[1] <= 16'sd4836;
            cordic_angles[2] <= 16'sd2555;
            cordic_angles[3] <= 16'sd1297;
            cordic_angles[4] <= 16'sd651;
            cordic_angles[5] <= 16'sd326;
            cordic_angles[6] <= 16'sd163;
            cordic_angles[7] <= 16'sd81; 
            cordic_angles[8] <= 16'sd41;
            cordic_angles[9] <= 16'sd20;
            cordic_angles[10] <= 16'sd10;
            cordic_angles[11] <= 16'sd5;
            cordic_angles[12] <= 16'sd3;
            cordic_angles[13] <= 16'sd1;
            cordic_angles[14] <= 16'sd1;
            cordic_angles[15] <= 16'sd0;
            cordic_angles[16] <= 16'sd0;
            m00_axis_tvalid_reg <= 0;
            m00_axis_tlast_reg <= 0;
            q2 <= 0;
            q3 <= 0;
            new_x <= 0;
            new_y <= 0;
            z <= 0;
            counter <= 0;
            s00_axis_tready <= 1'b1;
        end else begin
            if (s00_axis_tready && s00_axis_tvalid) begin
                s00_axis_tready <= 1'b0;
                m00_axis_tvalid_reg <= 1'b0;
                counter <= counter + 1'b1;
                if ($signed(s00_axis_tdata[15:0]) < 0) begin
                    new_x <= -$signed(s00_axis_tdata[15:0]);
                end else begin
                    new_x <= s00_axis_tdata[15:0];
                end
                //new_x <= (s00_axis_tdata[15] == 1'b1) ? -$signed(s00_axis_tdata[15:0]) : s00_axis_tdata[15:0];
                new_y <= $signed(s00_axis_tdata[31:16]);
                z <= 0;
                q2 <= ((s00_axis_tdata[15] == 1'b1) && s00_axis_tdata[31] == 1'b0) ? 1'b1 : 1'b0;
                q3 <= ((s00_axis_tdata[15] == 1'b1) && s00_axis_tdata[31] == 1'b1) ? 1'b1 : 1'b0;
            end else if (counter > 5'd0 && counter < 5'd17) begin
                counter <= counter + 1;
                if (new_y[15] == 0) begin  
                    new_x <= new_x + (new_y >>> (counter-1));
                    new_y <= new_y - (new_x >>> (counter-1));
                    z <= z - cordic_angles[counter-1];
                end else begin
                    new_x <= new_x - (new_y >>> (counter-1));
                    new_y <= new_y + (new_x >>> (counter-1));
                    z <= z + cordic_angles[counter-1];
                end
            end else if (counter == 5'd17) begin
                m00_axis_tvalid_reg <= 1'b1;
                counter <= counter + 1;
                new_x <= (new_x * 39796) >>> 16;
                if (q2) begin
                    z <= z - 16'h8000;
                end else if (q3) begin
                    z <= z + 16'h8000;
                end
            end else if (m00_axis_tvalid_reg && m00_axis_tready) begin
                m00_axis_tvalid_reg <= 1'b0;
                counter <= 5'd0;
                s00_axis_tready <= 1'b1;
            end 
            m00_axis_tlast_reg <= s00_axis_tlast;
        end
    end
endmodule
 
`default_nettype wire

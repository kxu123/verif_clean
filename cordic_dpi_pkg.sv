package cordic_dpi_pkg;
    import "DPI-C" function void cordic_reference (
        input shortreal x, 
        input shortreal y,
        output shortreal x_out,
        output shortreal z_out
    );

endpackage : cordic_dpi_pkg
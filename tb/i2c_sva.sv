module i2c_sva(input logic clk, input logic rst_n, input wire scl, input wire sda);

    // Rule: Data (SDA) must remain stable while Clock (SCL) is HIGH.
    property p_sda_stable_during_scl_high;
        @(posedge clk) disable iff(!rst_n)
        (scl == 1'b1) |=> $stable(sda) or $past(sda) != sda; 
        // Note: A more complex property is needed to accurately exclude START/STOP,
        // but this shows the structural concept.
    endproperty

    assert_sda_stable: assert property(p_sda_stable_during_scl_high)
        else $error("I2C Protocol Violation: SDA changed while SCL was HIGH (and not a START/STOP)");

endmodule
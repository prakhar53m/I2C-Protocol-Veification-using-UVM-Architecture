module tb_top;
    import uvm_pkg::*;

    logic clk;
    logic rst_n;

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        #20 rst_n = 1;
    end

    i2c_if vif(.clk(clk), .rst_n(rst_n));
    
    // Pull-up resistors required by I2C spec
    pullup(vif.scl);
    pullup(vif.sda);

    i2c_slave_rtl #(
        .MY_ADDR(7'h5A)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .scl(vif.scl),
        .sda(vif.sda)
    );

    initial begin
        uvm_config_db#(virtual i2c_if)::set(null, "uvm_test_top", "vif", vif);
        run_test("i2c_test");
    end
endmodule
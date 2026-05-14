    class i2c_rd_driver extends uvm_driver #(i2c_seq_item);
    `uvm_component_utils(i2c_rd_driver)
    virtual i2c_if vif;

    function new(string name="i2c_rd_driver", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            `uvm_info("RD_DRV", $sformatf("Reading from Addr: %0h", req.addr), UVM_LOW)
            @(posedge vif.clk);
            seq_item_port.item_done();
        end
    endtask
endclass
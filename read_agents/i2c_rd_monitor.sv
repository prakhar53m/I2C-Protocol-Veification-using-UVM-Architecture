class i2c_rd_monitor extends uvm_monitor;
    `uvm_component_utils(i2c_rd_monitor)
    virtual i2c_if vif;
    uvm_analysis_port #(i2c_seq_item) ap;

    function new(string name="i2c_rd_monitor", uvm_component parent=null);
        super.new(name, parent);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        i2c_seq_item item = i2c_seq_item::type_id::create("item");
        forever begin
            @(posedge vif.clk);
        end
    endtask
endclass
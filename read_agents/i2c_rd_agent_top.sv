class i2c_rd_agent_top extends uvm_agent;
    `uvm_component_utils(i2c_rd_agent_top)
    i2c_rd_agent_cfg cfg;
    i2c_rd_sequencer sqr;
    i2c_rd_driver    drv;
    i2c_rd_monitor   mon;

    function new(string name="i2c_rd_agent_top", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(i2c_rd_agent_cfg)::get(this, "", "rd_cfg", cfg))
            `uvm_fatal("RD_AGENT", "Failed to get config")
            
        mon = i2c_rd_monitor::type_id::create("mon", this);
        if(cfg.is_active == UVM_ACTIVE) begin
            sqr = i2c_rd_sequencer::type_id::create("sqr", this);
            drv = i2c_rd_driver::type_id::create("drv", this);
        end
    endfunction

    function void connect_phase(uvm_phase phase);
        mon.vif = cfg.vif;
        if(cfg.is_active == UVM_ACTIVE) begin
            drv.seq_item_port.connect(sqr.seq_item_export);
            drv.vif = cfg.vif;
        end
    endfunction
endclass
class i2c_rd_agent_cfg extends uvm_object;
    `uvm_object_utils(i2c_rd_agent_cfg)
    uvm_active_passive_enum is_active = UVM_ACTIVE;
    virtual i2c_if vif;
    function new(string name="i2c_rd_agent_cfg"); super.new(name); endfunction
endclass 
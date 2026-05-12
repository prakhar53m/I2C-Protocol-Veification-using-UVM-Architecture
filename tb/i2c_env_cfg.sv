class i2c_env_cfg extends uvm_object;
    `uvm_object_utils(i2c_env_cfg)
    i2c_wr_agent_cfg wr_cfg;
    i2c_rd_agent_cfg rd_cfg;
    function new(string name="i2c_env_cfg");
        super.new(name);
        wr_cfg = i2c_wr_agent_cfg::type_id::create("wr_cfg");
        rd_cfg = i2c_rd_agent_cfg::type_id::create("rd_cfg");
    endfunction
endclass
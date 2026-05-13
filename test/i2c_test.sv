class i2c_test extends uvm_test;
    `uvm_component_utils(i2c_test)
    
    i2c_env     env;
    i2c_env_cfg env_cfg;

    function new(string name="i2c_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env_cfg = i2c_env_cfg::type_id::create("env_cfg");
        
        if(!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", env_cfg.wr_cfg.vif))
            `uvm_fatal("TEST", "No virtual interface found")
        
        env_cfg.rd_cfg.vif = env_cfg.wr_cfg.vif; // Both agents share the same physical lines

        uvm_config_db#(i2c_env_cfg)::set(this, "env*", "env_cfg", env_cfg);
        env = i2c_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
        i2c_vseq vseq = i2c_vseq::type_id::create("vseq");
        phase.raise_objection(this);
        vseq.start(env.vsqr);
        #1000;
        phase.drop_objection(this);
    endtask
endclass
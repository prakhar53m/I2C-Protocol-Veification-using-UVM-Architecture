class i2c_env extends uvm_env;
    `uvm_component_utils(i2c_env)
    
    i2c_env_cfg      env_cfg;
    i2c_wr_agent_top wr_agent;
    i2c_rd_agent_top rd_agent;
    i2c_scoreboard   sb;
    i2c_vsequencer   vsqr;

    function new(string name="i2c_env", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(i2c_env_cfg)::get(this, "", "env_cfg", env_cfg))
            `uvm_fatal("ENV", "Failed to get env_cfg")

        uvm_config_db#(i2c_wr_agent_cfg)::set(this, "wr_agent*", "wr_cfg", env_cfg.wr_cfg);
        uvm_config_db#(i2c_rd_agent_cfg)::set(this, "rd_agent*", "rd_cfg", env_cfg.rd_cfg);

        wr_agent = i2c_wr_agent_top::type_id::create("wr_agent", this);
        rd_agent = i2c_rd_agent_top::type_id::create("rd_agent", this);
        sb       = i2c_scoreboard::type_id::create("sb", this);
        vsqr     = i2c_vsequencer::type_id::create("vsqr", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        wr_agent.mon.ap.connect(sb.wr_imp);
        rd_agent.mon.ap.connect(sb.rd_imp);
        vsqr.wr_sqr = wr_agent.sqr;
        vsqr.rd_sqr = rd_agent.sqr;
    endfunction
endclass
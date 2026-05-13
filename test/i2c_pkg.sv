package i2c_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // 1. Base Transactions
    `include "i2c_seq_item.sv"

    // 2. Agent Configurations
    `include "write_agents/i2c_wr_agent_cfg.sv"
    `include "read_agents/i2c_rd_agent_cfg.sv"
    `include "i2c_env_cfg.sv"

    // 3. Sequencers and Sequences
    `include "write_agents/i2c_wr_sequencer.sv"
    `include "write_agents/i2c_wr_sequence.sv"
    `include "read_agents/i2c_rd_sequencer.sv"
    `include "read_agents/i2c_rd_sequence.sv"

    // 4. Drivers and Monitors
    `include "write_agents/i2c_wr_driver.sv"
    `include "write_agents/i2c_wr_monitor.sv"
    `include "read_agents/i2c_rd_driver.sv"
    `include "read_agents/i2c_rd_monitor.sv"

    // 5. Agents
    `include "write_agents/i2c_wr_agent_top.sv"
    `include "read_agents/i2c_rd_agent_top.sv"

    // 6. Scoreboard & Virtual Sequencer
    `include "i2c_scoreboard.sv"
    `include "i2c_vsequencer.sv"
    `include "i2c_vseq.sv"

    // 7. Environment & Test
    `include "i2c_env.sv"
    `include "i2c_test.sv"

endpackage
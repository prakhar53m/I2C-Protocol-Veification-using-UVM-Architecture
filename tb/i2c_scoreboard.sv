`uvm_analysis_imp_decl(_wr)
`uvm_analysis_imp_decl(_rd)

class i2c_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(i2c_scoreboard)
    uvm_analysis_imp_wr #(i2c_seq_item, i2c_scoreboard) wr_imp;
    uvm_analysis_imp_rd #(i2c_seq_item, i2c_scoreboard) rd_imp;

    logic [7:0] expected_mem [0:127];

    function new(string name="i2c_scoreboard", uvm_component parent=null);
        super.new(name, parent);
        wr_imp = new("wr_imp", this);
        rd_imp = new("rd_imp", this);
    endfunction

    virtual function void write_wr(i2c_seq_item item);
        expected_mem[item.addr] = item.data;
    endfunction

    virtual function void write_rd(i2c_seq_item item);
        if(expected_mem[item.addr] == item.data)
            `uvm_info("SB_PASS", "Read Data Matched", UVM_LOW)
        else
            `uvm_error("SB_FAIL", "Read Data Mismatched")
    endfunction
endclass
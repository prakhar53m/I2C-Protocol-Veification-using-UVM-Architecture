class i2c_vsequencer extends uvm_sequencer;
    `uvm_component_utils(i2c_vsequencer)
    i2c_wr_sequencer wr_sqr;
    i2c_rd_sequencer rd_sqr;
    function new(string name="i2c_vsequencer", uvm_component parent=null);
        super.new(name, parent);
    endfunction
endclass
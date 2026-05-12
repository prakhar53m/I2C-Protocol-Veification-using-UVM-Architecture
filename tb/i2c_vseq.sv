class i2c_vseq extends uvm_sequence;
    `uvm_object_utils(i2c_vseq)
    `uvm_declare_p_sequencer(i2c_vsequencer)

    i2c_wr_sequence wr_seq;
    i2c_rd_sequence rd_seq;

    function new(string name="i2c_vseq"); super.new(name); endfunction

    task body();
        wr_seq = i2c_wr_sequence::type_id::create("wr_seq");
        rd_seq = i2c_rd_sequence::type_id::create("rd_seq");
        
        wr_seq.start(p_sequencer.wr_sqr);
        rd_seq.start(p_sequencer.rd_sqr);
    endtask
endclass
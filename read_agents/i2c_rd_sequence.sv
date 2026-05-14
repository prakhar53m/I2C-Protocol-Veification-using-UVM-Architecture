class i2c_rd_sequence extends uvm_sequence #(i2c_seq_item);
    `uvm_object_utils(i2c_rd_sequence)
    function new(string name="i2c_rd_sequence"); super.new(name); endfunction
    task body();
        req = i2c_seq_item::type_id::create("req");
        start_item(req);
        if(!req.randomize() with {rw == 1;}) `uvm_error("SEQ", "Randomize failed")
        finish_item(req);
    endtask
endclass
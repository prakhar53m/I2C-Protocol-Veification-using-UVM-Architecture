import uvm_pkg::*;
`include "uvm_macros.svh"

class i2c_seq_item extends uvm_sequence_item;
    rand logic [6:0] addr;
    rand logic [7:0] data;
    rand logic       rw; // 0: Write, 1: Read

    `uvm_object_utils_begin(i2c_seq_item)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(rw,   UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name = "i2c_seq_item"); super.new(name); endfunction
endclass
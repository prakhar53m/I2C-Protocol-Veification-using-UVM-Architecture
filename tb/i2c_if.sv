interface i2c_if(input logic clk, input logic rst_n);
    wire scl;
    wire sda;
    
    // Abstracted signals for easy monitor tapping
    logic [6:0] mon_addr;
    logic [7:0] mon_data;
    logic       mon_rw;
endinterface
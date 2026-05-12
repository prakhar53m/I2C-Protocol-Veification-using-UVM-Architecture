module i2c_slave_rtl #(
    parameter [6:0] MY_ADDR = 7'h5A
)(
    input  logic clk,
    input  logic rst_n,
    inout  tri   scl,
    inout  tri   sda
);
    logic [2:0] scl_sync, sda_sync;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scl_sync <= 3'b111; sda_sync <= 3'b111;
        end else begin
            scl_sync <= {scl_sync[1:0], scl};
            sda_sync <= {sda_sync[1:0], sda};
        end
    end

    wire scl_f = scl_sync[1];
    wire sda_f = sda_sync[1];
    wire scl_rise = (scl_sync[2:1] == 2'b01);
    wire scl_fall = (scl_sync[2:1] == 2'b10);
    wire sda_fall = (sda_sync[2:1] == 2'b10);
    wire sda_rise = (sda_sync[2:1] == 2'b01);

    wire start_cond = (scl_f == 1'b1) && sda_fall;
    wire stop_cond  = (scl_f == 1'b1) && sda_rise;

    typedef enum logic [3:0] {IDLE, GET_ADDR, ACK_ADDR, RCV_DATA, ACK_DATA, SEND_DATA, WAIT_ACK} state_t;
    state_t state, next_state;

    logic [7:0] shift_reg, mem_data, data_to_send;
    logic [2:0] bit_cnt;
    logic rw_bit, sda_out, sda_en;

    assign sda = (sda_en && !sda_out) ? 1'b0 : 1'bz; 

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE; shift_reg <= 8'd0; bit_cnt <= 3'd0; rw_bit <= 1'b0; mem_data <= 8'hAA;
        end else if (start_cond) begin
            state <= GET_ADDR; bit_cnt <= 3'd7; shift_reg <= 8'd0;
        end else if (stop_cond) begin
            state <= IDLE;
        end else begin
            case (state)
                GET_ADDR: if (scl_rise) begin
                    shift_reg <= {shift_reg[6:0], sda_f};
                    if (bit_cnt == 0) begin state <= ACK_ADDR; rw_bit <= sda_f; end
                    else bit_cnt <= bit_cnt - 1;
                end
                ACK_ADDR: if (scl_fall) begin
                    if (shift_reg[7:1] == MY_ADDR) begin
                        state <= (rw_bit == 1'b0) ? RCV_DATA : SEND_DATA;
                        data_to_send <= mem_data; bit_cnt <= 3'd7;
                    end else state <= IDLE;
                end
                RCV_DATA: if (scl_rise) begin
                    shift_reg <= {shift_reg[6:0], sda_f};
                    if (bit_cnt == 0) state <= ACK_DATA;
                    else bit_cnt <= bit_cnt - 1;
                end
                ACK_DATA: if (scl_fall) begin
                    mem_data <= shift_reg; state <= RCV_DATA; bit_cnt <= 3'd7;
                end
                SEND_DATA: if (scl_fall) begin
                    if (bit_cnt == 0) state <= WAIT_ACK;
                    else bit_cnt <= bit_cnt - 1;
                end
                WAIT_ACK: if (scl_rise) begin
                    if (sda_f == 1'b0) begin state <= SEND_DATA; bit_cnt <= 3'd7; end
                    else state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

    always_comb begin
        sda_en = 1'b0; sda_out = 1'b1;
        case (state)
            ACK_ADDR: if (shift_reg[7:1] == MY_ADDR) begin sda_en = 1'b1; sda_out = 1'b0; end
            ACK_DATA: begin sda_en = 1'b1; sda_out = 1'b0; end
            SEND_DATA: begin sda_en = 1'b1; sda_out = data_to_send[bit_cnt]; end
        endcase
    end
endmodule
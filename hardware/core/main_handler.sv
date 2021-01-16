`timescale 1ns / 1ps
//Data handler

module main_handler #(
    parameter N_BIT = 8
)(
    input clk, reset,
    input trig_start,
    input uart_ready,
    input logic [N_BIT-1:0] data_aq,
    output logic [7:0] data_out,
    output logic data_ready,
    output logic req_data
    );

typedef enum {st_idle,st_send} aq_fsm_type;
aq_fsm_type aq_fsm;

localparam BYTECOUNTER = (N_BIT/8) + 1*((N_BIT%8)>0);
integer bytecount;
logic [N_BIT-1:0] data_mem;
integer i;
always_ff@(posedge(clk),posedge(reset)) begin
    
    if (reset) begin
        data_ready <= 1'b0;
        aq_fsm <= st_idle;
        bytecount <= 0;
        data_mem <= 0;
        req_data <= 0;
    end
    else begin
        case(aq_fsm)
            st_idle: begin
                data_ready <= 1'b0;
                if (trig_start == 1'b1)
                    aq_fsm <= st_send;
                    req_data <= 1;
            end
            st_send: begin
                req_data <= 0;
                data_mem <= data_aq;
                if (uart_ready) begin
                    data_ready <= 1'b1;
                    if (bytecount == (BYTECOUNTER - 1)) begin
                        bytecount <= 0;
                        aq_fsm <= st_idle;
                        data_out <= {data_mem[7:(N_BIT%8)], {(N_BIT%8){1'b0}}};
                    end else begin
                        bytecount <= bytecount + 1;
                        data_out <= data_mem[(N_BIT-1-8*bytecount)-:8];
                    end
                end else data_ready <= 1'b0;
                
            end
        endcase
    end



end
endmodule
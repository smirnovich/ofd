`timescale 1ns / 1ps
// TOP level file

module top_ofd_uart(
    input logic clk,
    input logic reset,
    input [7:0] data_in,
    output logic tx,
    input rx,
    input trig_start
    );
    
localparam N_BITS = $bits(data_in);

wire [7:0] to_uart;
wire [N_BITS-1:0] data_to_handler;
wire tx_ready;
wire tx_run;
wire read_fifo;

basic_fifo #(.N_BIT(N_BITS)) fifo(
    .clk(clk),
    .reset(reset),
    .en(trig_start),
    .read_val(read_fifo),
    .data_in(data_in),
    .data_out(data_to_handler),
    .overflowed(),
    .is_empty()
);

uart #(.BAUDRATE(115200), .CLK_PERIOD(100000000)) uart(
    .clk(clk),
    .reset(reset),
    .rx(rx),
    .tx(tx),
    .data_in(to_uart),
    .data_out(),
    .run(tx_run),
    .tx_ready(tx_ready),
    .rx_ready()
);


main_handler #(.N_BIT(N_BITS)) handl(
    .clk(clk), 
    .reset(reset),
    .trig_start(trig_start),
    .uart_ready(tx_ready),
    .data_aq(data_to_handler),
    .data_out(to_uart),
    .data_ready(tx_run),
    .req_data(read_fifo)
    );

    
endmodule

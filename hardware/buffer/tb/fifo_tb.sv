`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Author: smirnovich 
// 
// Create Date: 09.01.2021 23:37:18
// Description: 
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fifo_tb();

logic  clk, reset;
logic en,read_val;
logic [7:0] data_in;
logic [7:0] data_out;
logic overflowed, is_empty;

localparam T = 10ns;
localparam N_BIT = 8;
basic_fifo dut(.*);

initial begin
    reset = 0;
    #10ns;
    reset = 1;
    #30ns;
    reset = 0;
end

//CLOCK
always begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

// WRITE check
always begin
    en = 0;
    #40ns;
    en = 1;
    data_in = 8'd21;
    @(posedge(clk));
    data_in = 8'd23;
    @(posedge(clk));
    data_in = 8'd28;
    @(posedge(clk));
    data_in = 8'd27;
    @(posedge(clk));
    data_in = 8'd26;
    en = 0;
    repeat(2)@(posedge(clk));
    en = 1;
    @(posedge(clk));
    data_in = 8'd25;
    @(posedge(clk));
    data_in = 8'd24;
    @(posedge(clk));
    data_in = 8'd23;
    @(posedge(clk));
    data_in = 8'd22;
    repeat(10)@(posedge(clk));
    data_in = 8'd21;
    
    $display("smirnovich INFO: done");
    #(5*T/2);
    $stop;
end

// READ check
always begin
    read_val = 0;
    #60ns;
    @(posedge(clk));
    read_val = 1'b1;
   repeat(2) @(posedge(clk));
   read_val = 1'b0;
    @(posedge(clk));
    read_val = 1'b1;
    @(posedge(clk));
    @(posedge(clk));
    read_val = 1'b0;
    
    $display("smirnovich INFO: done");
    #(T/2);
    //$stop;
end

endmodule

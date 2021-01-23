`include "vunit_defines.svh"
`timescale 1ns / 1ps

import data_tasks::*;
module top_ofd_uart_tb();

interface top_ofd_u;
   logic clk;
   logic reset;
   logic [7:0] data_in;
   logic [7:0] data_out;
   logic tx;
   logic rx;
   logic trig_start;
endinterface //top_ofd_u


//parameter string runner_cfg;

//`TEST_SUITE begin


localparam BAUDRATE = 115200;
localparam CLK_FREQ = 100000000;

top_ofd_u u_intf(); //instantiating interface
logic [7:0] data2tx = $random;
localparam T = 10ns;
localparam N_BITS = 8;



initial begin
   u_intf.clk = 1'b0;
   u_intf.reset = 1'b0;
   u_intf.rx = 1'b1;
   u_intf.trig_start = 1'b0;
end
   `TEST_SUITE begin
        `TEST_CASE("Check 1 byte receive") begin
            u_intf.rx <= 1'b1;
            #100ns;
            uart_rx_check(77, u_intf.rx, u_intf.reset);
            `CHECK_EQUAL(77, u_intf.data_out);
        end

         `TEST_CASE("Check multiple byte receive") begin

            u_intf.rx <= 1'b1;
            #100ns;
            for (int i=0; i<8; i++) begin
               data2tx = $random;
               uart_rx_check(data2tx, u_intf.rx, u_intf.reset);
               `CHECK_EQUAL(data2tx, u_intf.data_out);
            end
        end
        `TEST_CASE("Check multiple byte send") begin
            for (int i=0; i<8; i++) begin
               data2tx = $random;
               uart_tx_check(data2tx, u_intf.tx, u_intf.reset, u_intf.trig_start, u_intf.data_in);
               `CHECK_EQUAL(data2tx, u_intf.data_in);
            end
        end
   end

   always begin
      #(T/2);
      u_intf.clk <= 1'b0;
      #(T/2);
      u_intf.clk <= 1'b1;
   end
 //`WATCHDOG(10ms);
 
   top_ofd_uart top_ofd(
      .clk(u_intf.clk),
      .reset(u_intf.reset),
      .data_in(u_intf.data_in),
      .data_out(u_intf.data_out),
      .tx(u_intf.tx),
      .rx(u_intf.rx),
      .trig_start(u_intf.trig_start)
   );

endmodule

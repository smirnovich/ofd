`include "vunit_defines.svh"
`timescale 1ns / 1ps


module top_ofd_uart_tb();

//parameter string runner_cfg;

//`TEST_SUITE begin


localparam BAUDRATE = 115200;
localparam CLK_FREQ = 100000000;

logic clk;
logic reset;
logic [7:0] data_in;
logic tx;
logic rx;
logic trig_start;

localparam T = 10ns;
localparam N_BITS = 8;

top_ofd_uart top_ofd(
.clk(clk),
.reset(reset),
.data_in(data_in),
.tx(tx),
.rx(rx),
.trig_start(trig_start)
);




//CLOCK
always begin
    clk = 1'b1;
    #(T/2);
    clk = 1'b0;
    #(T/2);
end

   

// INITIAL RESET
    always begin
        reset = 0;
        #10ns;
        reset = 1;
        #30ns;
        reset = 0;
        #30ms;
    end


    always begin
        trig_start = 1'b0;
        data_in = {8{1'b0}};
        @(negedge(reset));
        repeat(1)@(posedge(clk));
        trig_start = 1'b1;
        repeat(32) begin
            data_in = data_in + 27;
            @(posedge(clk));
        end
        //trig_start = 1'b0;
        #100ms;
        trig_start = 1'b0;
        $display("smirnovich INFO: TEST FINISHED");
    $stop;
    end




    typedef enum {idle,s1,s2} tx_check;
    tx_check tx_check_fsm = idle;
    logic tx_prev = 1'b1;
    integer counter_tx = 0;
    integer counter_bits = 0;
    logic [7:0] data_sent = 8'h00;
    logic [7:0] data_TX = 8'h00;
    // UART TX test
    logic mystrob = 1'b0;
    
    //start VUnit
    `TEST_SUITE begin
        @(posedge(clk));
        
        if (counter_tx >= CLK_FREQ/(2*BAUDRATE)) begin
            counter_tx <= 0;
            tx_prev <= tx;
        case (tx_check_fsm)
            idle: begin
                counter_bits  <= 0;
                mystrob <= 1'b0;
                if ((tx_prev == 1'b1) & (tx == 1'b0))
                    tx_check_fsm <= s1;
            end
            s1: begin
                if (counter_bits == 16) begin
                    tx_check_fsm <= s2;
                    $display("UART byte read 0x%h",data_sent);
                end else begin
                // $display("UART bit read always tx 0x%h",tx);
                    if ((counter_bits+1)%2 == 0) begin
                    data_sent[(counter_bits+1)/2-1] <= tx;
                    $display("UART even bit read tx 0x%h",tx);
                    mystrob <=1'b1;
                    end
                end
                counter_bits <= counter_bits + 1;
            end
            s2: begin
                //counter_bits <= counter_bits + 1;
                data_TX <= data_sent;
                //if (counter_bits == 16)
                tx_check_fsm <= idle;
            end
        endcase
        end
        else begin
            counter_tx <= counter_tx + 1;
            mystrob <= 1'b0;
        end

    //end VUnit
    end
endmodule

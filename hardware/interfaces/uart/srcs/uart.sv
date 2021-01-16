`timescale 1ns / 10ps
// Basic UART TX

module uart #(
parameter BAUDRATE = 115200,
          CLK_PERIOD = 100000000

)(
    input clk,
    input reset,
    input rx,
    output logic tx,
    input logic [7:0] data_in,
    output logic [7:0] data_out,
    input run,
    output logic tx_ready,
    output logic rx_ready
    );


integer counter;
integer tx_bit_counter;
integer rx_bit_counter;
logic baud_strobe;
logic run_flag;
logic [8:0] data2send;
logic [7:0] data_received;
typedef enum { st_idle, st_send, st_fin } uart_fsm;
uart_fsm tx_fsm, rx_fsm;


assign data_out = counter;
    always_ff@(posedge(clk),posedge(reset)) begin
        if (reset) begin
            counter <= 0;
            baud_strobe <= 0;
        end
        else begin
            if (run_flag == 1) begin
                if (counter == CLK_PERIOD/(BAUDRATE)) begin
                    counter <= 0;
                    baud_strobe <= 1'b1;
                end
                else begin
                    baud_strobe <= 1'b0;
                    counter <= counter + 1;
                end
            end
            else
                counter <= 0;
        end
    end

    //***********
    // TX
    //***********
    always_ff@(posedge(clk),posedge(reset)) begin 
        if (reset) begin
            tx_fsm <= st_idle;
            run_flag <= 0;
            tx <= 1'b1;
            tx_bit_counter <= 0;
            data2send <= 0;
            tx_ready <= 1'b1;
        end
        else begin    
            case(tx_fsm)
                st_idle: begin
                    if (run == 1) begin
                        tx_fsm <=st_send;
                        run_flag <= 1;
                        data2send <= {1'b0, data_in};
                        tx_ready <= 0;
                        tx <= 1'b0;
                        tx_bit_counter <= 0;
                    end
                end
                st_send: 
                    if (baud_strobe == 1) begin
                        if (tx_bit_counter == 8)
                            tx_fsm <= st_fin;
                        else begin
                            tx <= data2send[tx_bit_counter];
                            tx_bit_counter <= tx_bit_counter + 1;
                        end
                    end
                st_fin: begin
                    tx <= 1'b1;
                    if (baud_strobe == 1) begin
                        tx_fsm <= st_idle;
                        run_flag <= 0;
                        tx_ready <= 1;
                    end
                end
            endcase
        end
    end

endmodule
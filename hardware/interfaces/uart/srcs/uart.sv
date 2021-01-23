`timescale 1ns / 10ps
// Basic UART TX

module uart #(
parameter BAUDRATE = 115200,
          CLK_PERIOD = 100000000

)(
    input clk,
    input reset,
    input logic rx,
    output logic tx,
    input logic [7:0] data_tx,
    output logic [7:0] data_rx,
    input run,
    output logic tx_ready,
    output logic rx_ready
    );


integer tx_counter;
integer rx_counter;
integer tx_bit_counter;
integer rx_bit_counter;
logic tx_baud_strobe;
logic rx_baud_strobe;
logic tx_run_flag;
logic rx_run_flag;
//TX
logic [8:0] data2send;
logic [8:0] data_received;
typedef enum { st_idle, st_data, st_fin } uart_fsm;
uart_fsm tx_fsm, rx_fsm;

//2ff-sync for rx

logic rx_ff_buf;
logic rx_ff;

//assign data_rx = tx_counter;
    always_ff@(posedge(clk),posedge(reset)) begin
        if (reset) begin
            tx_counter <= 0;
            tx_baud_strobe <= 0;
        end
        else begin
            if (tx_run_flag == 1) begin
                if (tx_counter == CLK_PERIOD/(BAUDRATE)) begin
                    tx_counter <= 0;
                    tx_baud_strobe <= 1'b1;
                end
                else begin
                    tx_baud_strobe <= 1'b0;
                    tx_counter <= tx_counter + 1;
                end
            end
            else
                tx_counter <= 0;
        end
    end

    //***********
    // TX
    //***********
    always_ff@(posedge(clk),posedge(reset)) begin 
        if (reset) begin
            tx_fsm <= st_idle;
            tx_run_flag <= 0;
            tx <= 1'b1;
            tx_bit_counter <= 0;
            data2send <= 0;
            tx_ready <= 1'b1;
        end
        else begin    
            case(tx_fsm)
                st_idle: begin
                    if (run == 1) begin
                        tx_fsm <=st_data;
                        tx_run_flag <= 1;
                        data2send <= {1'b0, data_tx};
                        tx_ready <= 0;
                        tx <= 1'b0;
                        tx_bit_counter <= 0;
                    end
                end
                st_data: 
                    if (tx_baud_strobe == 1) begin
                        if (tx_bit_counter == 8)
                            tx_fsm <= st_fin;
                        else begin
                            tx <= data2send[tx_bit_counter];
                            tx_bit_counter <= tx_bit_counter + 1;
                        end
                    end
                st_fin: begin
                    tx <= 1'b1;
                    if (tx_baud_strobe == 1) begin
                        tx_fsm <= st_idle;
                        tx_run_flag <= 0;
                        tx_ready <= 1;
                    end
                end
            endcase
        end   
    end


    //***********
    // RX
    //***********
    always_ff@(posedge(clk),posedge(reset)) begin
        if (reset) begin
            rx_counter <= 0;
            rx_baud_strobe <= 0;
        end
        else begin
            if (rx_run_flag == 1) begin
                if (rx_counter == CLK_PERIOD/(2*BAUDRATE)) begin //2x frequency to get the data from the middle of the bit
                    rx_counter <= 0;
                    rx_baud_strobe <= 1'b1;
                end
                else begin
                    rx_baud_strobe <= 1'b0;
                    rx_counter <= rx_counter + 1;
                end
            end
            else
                rx_counter <= 0;
        end
    end


    always_ff@(posedge(clk),posedge(reset)) begin 
        if (reset) begin
            rx_fsm <= st_idle;
            rx_run_flag <= 0;
            rx_bit_counter <= 0;
            data2send <= 0;
            tx_ready <= 1'b1;
        end
        else begin    
        //2-ff sync for RX
        rx_ff_buf <= rx;
        rx_ff <= rx_ff_buf;

            case(rx_fsm)
                st_idle: begin
                    if (rx_ff == 1'b1 & rx_ff_buf == 1'b0) begin
                        rx_fsm <=st_data;
                        rx_run_flag <= 1;
                        rx_ready <= 0;
                        rx_bit_counter <= 0;
                    end
                end
                st_data: begin
                    if (rx_baud_strobe == 1) begin
                        if (rx_bit_counter == 17)
                            rx_fsm <= st_fin;
                        else begin
                            if (rx_bit_counter%2 ==0) begin
                                data_received[rx_bit_counter/2] <= rx_ff;
                            end
                            rx_bit_counter <= rx_bit_counter + 1;
                        end
                    end
                end
                st_fin: begin
                    if (rx_baud_strobe == 1'b1) begin
                        rx_fsm <= st_idle;
                        rx_run_flag <= 0;
                        rx_ready <= 1;
                        data_rx <= data_received[8:1];
                    end
                end
            endcase
        end   
    end
endmodule
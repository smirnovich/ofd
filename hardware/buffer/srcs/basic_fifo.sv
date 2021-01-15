`timescale 1ns / 10ps
// This is a basic FIFO for testing

module basic_fifo #(
parameter N_BIT = 8
)(
    input clk, reset,
    input en, read_val,
    input logic [N_BIT-1:0] data_in,
    output logic [N_BIT-1:0] data_out,
    output logic overflowed,
    output logic is_empty
    );

logic [N_BIT-1:0] data_mem [31:0];
integer pointer_in, pointer_out;

always_ff@(posedge(clk), posedge(reset)) begin
    if (reset) begin
        pointer_in <= 0;
        pointer_out <= 0;
        overflowed <= 1'b0;
        is_empty <= 1'b1;
    end
    else begin
        
        if ((pointer_out - pointer_in) >= 31) begin
            overflowed <= 1'b1;
        end
        else begin
            overflowed <= 1'b0;
            if (en) begin
            pointer_in <= pointer_in + 1;
            data_mem[pointer_in] <= data_in;
            end
        end
        
        
        if (pointer_in != pointer_out) begin
            if (read_val) begin
            data_out <= data_mem[pointer_out];
            pointer_out <= pointer_out + 1;
            end
            is_empty <= 1'b0;
        end
        else is_empty <= 1'b1;

    end
end


endmodule
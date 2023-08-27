module vbp_handler #(
    parameter WIDTH_IN = 32,
    parameter WIDTH_OUT = 32,
    parameter logic DEFAULT_OUT = 0
  )
  (
    input logic clk,
    input logic rst,
    input [7:0] rx_data,
    input rx_ready,
    output [7:0] tx_data,
    input  tx_run,
    input logic [WIDTH_IN-1:0] in_data,
    output logic [WIDTH_OUT-1:0] out_data = DEFAULT_OUT
  );

  logic [WIDTH_IN-1:0] lockedDataIn;
  logic [WIDTH_OUT-1:0] lockedDataOut;
  logic flag2capturein;
  logic flag2writeout;
  typedef enum { st_idle, st_decode_command,st_prep_data_in, st_set_data_out} t_data_fsm;
  t_data_fsm fsm_handl;


  // UART packets handler
  always_ff@(posedge(clk), negedge(rst))
  begin
    if (rst)
    begin
      tx_run <= 1'b0;
      tx_data <= 8'b0;
      fsm_handl <= st_idle;
    end
    else
    begin
      case (fsm_handl)
        st_idle:
        begin

        end
        st_decode_command:
        begin
        end
        st_prep_data_in:
        begin
        end
        st_set_data_out:
        begin
        end
        default:
        begin
          fsm_handl <= st_idle;
        end
      endcase
    end

  end

  // !TODO create timeout watchdog on data from interface
  always_ff@(posedge(clk), negedge(rst))
  begin


  end


  // DATA handler
  always_ff@(posedge(clk), negedge(rst))
  begin
    if (rst)
    begin
      out_data <= DEFAULT_OUT;
    end
    else
    begin
      if (flag2capturein)
      begin
        lockedDataIn <= in_data;
      end
      if (flag2writeout)
      begin
        lockedDataOut <= out_data;
      end
    end

  end


endmodule;

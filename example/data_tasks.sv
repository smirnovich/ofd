package data_tasks;



//-----------------------
// Check 1 byte receive
//-----------------------
task automatic uart_rx_check(input integer data, ref rx, ref reset);
      integer time_per_bit;
      time_per_bit = (100000000/115200);
      
      reset = 1'b0;
      #(2*10ns);
      reset = 1'b1;
      #(2*10ns);
      reset = 1'b0;
      #(2*10ns);
      
      $display("IFNO: reset done");
      #(2*10ns);
      rx = 1'b0;
      #(time_per_bit * 10ns);

      for (int i=0; i<8; i++) begin
         rx = data[i];
         #(time_per_bit * 10ns);
      end
      rx = 1'b1;
      #(time_per_bit * 10ns);
      $display("IFNO: data sent");
   endtask


//-----------------------
// Check 1 byte transmit
//-----------------------
task automatic uart_tx_check(input integer data, ref logic tx, ref logic reset, ref trig_start, ref logic [7:0] data_in);
      logic datafromtx;
      integer time_per_bit;
      time_per_bit = (100000000/115200);
      reset = 1'b0;
      #(2*10ns);
      reset = 1'b1;
      #(2*10ns);
      reset = 1'b0;
      #(2*10ns);
      $display("IFNO: reset done");
      data_in = data;
      #(2*10ns);
      trig_start = 1'b1;
      #(time_per_bit/2*10ns); 
      trig_start = 1'b0;
      #(time_per_bit*10ns); //start bit
      for (int i=0; i<8; i++) begin
         datafromtx = tx;
         #(time_per_bit * 10ns);
      end
      if (tx == 1'b1) begin
         $display("IFNO: data2tx: 0x%h", data);
      //   `CHECK_EQUAL(datafromtx, data2tx);
      end
      else begin
      //    `CHECK_EQUAL(datafromtx,data2tx);
         $warning("ERROR: no stop bit detected");
      end
   endtask

//-----------------------
// Check FIFO overflow
//-----------------------

task automatic fifo_ovflw_check();
    
endtask

endpackage
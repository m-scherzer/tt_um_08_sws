// Digital_top testbench, Maximilian Scherzer, Jan 2024

`timescale 1us / 100ns

module digital_top_tb;

    parameter sys_clk_period = 1_0; // 1.0 us period (1 MHz oscillator clock)

    reg sys_clk;  // oscillator clock
    reg reset;    // power on reset

    // Instantiate the DUT (Device Under Test)
    digital_top #(
        //.k(4)
    ) DUT (
        .i_sys_clk(sys_clk),
        .i_reset(reset),
        .o_cs_cell_hi(),  // Unused outputs can be left unconnected
        .o_cs_cell_lo()
    );

    // Clock signal generation
    initial begin
        sys_clk = 0;
        forever begin
            #(sys_clk_period / 2) sys_clk = ~sys_clk;
        end
    end

    // Power-on reset signal generation
    initial begin
        reset = 1;
        #20; // 20 us
        reset = 0;
        
    end
       
   initial begin
      $dumpfile("digital_top_tb.vcd");
      $dumpvars;
   end
   
   
   initial begin
   #500; // Wait a long time in simulation units (adjust as needed).
   $display("Caught by trap");
   $finish;
 end

    
endmodule






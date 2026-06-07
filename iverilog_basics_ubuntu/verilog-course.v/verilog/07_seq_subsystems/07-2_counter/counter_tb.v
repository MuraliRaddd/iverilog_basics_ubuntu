// Design:      counter
// File:        counter_tb.v
// Description: Up/down counter. Test bench.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        22-12-2010 (initial version)

/*
   Lesson 7.2: Up/down counter

   This file contains a test bench for the module in file 'counter.v'.
 */
`timescale 1ns / 1ps

// Test bench

module test();

    reg clk = 0;    // clock
    reg cl = 0;     // clear
    reg en = 0;     // enable
    reg ud = 0;     // count direction (0-up, 1-down)
    wire [3:0] z;   // counter output (count state)
    wire c;         // end of count

    // Instantiation of the Unit Under Test
    /* We instantiate a 4-bit counter (modulus-16), not the default
     * 8-bit counter. */
    counter #(4) uut(.clk(clk), .cl(cl), .en(en), .ud(ud), .z(z), .c(c));

    // Simulation output control
    initial begin
        // Generamos formas de onda para visualización posterior
        $dumpfile("counter_tb.vcd");
        $dumpvars(0, test);

        /* No text output this time */
    end

    /// Clock signal with a period of 20ns (f=50MHz)
    always
        #10 clk = ~clk;

    // Inputs
    initial begin
        @(negedge clk)
        cl = 1;             // clear
        @(negedge clk)
        cl = 0;             // count up for 20 cycles
        en = 1;
        repeat(20) @(negedge clk);
        ud = 1;             // count down for 8 cycles
        repeat(8) @(negedge clk);
        en = 0;             // clear
        cl = 1;
        @(negedge clk);
        cl = 0;
        repeat(2) @(negedge clk);
        $finish;
    end

endmodule // test


/*
   EXERCISES

   1. Compile and simulate the example with:

      $ iverilog counter.v counter_tb.v
      $ vvp a.out

   2. Display the results and check the correct operation with:

      $ gtkwave counter_tb.vcd

   3. Modify the desing to include a 'load' signal that makes the counter to
      load a count state from input 'x'. The operation should have higher
      priority than the count operations but less than the clear operation.

   4. Modify the original design to obtain a modulus-10 counter (0 to 9). Pay
      attention to the end-of-count signal.
*/

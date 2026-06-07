// Design:      block
// File:        block_tb.v
// Description: Asignación con y sin bloqueo
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        05/06/2010 (initial version)

/*
   Lesson 6.3: Blocking and non-blocking assignments.

   This file is a test bench for the modules in 'block.v'. This file
   instantiates the modules swap1 and swap2 to compare their operation.
   swap2 uses non-blocking assignments and should give the expected result,
   while swap1 uses blocking assignments and should give the wrong result.
*/

`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;    // clock
    reg load = 0;   // load input
    reg d = 0;      // data input
    wire y1, y2;    // swap1 output
    wire z1, z2;    // swap2 output

    swap1 uut_s1(.clk(clk), .load(load), .d(d), .q1(y1), .q2(y2));
    swap2 uut_s2(.clk(clk), .load(load), .d(d), .q1(z1), .q2(z2));

    // Clock signal
    /* In swap mode the flip-flops in each module must swap their
     * states with each active edge of the clock. */
    always
        #10 clk = ~clk;

     // Output generation and simulation control
    initial begin
        // Waveform generation
        $dumpfile("block_tb.vcd");
        $dumpvars(0, test);

        // Inputs
        #0
        /* We initialize both flip-flops to zero by making d=0
         * and activating the load signal for two clock cycles. */
        load = 1;
        d = 0;
        #40
        /* Load '1' in the first flip-flop. */
        d = 1;
        #20
        /* We switch to swap mode with one flip-flop
         * at '0' and another one at '1'. */
        load = 0;

        // Simulation ends
        #120 $finish;
    end
endmodule // test


/*
   EXERCISES

   1. Compile and simulate the design with:

        $ iverilog block.v
        $ vpp a.out

   2. Take a look at the waveforms and compare the outputs of both circuits
      with:

        $ gtkwave block_tb.vcd

   3. Try to explain why the outputs of the first swapper (y1, y2) are
      different to the second swapper (z1, z2).
*/

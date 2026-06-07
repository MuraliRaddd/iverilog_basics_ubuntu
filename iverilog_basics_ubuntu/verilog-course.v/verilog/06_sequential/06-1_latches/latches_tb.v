// Design:      latches
// File:        latches_tb.v
// Description: Latches examples
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        25-11-2010 (initial version)

/*
   Lesson 6.1. Latches

   This is a test bench for modules in 'latches.v'. The test bench compares
   the operation of different types of SR latches under the same input
   conditions in order to demonstrate the differences among the different
   triggering techniques.
 */

`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;            // clock
    reg s = 0;              // set
    reg r = 0;              // reset
    wire qa, qg, qms, qff;  // latch outputs

    // Latch instantiation
    /* Asynchronous latch */
    sra uut_sra(.s(s), .r(r), .q(qa));
    /* Gated latch */
    srg uut_srg(.clk(clk), .s(s), .r(r), .q(qg));
    /* Master-Slave latch */
    srms uut_srms(.clk(clk), .s(s), .r(r), .q(qms));
    /* Edge-triggered latch (flip-flop) */
    srff uut_srff(.clk(clk), .s(s), .r(r), .q(qff));

    // Simulation output and control
    initial	begin
        // Waveform generation
        $dumpfile("latches_tb.vcd");
        $dumpvars(0, test);

        // Text output
        $display("      time  clk s r   qa  qg  qms qff");
        $monitor("%d  %b   %b %b   %b   %b   %b   %b",
                   $stime, clk, s, r, qa, qg, qms, qff);

        // Control inputs
        /* 's' and 'r' are changed to produce state changes in
         * various conditions. Delays are relative to the previous
         * assignments. Absolute times are shown as comments. */
        #8  r = 1;    // t = 8
        #17 r = 0;    // t = 25
        #9  s = 1;    // t = 34
        #2  s = 0;    // t = 36
        #8  r = 1;    // t = 44
        #2  r = 0;    // t = 46
        #6  s = 1;    // t = 52

        // Simulation ends
        #20 $finish;
    end

    // Periodic clock signal (20ns period)
    always
        #10 clk = ~clk;

endmodule // test

/*
   EXERCISES

   1. Compile and simulate the examples with:

        $ iverilog latches.v latches_tb.v
        $ vvp a.out

   2. Display the results and compare the output of the latches with:

        $ gtkwave test.vcd

   3. Modify the design to simulate:
      - An asynchronous SR latch with active-low inputs.
      - A gated SR latch with active-low clock signal.
      - A M-S SR latch with active-low clock signal.
      - A SR flip-flop with positive edge active clock signal.
*/

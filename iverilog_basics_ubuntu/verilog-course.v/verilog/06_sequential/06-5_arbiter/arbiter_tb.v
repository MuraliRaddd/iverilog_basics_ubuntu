// Design:	    arbiter
// File:        arbiter_tb.v
// Description: Finite State Machine (FSM). Arbiter example.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        01-12-2010 (initial version)

/*
   Lesson 6.5: Finite State Machine (FSM). Arbiter example.

    This file contains a test bench for modules in 'arbiter.v'.
 */

`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;    // clock
    reg r1 = 0;     // request 1
    reg r2 = 0;     // request 2
    wire g1;        // grant 1
    wire g2;        // grant 2

    // Unit under test
    arbiter1 uut(.clk(clk), .r1(r1), .r2(r2), .g1(g1), .g2(g2));

    // Waveform generation and simulation control
    initial begin
        $dumpfile("arbiter_tb.vcd");
        $dumpvars(0, test);

        #240 $finish;
    end

    // Clock signal
    always
        #10 clk = ~clk;

    // Device 1 requests
    /* Device 1 and device 2 requests are generated separately. We use a
     * "fork-join" block so that the time references in the assignments are
     * absolute times and not relative to the previous assignment, as we
     * have seen in lesson 6.2. */
    initial fork
        #20  r1 = 1;
        #40  r1 = 0;
        #100 r1 = 1;
        #120 r1 = 0;
        #180 r1 = 1;
        #200 r1 = 0;
    join

    // Device 2 requests
    initial fork
        #60  r2 = 1;
        #80  r2 = 0;
        #110 r2 = 1;
        #140 r2 = 0;
        #180 r2 = 1;
        #220 r2 = 0;
    join
endmodule

/*
   EXERCISES

   1. Simulate the design and check the operation by displaying the inputs,
      outputs and internal state of the "arbiter1" module.

   2. Detect and correct an error in module "arbiter1". Simulate again.

   3. Substitute the "arbiter1" module by "arbiter2" in the test bench and
      simulate again. Is the result correct?

   4. Compare the results of modules 'arbiter1' and 'arbiter2'. To do so,
      modify the test bench to display the outputs of both modules at the same
      time or just simulate them in turn.

      a) Are the results for "arbiter1" and "arbiter2" identical?
      b) Are they equivalent?
      c) Think about what implementation is more apropriate in this case,
         Mealy's (arbiter1) or Moore's (arbiter2).
*/

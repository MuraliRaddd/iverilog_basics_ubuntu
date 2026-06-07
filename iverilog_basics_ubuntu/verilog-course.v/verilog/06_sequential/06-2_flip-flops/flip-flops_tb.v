// Design:      flip-flops
// File:        flip-flops_tb.v
// Description: Flip-flop examples. Test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        25-11-2010 (initial version)
/*
   Lesson 6.2: Flip-flops

   This file includes a test bench for modules in 'flip-flops.v' in order to
   compare the operation of various flip-flops.
 */

`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;    // clock
    reg j = 0;      // set input (JK FF)
    reg k = 0;      // reset input (JK FF)
    reg d = 0;      // data input (D FF)
    wire s;         // set input (SR FF)
    wire r;         // reset input (SR FF)
    wire t;         // toggle input (T FF)
    reg cl = 1;     // asynchronous clear (all FF's)
    reg pr = 1;     // asynchronous preset (all FF's)
    wire qsr, qjk, qd, qt;  // flip-flops output terminals

    // Some inputs are shared by some flip-flops
    assign s = j;
    assign r = k;
    assign t = d;

    // Flip-flop instantiation
    srff uut_srff(.clk(clk), .s(s), .r(r), .cl(cl), .pr(pr), .q(qsr));
    jkff uut_jkff(.clk(clk), .j(j), .k(k), .cl(cl), .pr(pr), .q(qjk));
    dff uut_dff(.clk(clk), .d(d), .cl(cl), .pr(pr), .q(qd));
    tff uut_tff(.clk(clk), .t(t), .cl(cl), .pr(pr), .q(qt));

    // Simulation control
    initial begin
        // Waveform generation
        $dumpfile("flip-flops_tb.vcd");
        $dumpvars(0, test);

        // Simulation ends
        #180 $finish;
    end

    // Asynchronous clear and preset control
    /* fork-join delimited blocks are similar to begin-end blocks, but make
     * all the statements in the process to execute concurrently. Thus, delay
     * times in the process are relative to the process start not to the
     * previous delay. */
    initial fork
        #5   cl = 0;
        #20  cl = 1;
        #140 pr = 0;
        #160 pr = 1;
    join

    // JK and SR input control (s=j, r=k)
    initial fork
        #20  j = 1;
        #40  j = 0;
        #60  k = 1;
        #80  k = 0;
        #100 j = 1;
        #100 k = 1;
        #160 j = 0;
        #160 k = 0;
    join

    // D and T input control
    initial fork
        #20  d = 1;
        #40  d = 0;
        #80  d = 1;
        #140 d = 0;
    join

    // Clock signal generation (20ns period)
    always
        #10 clk = ~clk;

endmodule // test

/*
   EXERCISES

   1. Compile and simulate the examples with:

        $ iverilog flip-flops.v flip-flops_tb.v
        $ vvp a.out

   2. Display the results and compare the output of the latches with:

        $ gtkwave flip-flops_tb.vcd

   3. Make a descriptions of JK, D and T flip-flops triggered by a negative
      clock edge. Write an appropriate test bench and check the design.
*/

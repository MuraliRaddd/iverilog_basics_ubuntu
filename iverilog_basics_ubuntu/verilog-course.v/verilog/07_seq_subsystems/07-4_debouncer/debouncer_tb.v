// Design:      debouncer
// File:        debouncer_tb.v
// Description: Counter-based debouncer and edge detector.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        21-12-2011 (initial version)

/*
   Lesson 7.4: Debouncers and edge detectors.

   This file contains a test bench for modules in file 'debouncer.v'.
*/

`timescale 1ns / 1ps

// Test bench

module test();

    reg ck;     // clock
    reg x;      // input
    wire z0;    // debouncer output
    wire z;     // edge detector output

    // Units under test
    /* We use 5 for the number of cycles to wait before changing the
     * output. The default value of 50000 would make the simulation to
     * take much more time. */
    debouncer #(5) deb1 (.ck(ck), .x(x), .z(z0));
    /* The edge detector is connected after the debouncer to generate a
     * single cycle positive pulse for every key press. */
    edge_detector ed1 (.ck(ck), .x(z0), .z(z));

    // Clock signal with a period of 20ns (f=50MHz)
    always
        #10 ck = ~ck;

    // Waveform generation and simulation control
    initial begin
        // Waveform generation
        $dumpfile("debouncer_tb.vcd");
        $dumpvars(0, test);

        // Clock initialization
        ck = 0;

        // Input
        /* Input is changed repeatedly generating pulses of different widths.
         * Only pulses greater than 100ns (5*20) should make the output to
         * change. */
        #0      x = 0;
        #200    x = 1;      // button is pressed, bounces start
        #15     x = 0;
        #15     x = 1;
        #40     x = 0;
        #30     x = 1;
        #80     x = 0;
        #30     x = 1;      // 'x' stabilizes at '1'
        #300	x = 0;      // button is released, bounces start
        #10     x = 1;
        #40     x = 0;
        #70     x = 1;
        #15     x = 0;      // 'x' stabilizes at '0'
        #200    x = 1;      // button is pressed again, no bounces this time
        #200    x = 0;      // button is released, no bounces this time
        #200    $finish;    // simulation ends
    end
endmodule

/*
   EXERCISES

   2. Compile and simulate the examples with:

      $ iverilog debouncer.v debouncer_tb.v
      $ vvp a.out

   3. Display the results with:

      $ gtkwave test.vcd

      Compare the noisy input 'x' to the clean output 'z0' and the pulse output
      'z'.

   4. Modify the test bench to instantiate a debouncer with different delays
      (You may try values 3, 7 and 12 for example) and see what happens to the
      simulation results.

   5. Modify the edge detector design to include two parameters "detect" and
      "mode":

      - detect=0: detect falling edge
      - detect=1: detect rising edge
      - mode=0: output is normally 1, detection makes a negative output pulse
      - mode=1: output is normally 0, detection makes a positive output pulse

      Default values should be detect=1, mode=1. Check the design with a
      suitable test bench.
*/

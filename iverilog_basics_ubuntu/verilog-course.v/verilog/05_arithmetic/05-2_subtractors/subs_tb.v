// Design:      subs
// File:        subs.v
// Description: Combinational subtractor examples in Verilog. Test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        24/11/2023 (initial version)

/*
   Lesson 5.2: Arithmetic circuits. Subtractors.

   This file is a test bench for subtractors.
*/

`timescale 1ns / 1ps

// This test bench applies a configurable number of random input patterns to
// the circuit under test.
// Simulation macros and default values:
//   NP: número de patrones de simulación.
//   SEED: semilla inicial para generación número aleatorios.

`ifndef NP
    `define NP 20	// number of patterns
`endif
`ifndef SEED
    `define SEED 1	// initial seed for random generation
`endif

module test ();

    reg [7:0] a;            // input 'a'
    reg [7:0] b;            // input 'b'
    reg bwin;               // borrow input
    wire [7:0] d;           // output
    wire bwout;             // borrow output
    integer np;             // number of patterns (auxiliary signal)
    integer seed = `SEED;   // seed (auxiliary signal)

    // Circuit under test. Use:
    //   sub8: magnitude subtractor using "-" operator.
    //   sub8_add: magnitude subtractor using "+" operator.
    sub8_add uut(.a(a), .b(b), .bwin(bwin), .d(d), .bwout(bwout));

    initial begin
        /* 'np' is a counter that holds the remaining number of patterns
         * to be applied. The initial value is taken from macro NP. */
        np = `NP;

        // Waveform generation (optional)
        $dumpfile("sumador_tb.vcd");
        $dumpvars(0, test);

        // Console's output printing
        $display("A  B  bwin  s  bwout");
        $display("--------------------");
        $monitor("%h %h %b     %h %b",
                   a, b, bwin, d, bwout);
    end

    // Test generation process
    /* Each 20ns 'a', 'b' and 'cin' are assigned random values. Simulation
     * ends after applying NP patterns. The pattern sequence can be
     * changed by defining a different value for SEED. Macro values NP and SEED
     * can be changed at the top of this file or using compilation options. */
    always begin
        #20
        a = $random(seed);
        b = $random(seed);
        bwin = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

/*
   EXERCISES

   3. Compile the test bench with:

        $ iverilog subs.v subs_tb.v

      and test its operation with:

        $ vvp a.out

      Take a look at the output text and waveforms (with Gtkwave) and check
      that the operation is correct. If not, find out the errors and correct
      them.

   4. Repeat the simulation with different values of NP and SEED and check the
      results. For example:

        $ iverilog -DNP=40 -DSEED=2 adders.v adders_tb.v
        $ vpp a.out

   5. Modify the UUT in order to simulate the sub8_add modules. Check if
      the results are the same to those of the sub8 module.

   6. Modify the test bench to simulate sub8 and sub8_add simultaneously
      using the same input vectors. Check that the results are correct and
      the same in all cases. If not, find out the errors and correct them.
*/

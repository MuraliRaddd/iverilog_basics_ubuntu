// Design:      addsub
// File:        addsub.v
// Description: Signed/unsigned adder-subtractors. Test bench.
// Author:      Jorge Juan <jjchico@gmail.com>
// Date:        22-11-2013 (initial version)

/* Lesson 5.3. Adder-subtractors

   This file contains a test bench for modules 'addsub_su' and 'addsub_s'.
 */

`timescale 1ns / 1ps

// This test bench applies a configurable number of random input patterns to
// the circuit under test.
// Simulation macros and default values:
//   NP: number of test patterns
//   SEED: initial seed for pseudo-random number generation
//   OP: type of operation (OP=0 -> add, OP=1 -> sub)

`ifndef NP
    `define NP 20
`endif
`ifndef SEED
    `define SEED 1
`endif
`ifndef OP
    `define OP 0
`endif

module test ();

    reg signed [7:0] a;     // input 'a'
    reg signed [7:0] b;     // input 'b'
    reg cin;                // carry/borrow input
    reg op = `OP;           // type of operation (0-add, 1-sub)
    wire signed [7:0] r;    // output
    wire cout;              // carry/borrow output
    wire v;                 // overflow output
    integer np;             // number of patterns (auxiliary signal)
    integer seed = `SEED;   // seed (auxiliary signal)

    // Circuit under test
    /* Modules 'addsub_su' and 'addsub_s' have a parameterized data width. Here
     * we instantiate 8-bit modules. You can substitute 'addsub_su' by
     * 'addsub_s' to simulate the alternative implementation. */
    addsub_su #(.N(8)) uut(.a(a), .b(b), .cin(cin),
                           .op(op), .r(r), .cout(cout), .v(v));
    // addsub_s #(.N(8)) uut(.a(a), .b(b), .op(op), .r(r), .v(v));

    initial begin
        /* 'np' is a counter that holds the remaining number of patterns
         * to be applied. The initial value is taken from macro NP. */
        np = `NP;

        // Waveform generation (optional)
        $dumpfile("addsub_tb.vcd");
        $dumpvars(0, test);

        // Output printing
        if (op == 1'b0)
            $display("Operation: ADD");
        else
            $display("Operation: SUBTRACT");

        $display("       A                B         cin",
                 "        R         cout  v");
        $display("-------------------------------------",
                 "-------------------------");
        $monitor("%b (%d)  %b (%d)  %b   %b (%d)  %b     %b",
              a, a, b, b, cin, r, r, cout, v);
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
        cin = $random(seed);
        np = np - 1;
        if (np == 0)
            $finish;
    end
endmodule

/*
   EXERCISES

   2. Compile the test bench with:

        $ iverilog addsub.v addsub_tb.v

      and test its operation with:

        $ vvp a.out

      Take a look at the output text and waveforms (with Gtkwave) and check
      that the operation is correct.

      Also check the subtract opration with:

        $ iverilog -DOP=1 addsub.v addsub_tb.v

   3. Repeat the simulation with different values of OP, NP and SEED and check
      the results. For example:

        $ iverilog -DOP=1 -DNP=40 -DSEED=2 addsub.v addsub_tb.v
        $ vpp a.out

   4. Comment-out the 'asssub_su' instantiation lines and ucomment the 
      instantiation line for the 'addsub_s' module and repeat the previous 
      exercises. Note that 'cin' and 'cout' signals still appear in the
      output listing but they are meaningless now since these are not used
      by the 'addsub_s' module.

   5. Modify the test bench so that it can simulate and 'addsub1' module of
      any number of bits, defined by a macro 'WIDTH'. Try it by simulating
      a 16-bit 'addsub_su' module like:

        $ iverilog -DWIDTH=16 addsub.v addsub_tb.v
*/

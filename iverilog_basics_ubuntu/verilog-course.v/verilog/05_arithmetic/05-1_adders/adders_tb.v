// Design:      adders
// File:        adders_tb.v
// Description: Combinational adder examples in Verilog. Test bench.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        13/11/2010 (initial version)

/*
   Lesson 5.1: Arithmetic circuits. Adders.

   This file is a test bench for adders.
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
    reg cin;                // carry input
    wire [7:0] s;           // output
    wire cout;              // output carry
    integer np;             // number of patterns (auxiliary signal)
    integer seed = `SEED;   // seed (auxiliary signal)

    // Circuit under test. Use:
    //   adder8_s: structural description using FA
    //   adder8_g: structural description using 'generate'
    //   adder8: functional description with arithmetic operators
    adder8_s uut(.a(a), .b(b), .cin(cin), .s(s), .cout(cout));

    initial begin
        /* 'np' is a counter that holds the remaining number of patterns
         * to be applied. The initial value is taken from macro NP. */
        np = `NP;

        // Waveform generation (optional)
        $dumpfile("sumador_tb.vcd");
        $dumpvars(0, test);

        // Console's output printing
        $display("A  B  cin  s  cout");
        $display("------------------");
        $monitor("%h %h %b    %h %b",
                   a, b, cin, s, cout);
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

   3. Compile the test bench with:

        $ iverilog adders.v adders_tb.v

      and test its operation with:

        $ vvp a.out

      Take a look at the output text and waveforms (with Gtkwave) and check 
      that the operation is correct. If not, find out the errors and correct
      them.

   4. Repeat the simulation with different values of NP and SEED and check the 
      results. For example:

        $ iverilog -DNP=40 -DSEED=2 adders.v adders_tb.v
        $ vpp a.out

   5. Modify the test bench to simulate adder8_g and adder8 simultaneously
      using the same input vectors. Check that the results are correct and 
      the same in all cases. If not, find out the errors and correct them.

   6. Add a delay of 1ns to the outputs 's' and 'cout' of module 'fa'. Compare
      the results of adder8_s or adder8_g (should be the same) with those of
      adder8 and figure out what these results mean. Which one is more
      realistic, adder8_s or adder8?
*/

// Design:      primes
// File:        primes.v
// Description: Prime number detector
// Author:       Jorge Juan-Chico <jjchico@gmail.com>
// Date:        09/11/2018 (initial version)

/*
   Lesson 3.2: 4-bit prime number detector.

   This file contains a test bench for module 'primes'.
*/

`timescale 1ns / 1ps

// Base time to easy test pattern specification
`define BTIME 10

module test ();

    // Input
    /* The signal that generates the inputs to our circuit is a 4-bit 
     * variable. */
    reg [3:0] x;

    // Outputs
    wire z;

    // UUT instance
    /* Multi-bit signals are connected like bit signals */
    primes uut (.x(x), .z(z));

    /* The 'initial' process below initializes the test patterns and includes
       the simulation directives. */
    initial begin
        // Input initialization
        x = 4'b0000;
        /* 'x' is initialized to zero by using the zero value in binary
           indicating explicitly that it is a 4-bit signal. The complete 
           format for literal numbers in Verilog is:
         *   <number of bits>'<base><value>
         * where <base> may be, among others:
         *   b: binary
         *   o: octal
         *   h: hexadecimal
         *   d: decimal
         * If <base> is omitted, it is considered decimal. If the number of
         * bits is omitted, the value includes at least 32 bits, but it is 
         * automatically extended if necessary to complete the operations.
         * In general, if the number of bits is known in advance, it is
         * recommended to make it explicit in constants.
         * Alternatively, 'x' could have been initialized like:
         *   x = 4'h00      // hexadecimal
         *   x = 'b0000     // binary, number of bits omitted
         *   x = 0          // base and number of bits omitted. It is assumed
         *                  // a decimal zero with enough bits to assign all
         *                  // the bit of 'x' to zero.
         */

        // Waveform generation
        $dumpfile("primes_tb.vcd");
        $dumpvars(0,test);

        // Text output generation
        /* In this design, the text output is very convenient because it is
         * faster and easier to check than by looking at the detailed signal
         * waveforms. */
        $display("x   z");          // header
        $display("-----");
        $monitor("%d  %b", x, z);

        // Simulation ends
        /* Simulation end time is programmed as a function of 'BTIME'. The
         * value 16*`BTIME is enough for the inputs to go through all possible
         * values. */
        #(16*`BTIME) $finish;
    end

    // Input test pattern generation
    /* To make the input signal to go through all possible values we just 
     * increment 'x' every `BTIME nanoseconds. Multi-bit variables can be
     * used as regular integer variables and can be opperated with arithmetic
     * operators as expected. */
    always
        #(`BTIME) x = x + 1;

endmodule // test

/*
   EXERCISES

   1. Compile the lesson with:

        $ iverilog primes.v primes_tb.v

   2. Simulate the design with:

        $ vvp a.out

      Take a look at the results in the terminal (or console, etc.) and check
      that all results are as expected.

   3. Watch the signals waveforms with:

        $ gtkwave primes_tb.vcd &

      Gtkwave will probably represent signal 'x' in hexadecimal format. You
      can change the representation format by using the 'Data Format' option
      in the contextual menu for signal 'x', e.g. to see it in decimal 
      representation. You can also watch every bit in 'x' by double clicking
      on the signal's name.

   4. The 'case' sentence allow multiple values at each condition. For example:

        case(data)
        1,3,5:   odd = 1'b1;
        0,2,4:   even = 1'b1;
        endcase

      Modify the 'primes' module using this format to simplify the 'case'
      sentence. Do you thing this simplification will make the simulation
      process more efficient? An a possible automatic implementation of
      the module?

   5. Using the 'primes' module as a model, design a combinational circuit
      that takes a 5-bit signal 'x' as input and activates an output signal
      'z' when the input is a multiple of 7. Write a test bench to check that
      the opperation of the circuit is correct.
*/

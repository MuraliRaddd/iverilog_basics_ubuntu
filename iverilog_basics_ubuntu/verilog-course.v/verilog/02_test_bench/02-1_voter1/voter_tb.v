// Design:      voter
// File:        voter_tb.v
// Description: Voter circuit. Simulation with test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        19-10-2010 (initial version)

/*
   Lesson 2.1: Simulation with test bench

   This file contains module 'test', that is a test bench to check the
   correct operation of module 'voter'. This test bench contains three
   main elements: dlkjfldkfj

   - The circuit under test: often an instance of the circuit we want to
     test, defined in as a module in another file.

   - Verilog statements to generate the input signals to be applied to the
     circuit under test.

   - Statements to print or store the behaviour of the circuit during
     simulation in order to check its correct operation.
*/

// Simulation time scale and precision
`timescale 1ns / 1ps

/* A test bench is a module without inputs or outputs. It typically includes
 * only statements to generate test signals and simulator directives to control
 * the simulation process and the generation of results, together with an
 * instance of the module that is to be tested: the Unit Under Test (UUT). */
module test();

    // Internal signals
    /* Signals to make connections to the UUT */
    reg a, b, c;    // inputs to the UUT
    wire f;         // output of the UUT

    // UUT instantiation
    /* The UUT is a voter circuit. The name of the instance is 'uut'. The
     * syntax for instance connection means that:
     *   - z port of the voter is connected to f signal of the TB.
     *   - a, b and c ports of the voter are connected to signals a, b and c
     *     of the TB respectively.
     * As it can be seen, signals can have the same name than module ports
     * because they live in different name spaces. */
    voter uut (.v(f), .a(a), .b(b), .c(c));

    // Signal initialization and simulation control
    /* 'initial' procedure block are run only once. We use it to initialize
     * signals and to execute simulation directives. 'initial' procedures
     * are mostly used in test benches. */
    initial begin
        // Input signal initialization
        a = 0;
        b = 0;
        c = 0;

        // Waveform generation
        $dumpfile("voter_tb.vcd");  // Waveform file
        $dumpvars(0, test);         // signals to plot (everything)

        // We finish simulation at t=100
        #100 $finish;
    end

    /* Generation of input patterns to simulate the UUT */
    // a, b and c will got through all possible combinations
    always
        #5 a = ~a;
    always
        #10 b = ~b;
    always
        #20 c = ~c;

endmodule // test

/*
   EXERCISES

   2. Compile the whole design (voter module and test bench) with the following
      command:

        $ iverilog voter.v voter_tb.v

      Note that the module 'test' in 'voter_tb.v' uses the module 'voter'
      defined in 'voter.v'. The Verilog compilar automatically sorts out
      the dependencies between modules provided that it is given the files
      containing all the needed modules. The compiled design is written to
      file 'a.out'.

   3. Simulate the design with:

        $ vvp a.out

   4. Take a look to the simulation results with:

        $ gtkwave voter_tb.vcd &

   5. Check that the circuit results are correct, that is, that signal 'f' is
      '1' only when two or more inputs are '1'. If it is not the case, revisit
      the design in file 'voter.v', make the necessary corrections and simulate
      again until the result is correct.

      Note: You do not need to exit Gtkwave between simulation runs, jus use
      the option "File->Reload Waveform" or press "Shift+Ctrl+R" to reload the
      new results.
*/

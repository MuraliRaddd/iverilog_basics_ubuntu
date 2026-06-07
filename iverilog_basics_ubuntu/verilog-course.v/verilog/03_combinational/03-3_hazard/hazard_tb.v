// Design:      hazard
// File:        hazard.v
// Description: Hazard demonstrator
// Author: 	    Jorge Juan-Chico <jjchico@gmail.com>
// Date:        09/11/2009 (initial version)

/*
   Lesson 3.3. Combinational examples. Delays and hazards.

   This file contains the test bench for circuits in file 'hazard.v'.
 */

`timescale 1ns / 1ps

// Delay applied to the circuit under test
`ifndef DELAY
    `define DELAY 2
`endif
/* `ifndef es similar a `ifdef but includes the code only if the tested macro
 * has not been defined. Here we use it to define the macro `DELAY only in
 * case it has not been previously defined. This way we can override the value
 * here from a higher level file in the project or from the command line. */

// Base time to simplify test pattern definition
`define BTIME 8 * `DELAY

/* In this example, we use macros to parameterize the simulation process.
 * DELAY is the delay of the logic gates inside our circuit. BTIME is the
 * time the inputs will stay constant. BTIME is defined as a function of
 * DELAY so that it will always have a value big enough to visualize the 
 * signal propagation through all the gates of the circuit. This way, we
 * can simulate the circuit for different values of DELAY without having to
 * chande BTIME manually. */

module test();

	// Inputs
	reg a;
	reg b;

	// Output
	wire f1, f2;

    // Auxiliary simulation variable
    /* 'n' is used here as a counter to count the number of time we change
	 * signal 'a'. It will aid the pattern generation below. It is initialized
	 * to zero. The type 'integer' is equivalent to a 32-bit 'reg'. This type
	 * is useful to represent integer numbers or variables (so its name).
	 * It is similar to type 'int' in C language. */
    integer n = 0;
    /* Alternative definition of 'n' */
    /* reg [31:0] n = 0; */

	// UUT instance
	/* Instantiation of the UUT's is similar to previous examples. The
	 * "#(...)" construction is used to re-define parameters of the module.
	 * If not used, parameters will take its default values defined in the
	 * module's implementation. Parameter values can be specified implicitly
	 * in the order they where defined like "#(3, 7, 9)" or explicitly like
	 * "#(.delay(3), .width(9))". Here we use the value defined in the macro
	 * "DELAY" to select the delay for the instance */
    hazard_f uut1 (.a(a), .b(b), .f(f1));
    hazard_e #(.delay(`DELAY)) uut2 (.a(a), .b(b), .f(f2));

	// Test pattern initialization and simulation control
	initial begin
		// Input initialization
		a = 0;
		b = 0;

		// Waveform output
		$dumpfile("hazard_tb.vcd");
		$dumpvars(0,test);

		// Simulation end
		/* Simulation finishes after 7 time `BTIME which is enough to
		 * check all the interesting cases. */
		#(7*`BTIME) $finish;
	end

    /* The following 'always' processes make variables 'a' and 'b' to change 
     * from '0' to '1' and from '1' to '0' when the other variable is both 
     * '0' and '1', thus making it possible to detect any hazard that may
     * happen. */
    // 'a' changes between '0' and '1'. 'n' counts the number of changes.
    always
    begin
        #(`BTIME) a = ~a;
        n = n + 1;
    end
    // 'b' changes every time 'a' changes with a delay of BTIME/2, except
    // when 'a' has changed 3 times. This way, we go through all possible
    // cases: we test both edges of a signal for all possible values of the
    // other signal, both for 'a' and 'b'.
    always @(a)
        if (n != 3)
            #(`BTIME/2) b = ~b;
endmodule // test

/*
   EXERCISES

   1. Compile the example with:

        $ iverilog hazard_tb.v hazard.v

   2. Simulate the design with:

        $ vvp a.out

   3. Plot the resulting waveforms with:

        $ gtkwave test.vcd &

      Study the waveforms an locate the possible hazard.

   4. Compile the design using a different value for the delay. For example:

        $ iverilog -DDELAY=1 hazard_tb.v hazard.v
   
      Simulate and plot the resulting waveforms for different values of the
      delay. What happens if we simulate with a zero delay? Why?

   5. Add and 'always' process to the test bench that detects when a hazard 
      takes place, printing a message and the time the hazard occurs.
      For example:

        "Hazard at t=... for a=..., b=..., f=..."

      Clue: activate the 'always' process each time 'f2' changes and check if
      this values is the final correct value by comparing with 'f1'.
*/

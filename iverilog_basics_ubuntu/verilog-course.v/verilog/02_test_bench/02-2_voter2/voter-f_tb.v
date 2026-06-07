// Design:      voter
// File:        voter-f_tb.v
// Description: Simulation with test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        15-10-2010 (original version)

/*
   Lesson 2.2: Simulation with test bench

   In this file we define a test bench to simulate and compare the results of
   the two implementations of the voter circuit: the procedural desciption in
   module 'voter' and the functional description in module 'voter_f'.

   In this test bench we will instantiate both modules and will generate
   input signals that will be applied to both modules at the same time.
 */

// Time scale and resolution for simulation
`timescale 1ns / 1ps

module test ();

	// Internal signals
    //   inputs: a, b, c
    //   outputs: v, v_f
	reg a, b, c;
	wire v, v_f;

	// Units Under Test (UUT) instances
    /* This time we instantiate an UUT for each version of the voter */
	voter uut (.v(v), .a(a), .b(b), .c(c));
    voter_f uutf (.v(v_f), .a(a), .b(b), .c(c));

	// Signal initialization and simulation control
	initial begin
		// Input signal initialization
		a = 0;
		b = 0;
		c = 0;

		// Waveform generation
		$dumpfile("voter-f_tb.vcd");
		$dumpvars(0, test);

		// Simulation finishes at t=100
		#100 $finish;
	end

	// Input signal generation: all combinations of a, b and c
	always
		#5 a = ~a;
	always
		#10 b = ~b;
	always
		#20 c = ~c;

endmodule // test

/*
   EXERCISES

   2. Compile the whole design (voter modules and test bench) with the
      following command:

        $ iverilog ../02-1_voter1/voter.v voter-f.v voter-f_tb.v

   3. Simulate the design with:

 	    $ vvp a.out

   4. Plot the simulation results with:

 	    $ gtkwave test.vcd &

      Check that the results are correct, that is, that the outputs 'v' and
      'v_f' are '1' whenever two or more of the inputs are '1'. If the results 
      are not correct check the design description in voter-f.v, make the
      necessary corrections and check again until the operation is correct.

      Note: you can reread the new simulation results without need to close
      Gtkwave by using the option "File->Reload Waveform" or by pressing
      "Shift+Ctrl+R".

   5. Design a 5-input voter circuit with inputs (a, b, c, d, e) so that its
      output 'v' is '1' whenever 3 or more inputs are '1'. Design a test bench
      for the module in a different file in order to check the correct 
      operation of the circuit in all cases. Make the test bench to output
      the results in test format (using '$monitor') and in an waveform file.
*/

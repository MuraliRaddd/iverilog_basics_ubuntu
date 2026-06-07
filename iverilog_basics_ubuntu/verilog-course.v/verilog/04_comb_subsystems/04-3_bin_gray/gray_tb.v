// Design: 	    gray
// File:        gray_tb.v
// Description: Parametrized bin/gray converters. Test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        12/11/2011 (initial version)

`timescale 1ns / 1ps

// Base time to easy simulation control
`define BTIME 10

module test();

	// Inputs
	reg [3:0] x;

	// Output
	wire [3:0] z_gray, z_bin;

	// Circuit under test: cascade connection of bin/gray and gray/bin
	// converters.
	bin_to_gray bin_to_gray1 (.x(x), .z(z_gray));
	gray_to_bin gray_to_bin1 (.x(z_gray), .z(z_bin));

	// Input initialization and simulation control
	initial begin
		// Initially all the inputs are zero
		x = 4'b0000;

		// Waveform generation statements
		/* $dumpfile("gray_tb.vcd"); */
		/* $dumpvars(0,test); */

		// Output printing
		/* 'z_bin' should be equal to 'x' if the converters are working
		 * correctly. */
		$display("     ----------  z_gray  ----------         ");
		$display("x --| bin/gray |--------| gray/bin |-- z_bin");
		$display("     ----------          ----------         ");
		$display(" ");
		$display("x\tz_gray\tz_bin ");
		$display("---------------------");
		$monitor("%b\t%b\t%b", x, z_gray, z_bin);

		// Simulation end
		/* We will apply a new input pattern every BTIME ns. Simulation
		 * end time is calculated from BTIME so that we simulate 16
		 * input patterns (all the posibilities). */
		#(16*`BTIME) $finish;
	end

	// Input pattern generation
	/* Just incrementing 'x' is enough to generate all the possible input
	 * patterns. */
	always
		#(`BTIME) x = x + 1;

endmodule // test

/*
   EXERCISES

   1. Compile the test bench with:

        $ iverilog gray.v gray_tb.v

   2. Simulate the design with:

        $ vvp a.out

   3. Modify the test bench to simulate 8-bit bin/gray and gray/bin 
      converters. Check the results.
*/

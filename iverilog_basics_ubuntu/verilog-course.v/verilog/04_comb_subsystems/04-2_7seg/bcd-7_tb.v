// Design:      bcd-7
// File:        bcd-7_tb.v
// Description: BCD to 7-segment converter. Test bench
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        28/10/2010 (initial version)

`timescale 1ns / 1ps

// Time base to easy simulation control
`define BTIME 10

module test();

	// Inputs
	reg [3:0] d;

	// Output
	wire [0:6] seg;

	// UUT instance
	sseg uut (.d(d), .seg(seg));

	// Input initialization and simulation control
	initial begin
		// 'd' is initiated to '0'
		d = 0;

		// Waveform generation statements
		// $dumpfile("test.vcd");
		// $dumpvars(0,test);

		// Results printing
		$display("d\tseg");
		$monitor("%d\t%b", d, seg);

		// Simulation end after 16 ciclyes
		#(16*`BTIME) $finish;
	end

	// Input pattern generation
	always
		#(`BTIME) d = d + 1;

endmodule // test

/*
   EXERCISES

   1. Compile the test bench with:

        $ iverilog bcd-7.v bcd-7_tb.v

   2. Simulate the design with:

        $ vvp a.out

   3. Check the results printed in the terminal and check that the 'seg' values
      correspond to the input 'd'.
*/
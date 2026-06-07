// Design:      uregister
// File:        register.v
// Description: Universal register.
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        17-12-2010 (initial version)


/*
   Lesson 7.1: Universal register.

   This file contains a test bench for the module in file 'register.v'.
 */

`timescale 1ns / 1ps

// Test bench

module test ();

    reg clk = 0;	// clock
    reg load = 0;	// data load
    reg shr = 0;	// right shift
    reg shl = 0;	// left shift
    reg xr = 0;		// serial input for shr
    reg xl = 0;		// serial input for shl
    reg [7:0] x;	// data input for data load
    wire [7:0] z;	// output

    // Instantiation of the Unit Under Test
    /* We instantiate an 8 bit register. Remember that the width of the
     * register is a parameter. */
    uregister #(8) uut (.clk(clk), .load(load), .shr(shr), .shl(shl),
                   .xr(xr), .xl(xl), .x(x), .z(z));

    // Simulation output control
    initial	begin
        // Waveform generation
        $dumpfile("register_tb.vcd");
        $dumpvars(0, test);

        /* No text output this time */
    end

    // Clock signal with a period of 20ns (f=50MHz)
    always
        #10 clk = ~clk;

    // Inputs
    /* The synchronous operations are done with the positive clock edge.
     * Inputs are changed at the negative edge to ensure a correct
     * operation. We use "@(negedge ck)" and "repeat" to make the inputs
     * change at useful clock edges. */
    initial begin
        @(negedge clk)			// prepare data to be loaded
        x = 8'b00110101;
        load = 1;
        @(negedge clk)              // wait one clock cycle and
        load = 0;                   // deactivate the load signal
        @(negedge clk)              // activate shr and let actuate for
        shr = 1;                    // 4 clock cycles
        repeat(4) @(negedge clk);
        xr = 1;                     // still shr but now xr=1
        repeat(4) @(negedge clk);
        x = 8'b01010001;            // prepare new data load and
        load = 1;                   // deactivate shr
        shr = 0;
        @(negedge clk)
        load = 0;                   // deactivate the data load
        @(negedge clk)
        shl = 1;                    // now we do a shl first with xl=0
        repeat(4) @(negedge clk);   // then with xl=1
        xl = 1;
        repeat(4) @(negedge clk);
        shl = 0;                    // wait to more cycles whithout doing
        repeat(2) @(negedge clk);   // any operation
        $finish;
    end

endmodule // test


/*
   EXERCISES

   1. Compile and simulate the examples with:

      $ iverilog register.v register_tb.v
      $ vvp a.out

   2. Display the results with:

      $ gtkwave register_tb.vcd

   3. Modify the design so that the load operation has an asynchronous
      behavior.

   4. Modify the design to include an asynchronous clear operation.
*/

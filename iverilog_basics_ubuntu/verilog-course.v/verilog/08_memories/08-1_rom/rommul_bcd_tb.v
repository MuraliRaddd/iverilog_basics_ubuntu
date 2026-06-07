// Design:      rommul_bcd
// File:        rommul_bcd_tb.v
// Description: ROM-based 4-bit BCD multiplier. Test bench.
// Author:      Jorge Juan-Chico <jjchico@dte.us.es>
// Date:        16-01-2013 (initial version)

/*
   Lesson 8.1. ROM-based 4-bit BCD multiplier.

   This file contains a test bench to test module rommul_bcd in file
   'rommul_bcd.v'.
 */
`timescale 1ns / 1ps

// Test bench: try all possible multiplications and detect possible errors.

module test ();

    reg  [3:0] x, y;    // input data
    wire [7:0] z;       // BCD output
    reg  [7:0] zd;      // decimal output
    reg  [7:0] ze;      // expected value
    reg  err = 0;       // error indicator

    // Unit Under Test
    rommul_bcd uut(.x(x), .y(y), .z(z));

    // Testing process
    /* Most test benches in previous lessons just display the result of all or
     * a limited set of the input values and the user has to check their
     * correctness. In practice, when the number of possible input patterns
     * is big, a test bench is much more useful when it can check the results
     * automatically and tell the user when there is an error. This strategy
     * is used in this example by comparing the expected value calculated by
     * the test bench itself with the value obtained from the circuit under
     * test. These "automatic" test benches are more difficult to program but
     * they are necessary to test non-trivial designs.
     */

    // Two nested loops run through all possible input values.
    initial begin
        for (x=0; x<10; x=x+1)
            for (y=0; y<10; y=y+1) begin
                #10;    // let some time for the simulator to obtain the result
                        // from the UUT
                zd = z[7:4]*10 + z[3:0];  // convert the result to decimal
                ze = x * y;               // calculate the expected value
                if (zd != ze) begin
                    $display("ERROR: %d * %d = %d <%b> (expected %d)",
                             x, y, zd, z, ze);
                    err = 1'b1;
                end
            end
        if (err)
            $display("The circuit has errors. Check the design.");
        else
            $display("No errors detected.");
    end

endmodule // test

/*
   EXERCISES

   2. Compile the test bench with:

        $ iverilog rommul_bcd.v rommul_bcd_tb.v

      and test its operation with:

        $ vvp a.out

      Take a look at the output text and waveforms (with gtkwave) and check
      that the operation is correct. Correct the errors if any.

   3. Modify the design of the multiplier (you can work on a copy of file
      rommul_bcd.v) to convert it into a decimal multiplier of 4-bit numbers.
      Inputs are now numbers from 0 to 15 and the output is the result of
      the multiplication encoded in natural binary with 8 bits. Modify the
      test bench accordingly and use it to test the design.
*/

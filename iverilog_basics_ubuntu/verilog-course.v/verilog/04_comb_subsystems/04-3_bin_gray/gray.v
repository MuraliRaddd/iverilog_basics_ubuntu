// Design: 	    gray
// File:        gray.v
// Description: Parametrized bin/gray converters
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        12/11/2011 (initial version)

/*
   Lesson 4.3: Parameterized binary to/from Gray converters.

   Code converters are very popular building blocks in digital circuits.
   Gray code is very useful when encoding the position of mechanical 
   systems and other variables that can vary continuously like pressure,
   temperature, etc. Since adjacent values in Gray code only differ in
   one bit, it avoids miss-interpretation of data due to different bits
   changing at slightly different times. Natural binary and Gray code values
   are shown below for 3-digit codes:

   N    bin     Gray
   -----------------
   0    000     000
   1    001     001
   2    010     011
   3    011     010
   4    100     110
   5    101     111
   6    110     101
   7    111     100

   Gray code is said to be a "reflecting" code because the code for 2 bits can
   be obtained by writing the code for 1 bit in reverse order (reflecting) and
   adding a '1' to se second half of the code. And the same can be done to
   obtain the code for 'n' bits from the code for 'n-1' bits.

   To use Gray encoding we need binary to Gray and Gray to binary converter
   circuits. They are easy to implement using XOR (eXclusive OR) gates. Visit
   http://www.wisc-online.com/Objects/ViewObject.aspx?ID=IAU8307
   for a nice explanation of bin/Gray conversion fundamentals.

   In this lesson we implement these converters in a clever way. We'll use
   very compact expressions that can be described with a simple 'assign'
   and we will define the number of bits of the signals as a parameter so
   that we can instantiate converters of any size.
*/

`timescale 1ns / 1ps

// Bin/Gray converter

module bin_to_gray #(
    parameter n = 4
    )(
    input wire [n-1:0] x,
    output wire [n-1:0] z
    );

    /* From comparing the binary and Gray tables we see that every bit in 'z'
     * can be calculated by XORing the corresponding bit of 'x' with the
     * next bit of 'x', except for the leftmost bit which is the same:
     * 
     *    z[i] = x[i] ^ x[i+1]; z[n-1] = x[n]
     *
     * We can do it for all the bits of 'z' with a loop, but using the 
     * displacement operator smartly we can obtain all the bits of 'z' with 
     * a single assignment. */
    assign z = x ^ (x >> 1);

endmodule	// bin_gray


// Gray/bin converter

module gray_to_bin #(
    parameter n = 4
    )(
    input wire [n-1:0] x,
    output wire [n-1:0] z
    );

    /* From comparing the binary and Gray tables we see that every bit in 'z'
     * can be calculated by XORing the corresponding bit of 'x' with the
     * next bit of 'z', except for the leftmost bit which is the same:
     * 
     *    z[i] = x[i] ^ z[i+1]; z[n-1] = x[n]
     *
     * We can do it for all the bits of 'z' with a loop, but using the 
     * displacement operator smartly we can obtain all the bits of 'z' with 
     * a single assignment. Note that using 'z' on the right hand side of
     * the assignment here is fine because at the time each individual bit
     * of 'z' is assigned all the needed bits of 'z' are already known. */
    assign z = x ^ (z >> 1);

endmodule	// gray_bin

/*
   EXERCISES

   Check that the design syntax is correct by compiling the file with:

      $ iverilog gray.v

   (This example continues in file gray_tb.v)
*/

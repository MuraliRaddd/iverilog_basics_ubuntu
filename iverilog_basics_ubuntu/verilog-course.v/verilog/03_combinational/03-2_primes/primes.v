// Design:      primes
// File:        primes.v
// Description: Prime number detector
// Author:      Jorge Juan-Chico <jjchico@gmail.com>
// Date:        09/11/2018 (initial version)

/*
   Lesson 3.2: 4-bit prime number detector.

   This design is a 4-bit prime number detector. When the input bits
   are the natural binary (base 2) representation of a prime number, the
   output signal of the circuit is set to '1'. In other case, it is set
   to '0'.

   In this example the following concepts are trained:

     - Multi-bit signals (vectors).
     - Test pattern generation usin a counter.
*/

`timescale 1ns / 1ps

// Prime number detector

module primes (
    /* Verilog signal can have multiple bits. The range of bits in the signal
     * is defined right after the type of signal as [m:n], for example "[1:7]"
     * or "[7:0]". In most cases, the range is defined starting with the
     * greater index in the range, since it is the most convenient way when
     * dealing with signals that represent binary number. For example:
     *   reg [7:0] x;
     * A multi-bit signal can be assigned any number and its binary
     * representation will be stored in the signal. We can also access the
     * value of a particular bit using the bracket operator as 'x[i]'.
     * Example:
     *   assign a = x[3];
     * We can also extract a sub-range of bits using the same operator.
     * Examples:
     *   wire [3:0] a;
     *   wire [7:0] x;
     *   assign x = 184;
     *   assign a = x[7:4];
     */
    input wire [3:0] x, // input data (4 bits)
    output reg z        // output. 0-no prime, 1-prime
    );

    /* We use a procedural description for the circuit */
    always @* begin
        /* With the 'case' sentence we can execute a different operation
         * depending on the value of a variable or expression. In our case,
         * it is specially convenient since the output only depends on "x".*/
        case(x)         /* expression to test */
        2:  z = 1;      /* action in case the value is "2" */
        3:  z = 1;      /* etc. */
        5:  z = 1;
        7:  z = 1;
        11: z = 1;
        13: z = 1;
        default: z = 0; /* action in any other case
                         * Note that a combinational circuit should always
                         * generate an output value for any input value, so
                         * the 'default' is necessary in most cases when a
                         * 'case' statement to describe combinational
                         * behavior. */
        endcase
    end

endmodule // primes

/*
   The lesson continues in file primes_tb.v
*/
